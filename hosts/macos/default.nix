{
  self,
  vars,
  nixpkgs,
  ...
}: let
  system = "aarch64-darwin";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    hostPlatform = system;
  };

  apps = import ../../modules/packages pkgs;
in {
  imports = [./brew.nix (import ./home-manager.nix {inherit vars pkgs;})];

  nix = {
    enable = true;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs = {inherit pkgs;};

  environment.systemPackages = with apps; defaults ++ devTools;

  programs.zsh.enable = true;
  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.2;
        autohide-time-modifier = 0.5;
        magnification = false;
        mineffect = "scale";
        minimize-to-application = true;
        orientation = "bottom";
        showhidden = false;
        show-recents = false;
        tilesize = 50;
      };
      finder = {
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      CustomUserPreferences = {
        "com.apple.finder" = {
          NewWindowTargetPath = "file:///Users/${vars.user}/";
          NewWindowTarget = "PfHm";
          FXDefaultSearchScope = "SCcf";
          FinderSpawnTab = true;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "/Users/${vars.user}/Library/Preferences/ByHost/com.apple.controlcenter".BatteryShowPercentage = true;
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      };
    };
    primaryUser = vars.user;
    stateVersion = 6;
  };
}
