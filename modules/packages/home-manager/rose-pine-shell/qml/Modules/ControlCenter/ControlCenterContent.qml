import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Modules.ControlCenter.Components
import qs.Modules.ControlCenter.Details
import qs.Modules.ControlCenter.Widgets
import qs.Services
import qs.Widgets

Rectangle {
    id: root
    required property var host
    property alias bluetoothCodecSelector: codecSelector
    property alias audioPortSelector: portSelector
    readonly property bool expanded: host.expandedSection.length > 0
    readonly property real targetImplicitHeight: body.implicitHeight + 32
    implicitHeight: targetImplicitHeight
    color: "transparent"

    component Tile: Rectangle {
        id: tile
        property string label: ""
        property string subtitle: ""
        property string iconName: ""
        property bool active: false
        signal toggled
        signal detailsRequested
        height: 64
        radius: 16
        color: active ? Theme.primary : hover.containsMouse ? Theme.surfaceVariant : Theme.nestedSurface
        opacity: enabled ? 1 : 0.45
        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8
            DankIcon { name: tile.iconName; size: 18; color: tile.active ? Theme.primaryText : Theme.surfaceText }
            Column {
                Layout.fillWidth: true
                spacing: 2
                StyledText { width: parent.width; text: tile.label; elide: Text.ElideRight; font.pixelSize: Theme.fontSizeSmall; color: tile.active ? Theme.primaryText : Theme.surfaceText }
                StyledText { width: parent.width; text: tile.subtitle; elide: Text.ElideRight; font.pixelSize: 11; color: tile.active ? Theme.primaryText : Theme.surfaceVariantText }
            }
            DankActionButton { iconName: "chevron_right"; iconSize: 14; buttonSize: 22; iconColor: tile.active ? Theme.primaryText : Theme.surfaceText; onClicked: tile.detailsRequested() }
        }
        MouseArea { id: hover; anchors.fill: parent; z: -1; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: tile.toggled() }
    }

    DankFlickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: body.implicitHeight + 32
        clip: true
        interactive: contentHeight > height
        Column {
            id: body
            x: 16
            y: 16
            width: parent.width - 32
            spacing: 10
            RowLayout {
                width: parent.width
                height: 28
                DankActionButton { visible: root.expanded; iconName: "arrow_back"; buttonSize: 28; onClicked: root.host.collapseAll() }
                StyledText { text: root.expanded ? "Controls" : "Control Center"; Layout.fillWidth: true; color: Theme.surfaceText; font.pixelSize: Theme.fontSizeLarge }
                DankActionButton { iconName: "settings"; buttonSize: 28; onClicked: { root.host.close(); PopoutService.openSettingsWithTab("appearance"); } }
            }
            RoseMediaCard { width: parent.width; visible: !root.expanded; live: root.host.shouldBeVisible }
            Grid {
                width: parent.width
                columns: 2
                spacing: 8
                visible: !root.expanded
                Tile {
                    width: (parent.width - 8) / 2
                    label: "Wi-Fi"; subtitle: NetworkService.wifiConnected ? NetworkService.currentWifiSSID : "Not connected"; iconName: NetworkService.wifiSignalIcon; active: NetworkService.wifiEnabled
                    onToggled: NetworkService.toggleWifiRadio()
                    onDetailsRequested: root.host.toggleSection("wifi")
                }
                Tile {
                    width: (parent.width - 8) / 2
                    label: "Bluetooth"; subtitle: BluetoothService.connected ? "Connected" : "No devices"; iconName: "bluetooth"; active: BluetoothService.enabled; enabled: BluetoothService.available
                    onToggled: BluetoothService.toggleBluetooth()
                    onDetailsRequested: root.host.toggleSection("bluetooth")
                }
                Tile {
                    width: (parent.width - 8) / 2
                    label: "Hotspot"; subtitle: NetworkService.hotspotEnabled ? NetworkService.hotspotSSID : NetworkService.hotspotAvailable ? "Off" : "Unavailable"; iconName: "wifi_tethering"; active: NetworkService.hotspotEnabled; enabled: NetworkService.hotspotAvailable
                    onToggled: {
                        if (NetworkService.hotspotEnabled) NetworkService.stopHotspot();
                        else root.host.toggleSection("hotspot");
                    }
                    onDetailsRequested: root.host.toggleSection("hotspot")
                }
                Tile {
                    width: (parent.width - 8) / 2
                    label: "VPN"; subtitle: DMSNetworkService.connected ? "Connected" : "Off"; iconName: "vpn_key"; active: DMSNetworkService.connected; enabled: VPNService.available
                    onToggled: root.host.toggleSection("vpn")
                    onDetailsRequested: root.host.toggleSection("vpn")
                }
                Tile {
                    width: (parent.width - 8) / 2
                    label: "Focus"; subtitle: SessionData.doNotDisturb ? "Do not disturb" : "Notifications on"; iconName: "do_not_disturb_on"; active: SessionData.doNotDisturb
                    onToggled: SessionData.setDoNotDisturb(!SessionData.doNotDisturb)
                    onDetailsRequested: SessionData.setDoNotDisturb(!SessionData.doNotDisturb)
                }
                Tile {
                    width: (parent.width - 8) / 2
                    label: "Microphone"; subtitle: AudioService.source?.audio?.muted ? "Muted" : "On"; iconName: AudioService.source?.audio?.muted ? "mic_off" : "mic"; active: !(AudioService.source?.audio?.muted ?? true); enabled: AudioService.source?.audio != null
                    onToggled: AudioService.source.audio.muted = !AudioService.source.audio.muted
                    onDetailsRequested: root.host.toggleSection("audioInput")
                }
            }
            Rectangle {
                width: parent.width; height: 70; radius: 16; color: Theme.nestedSurface; visible: !root.expanded
                StyledText { x: 12; y: 8; text: "Display brightness"; color: Theme.surfaceText; font.pixelSize: Theme.fontSizeSmall }
                BrightnessSliderRow { x: 8; y: 26; width: parent.width - 16; screenName: root.host.triggerScreen?.name ?? ""; parentScreen: root.host.triggerScreen; onIconClicked: root.host.toggleSection("brightness") }
            }
            Rectangle {
                width: parent.width; height: 70; radius: 16; color: Theme.nestedSurface; visible: !root.expanded
                StyledText { x: 12; y: 8; text: "Sound"; color: Theme.surfaceText; font.pixelSize: Theme.fontSizeSmall }
                DankActionButton { anchors.right: parent.right; anchors.rightMargin: 8; y: 2; iconName: "chevron_right"; buttonSize: 24; onClicked: root.host.toggleSection("audio") }
                AudioSliderRow { x: 8; y: 26; width: parent.width - 16 }
            }
            Rectangle {
                width: parent.width; height: 56; radius: 16; color: Theme.nestedSurface; visible: !root.expanded
                DankIcon { x: 16; anchors.verticalCenter: parent.verticalCenter; name: BatteryService.getBatteryIcon(); size: 20; color: Theme.primary }
                Column {
                    x: 58; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 104; spacing: 2
                    StyledText { text: BatteryService.batteryAvailable ? BatteryService.batteryStatus : "Power"; color: Theme.surfaceText; font.pixelSize: Theme.fontSizeSmall }
                    StyledText { text: PowerProfileWatcher.available ? Theme.getPowerProfileLabel(PowerProfileWatcher.currentProfile) : "Power profiles unavailable"; color: Theme.surfaceVariantText; font.pixelSize: 11 }
                }
                DankActionButton { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; anchors.rightMargin: 10; iconName: "chevron_right"; buttonSize: 28; onClicked: root.host.toggleSection("battery") }
                MouseArea { anchors.fill: parent; z: -1; cursorShape: Qt.PointingHandCursor; onClicked: root.host.toggleSection("battery") }
            }
            Loader {
                width: parent.width
                active: root.expanded
                sourceComponent: Component { RoseDetails { kind: root.host.expandedSection; host: root.host } }
            }
        }
    }
    BluetoothCodecSelector { id: codecSelector; anchors.fill: parent; visible: false; z: 20 }
    AudioPortSelector { id: portSelector; anchors.fill: parent; visible: false; z: 20 }
}
