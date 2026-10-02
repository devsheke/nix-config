import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Services
import qs.Widgets

BasePill {
    id: root
    property string kind: "wifi"
    readonly property string iconName: kind === "wifi" ? NetworkService.wifiSignalIcon : kind === "bluetooth" ? (BluetoothService.enabled ? "bluetooth" : "bluetooth_disabled") : kind === "audio" ? AudioService.volumeIconName(AudioService.sink) : "speed"
    readonly property string description: kind === "wifi" ? (NetworkService.wifiConnected ? NetworkService.currentWifiSSID : "Wi-Fi " + (NetworkService.wifiEnabled ? "disconnected" : "off")) : kind === "bluetooth" ? "Bluetooth " + (BluetoothService.enabled ? "on" : "off") : kind === "audio" ? (AudioService.sink?.audio?.muted ? "Muted" : "Volume " + Math.round((AudioService.sink?.audio?.volume ?? 0) * 100) + "%") : "Stats"
    RoseBarTooltip { id: tooltip }
    onIsMouseHoveredChanged: {
        if (isMouseHovered) tooltip.showFor(description, root, parentScreen);
        else tooltip.hide();
    }
    onWheel: event => {
        if (kind !== "audio" || !AudioService.sink?.audio) return;
        const delta = event.angleDelta.y || event.pixelDelta.y;
        if (!delta) return;
        AudioService.sink.audio.volume = Math.max(0, Math.min(AudioService.sinkMaxVolume / 100, AudioService.sink.audio.volume + (delta > 0 ? 1 : -1) * AudioService.wheelVolumeStep / 100));
        event.accepted = true;
    }
    content: Component {
        Item {
            implicitWidth: 14
            implicitHeight: 14
            DankIcon {
                anchors.centerIn: parent
                name: root.iconName
                size: 14
                color: Theme.widgetIconColor
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                enabled: root.kind === "audio"
                onClicked: if (AudioService.sink?.audio) AudioService.sink.audio.muted = !AudioService.sink.audio.muted
            }
        }
    }
}
