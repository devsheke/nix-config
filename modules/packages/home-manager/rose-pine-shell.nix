{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.programs.rose-pine-shell;
  colors = config.lib.stylix.colors.withHashtag;
  json = pkgs.formats.json {};
  customizedDms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell.overrideAttrs (old: {
    postInstall =
      old.postInstall
      + ''
        chmod -R u+w $out/share/quickshell/dms
        ${pkgs.patch}/bin/patch --batch --forward --fuzz=0 -p1 -d $out/share/quickshell/dms < ${./rose-pine-shell/shell.patch}
        cp -r ${./rose-pine-shell/qml}/. $out/share/quickshell/dms/
        substituteInPlace $out/share/quickshell/dms/Modules/ControlCenter/Components/RoseNvidiaMetrics.qml \
          --replace-fail '@nvidiaMetricsPython@' '${pkgs.python3}/bin/python' \
          --replace-fail '@nvidiaMetricsScript@' '${../../../scripts/rose-pine-nvidia-metrics.py}'
      '';
  });
  calculatorSource = pkgs.fetchFromGitHub {
    owner = "rochacbruno";
    repo = "DankCalculator";
    rev = "c9fbbe921e9afeb92f4e92390e9fc05f006f0373";
    sha256 = "1bw92awx8wa9vj01hwg0ji3z87i43g1808b1yf5clni0vay578bn";
  };
  calculator = pkgs.runCommand "rose-pine-calculator-0.3.4" {} ''
    mkdir -p $out
    cp -r ${calculatorSource}/. $out/
    chmod -R u+w $out
    cp ${./rose-pine-shell/QalcService.qml} $out/QalcService.qml
    substituteInPlace $out/CalculatorLauncher.qml \
      --replace-fail '["dms", "cl", "copy", text]' '["dms", "cl", "copy", "--", text]' \
      --replace-fail 'action: "copy:" + result,' 'action: result.startsWith("Error:") ? "none" : "copy:" + result,'
  '';
  theme = {
    name = "Rose Pine Glass";
    primary = colors.base0A;
    primaryText = colors.base00;
    primaryContainer = colors.base02;
    secondary = colors.base0D;
    surface = colors.base01;
    surfaceText = colors.base05;
    surfaceVariant = colors.base02;
    surfaceVariantText = colors.base04;
    surfaceTint = colors.base0A;
    background = colors.base00;
    backgroundText = colors.base05;
    outline = colors.base0F;
    surfaceContainerLowest = colors.base00;
    surfaceContainerLow = colors.base01;
    surfaceContainer = colors.base01;
    surfaceContainerHigh = colors.base02;
    surfaceContainerHighest = colors.base02;
    error = colors.base08;
    warning = colors.base09;
    info = colors.base0C;
  };
  themeFile = json.generate "rose-pine-glass.json" {
    dark = theme;
    light = theme;
  };
  sessionDefaults = json.generate "rose-pine-shell-session.json" {
    configVersion = 4; # DMS 1.6.2 session schema
    isLightMode = false;
    themeModeAutoEnabled = false;
    wallpaperPath = toString cfg.wallpaper;
    wallpaperPathDark = toString cfg.wallpaper;
    wallpaperPathLight = toString cfg.wallpaper;
    wallpaperCyclingEnabled = false;
    terminalOverride = "ghostty";
    pinnedApps = cfg.pinnedApps;
  };
  seedSession = pkgs.writeShellScript "rose-pine-shell-seed-session" ''
    set -eu
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/DankMaterialShell"
    ${pkgs.coreutils}/bin/install -d -m 700 "$state_dir"
    # Appearance is immutable; runtime state must be a regular, writable file.
    if [ ! -e "$state_dir/session.json" ]; then
      ${pkgs.coreutils}/bin/install -m 600 ${sessionDefaults} "$state_dir/session.json"
    fi
    ${pkgs.python3}/bin/python ${../../../scripts/migrate-rose-pine-shell-session.py} "$state_dir" ${sessionDefaults}
    ${pkgs.coreutils}/bin/install -d -m 700 \
      "''${XDG_DATA_HOME:-$HOME/.local/share}/khal/calendars/personal"
  '';
in {
  options.programs.rose-pine-shell = {
    enable = lib.mkEnableOption "the Rose Pine glass desktop shell";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = config.stylix.image;
      description = "Wallpaper used to seed the writable DMS session.";
    };
    pinnedApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "com.mitchellh.ghostty"
        "org.kde.dolphin"
        "brave-browser"
        "md.obsidian.Obsidian"
        "onlyoffice-desktopeditors"
        "chatgpt"
        "spotify"
        "steam"
      ];
      description = "Desktop-entry IDs used for the initial dock pins.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Stylix's automatic DMS target also makes session.json read-only. Build a
    # palette from Stylix here instead, so wallpaper, DND and pins can persist.
    stylix.targets.dank-material-shell.enable = false;

    programs.dank-material-shell = {
      enable = true;
      package = customizedDms;
      systemd.enable = true;
      systemd.target = "graphical-session.target";
      enableDynamicTheming = false;
      enableAudioWavelength = false;
      enableSystemMonitoring = true;
      enableCalendarEvents = true;
      session = {};
      plugins.calculator = {
        src = calculator;
        settings = {
          trigger = "=";
          noTrigger = false;
          calcEngine = "qalc";
          qalcCommand = ''${pkgs.libqalculate}/bin/qalc --defaults -t --set "decimal comma off" --set "update exchange rates 1"'';
          persistHistoryOnFile = false;
        };
      };
      clipboardSettings = {
        disabled = true;
        disableHistory = true;
        disablePersist = true;
      };

      settings = {
        configVersion = 18; # DMS 1.6.2 settings schema
        currentThemeName = "custom";
        customThemeFile = toString themeFile;
        runDmsMatugenTemplates = false;
        runUserMatugenTemplates = false;
        fontFamily = config.stylix.fonts.monospace.name;
        monoFontFamily = config.stylix.fonts.monospace.name;
        fontScale = 1.0;
        focusedWindowSize = 0;
        iconThemeDark = config.gtk.iconTheme.name;
        iconThemeLight = config.gtk.iconTheme.name;
        syncModeWithPortal = false;
        cornerRadius = 16;
        popupTransparency = 0.90;
        dockTransparency = 0.80;
        blurEnabled = true;
        blurForegroundLayers = true;
        foregroundLayerTransparency = 0.90;
        blurBorderEnabled = true;
        blurBorderColor = "outline";
        blurBorderOpacity = 0.35;
        widgetBackgroundColor = "sc";
        m3ElevationIntensity = 6;
        m3ElevationOpacity = 25;
        barElevationEnabled = false;
        animationSpeed = 4; # AnimationSpeed.Custom
        customAnimationDuration = 180;
        popoutCustomAnimationDuration = 180;
        modalCustomAnimationDuration = 180;
        notificationAnimationSpeed = 4;
        notificationCustomAnimationDuration = 180;
        springBounce = 0;
        enableRippleEffects = false;
        soundsEnabled = false;

        clockFormat = "24h";
        clockDateFormat = "ddd MMM dd HH:mm yyyy";
        showSeconds = false;
        showWorkspaceIndex = false;
        showWorkspaceApps = false;
        groupWorkspaceApps = true;
        groupActiveWorkspaceApps = true;
        workspaceScrolling = true;
        showWeather = false;
        weatherEnabled = false;
        useAutoLocation = false;
        showClipboard = false;
        showCpuUsage = false;
        showMemUsage = false;
        showMusic = true;
        audioVisualizerEnabled = false;
        trayMaxVisibleItems = 4;
        trayIconSpacing = 4;
        showBatteryPercent = true;
        batteryStyle = "icon";
        controlCenterShowNetworkIcon = false;
        controlCenterShowBluetoothIcon = false;
        controlCenterShowAudioIcon = false;
        controlCenterShowMicrophoneIcon = false;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;
        controlCenterShowIdleInhibitorIcon = false;
        controlCenterShowDoNotDisturbIcon = false;
        controlCenterShowVpnIcon = false;
        controlCenterShowScreenSharingIcon = false;
        controlCenterShowAudioPercent = false;
        calendarBackend = "khal";
        defaultTaskCalendarId = "personal";
        controlCenterWidgets = [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "brightnessSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "bluetooth";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "audioInput";
            enabled = true;
            width = 50;
          }
          {
            id = "battery"; # Includes the power profile selector.
            enabled = true;
            width = 50;
          }
          {
            id = "doNotDisturb";
            enabled = true;
            width = 50;
          }
        ];
        dashTabs = [
          {
            id = "overview";
            enabled = true;
          }
          {
            id = "media";
            enabled = true;
          }
          {
            id = "wallpaper";
            enabled = true;
          }
          {
            id = "weather";
            enabled = false;
          }
          {
            id = "settings";
            enabled = true;
          }
        ];

        barConfigs = [
          {
            id = "default";
            name = "Rose Pine Menu Bar";
            enabled = true;
            position = 0;
            screenPreferences = ["all"];
            showOnLastDisplay = true;
            leftWidgets = [
              "powerMenuButton"
              "workspaceSwitcher"
              "focusedWindow"
            ];
            centerWidgets = ["clock"];
            rightWidgets = [
              "music"
              "wifiButton"
              "bluetoothButton"
              "volumeButton"
              "systemMetricsButton"
              "battery"
              "notificationButton"
              "controlCenterButton"
              "systemTray"
            ];
            spacing = 4;
            innerPadding = 0;
            barInsetPadding = 0;
            barLengthPadding = 0;
            bottomGap = 0;
            attachToScreenEdge = true;
            squareCorners = true;
            transparency = 0.85;
            widgetTransparency = 0.0;
            widgetPadding = 6;
            fontScale = 1.10;
            iconScale = 1.0;
            autoHide = false;
            visible = true;
            borderEnabled = false;
            widgetOutlineEnabled = false;
            useOverlayLayer = false;
            scrollEnabled = true;
            scrollYBehavior = "workspace";
            popupGapsAuto = false;
            popupGapsManual = 8;
            shadowIntensity = 0;
            hoverPopouts = false;
          }
        ];
        showDock = true;
        dockPosition = 1; # Position.Bottom
        dockAutoHide = true;
        dockSmartAutoHide = false;
        dockUseOverlayLayer = false;
        dockShowOnFullscreen = false;
        dockGroupByApp = true;
        dockSeparatePinnedAndRunningApps = false;
        dockRestoreSpecialWorkspaceOnClick = true;
        dockIconSize = 44;
        dockSpacing = 8;
        dockBottomGap = 12;
        dockIndicatorStyle = "circle";
        dockBorderEnabled = true;
        dockBorderColor = "outline";
        dockBorderOpacity = 0.35;
        screenPreferences.dock = ["all"];
        launcherStyle = "spotlight";
        spotlightModalViewMode = "list";
        dankLauncherV2Size = "compact";
        launcherUseOverlayLayer = true;
        rememberLastQuery = false;
        frameEnabled = false;

        notificationHistoryEnabled = true;
        notificationHistoryMaxCount = 100;
        notificationDndAllowCritical = true;
        notificationPopupPosition = 0; # Top right
        osdVolumeEnabled = true;
        osdBrightnessEnabled = true;
        osdMicMuteEnabled = true;
        osdAlwaysShowValue = true;
        customPowerActionLock = "${pkgs.hyprlock}/bin/hyprlock";
        loginctlLockIntegration = false;
        lockAtStartup = false;
        lockBeforeSuspend = false;
        acMonitorTimeout = 0;
        acLockTimeout = 0;
        acSuspendTimeout = 0;
        batteryMonitorTimeout = 0;
        batteryLockTimeout = 0;
        batterySuspendTimeout = 0;
        powerMenuActions = [
          "lock"
          "suspend"
          "logout"
          "reboot"
          "poweroff"
        ];
        updaterHideWidget = true;
        updaterCheckOnStart = false;
      };
    };

    home.packages = [pkgs.libqalculate];

    systemd.user.services.dms.Service = {
      ExecStartPre = [(toString seedSession)];
      Environment = [
        "DMS_DISABLE_POLKIT=1"
        "DMS_DISABLE_MATUGEN=1"
        "TERMINAL=ghostty"
      ];
    };

    # BlueZ/NetworkManager remain enabled; DMS supplies their tray controls.
    xdg.configFile."autostart/blueman.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Blueman Applet
      Hidden=true
    '';
    xdg.configFile."autostart/nm-applet.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=NetworkManager Applet
      Hidden=true
    '';

    xdg.configFile."khal/config".text = ''
      [calendars]
      [[personal]]
      path = ${config.xdg.dataHome}/khal/calendars/personal
      type = calendar

      [locale]
      timeformat = %H:%M
      dateformat = %Y-%m-%d
      longdateformat = %Y-%m-%d
      datetimeformat = %Y-%m-%d %H:%M
      longdatetimeformat = %Y-%m-%d %H:%M
      default_timezone = Asia/Kolkata
      local_timezone = Asia/Kolkata

      [default]
      default_calendar = personal
    '';
  };
}
