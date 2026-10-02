import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Modals.Common
import qs.Services
import qs.Widgets

Column {
    id: root
    property bool editing: !NetworkService.hotspotConfigured
    readonly property bool busy: NetworkService.hotspotBusy || NetworkService.hotspotActivating
    spacing: 12
    ConfirmModal { id: startConfirm }
    function start() {
        if (!NetworkService.wifiEnabled) { ToastService.showError("Enable Wi-Fi before starting the hotspot."); return; }
        const action = () => {
            if (editing) NetworkService.configureAndStartHotspot(ssid.text.trim(), password.text, "", "", response => {
                if (!response.error) { root.editing = false; password.text = ""; }
            });
            else NetworkService.startHotspot();
        };
        if (NetworkService.hotspotTargetWouldDisconnectWifi(NetworkService.hotspotDevice || NetworkService.wifiInterface)) {
            startConfirm.showWithOptions({title: "Start hotspot?", message: "This will disconnect Wi-Fi from “" + NetworkService.currentWifiSSID + "”. Internet sharing requires another connection, such as Ethernet.", confirmText: "Start", onConfirm: action});
        } else action();
    }
    StyledText { text: "Personal hotspot"; color: Theme.surfaceText; font.pixelSize: Theme.fontSizeLarge }
    StyledText {
        width: parent.width
        wrapMode: Text.WordWrap
        text: !NetworkService.hotspotAvailable ? "Hotspot is unavailable on the current adapter." : root.busy ? "Starting…" : NetworkService.hotspotEnabled ? "Sharing as " + NetworkService.hotspotSSID : NetworkService.hotspotConfigured ? NetworkService.hotspotSSID + " · Off" : "Set up a secured Wi-Fi hotspot."
        color: Theme.surfaceVariantText
    }
    DankTextField { id: ssid; width: parent.width; visible: root.editing; text: NetworkService.hotspotSSID || "Sanguinius"; placeholderText: "Network name"; maximumLength: 32 }
    DankTextField { id: password; width: parent.width; visible: root.editing; placeholderText: "Password · 8–63 characters"; echoMode: TextInput.Password; maximumLength: 63 }
    Rectangle {
        width: parent.width
        height: 40
        radius: 20
        color: Theme.primary
        opacity: actionArea.enabled ? 1 : 0.5
        StyledText { anchors.centerIn: parent; text: NetworkService.hotspotEnabled ? "Stop hotspot" : "Start hotspot"; color: Theme.primaryText }
        MouseArea {
            id: actionArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: NetworkService.hotspotAvailable && !root.busy && (!root.editing || (ssid.text.trim().length > 0 && password.text.length >= 8))
            onClicked: {
                if (NetworkService.hotspotEnabled) NetworkService.stopHotspot();
                else root.start();
            }
        }
    }
    Rectangle {
        width: parent.width
        height: 32
        radius: 16
        visible: NetworkService.hotspotConfigured && !NetworkService.hotspotEnabled
        color: Theme.surfaceVariant
        StyledText { anchors.centerIn: parent; text: root.editing ? "Cancel editing" : "Change name/password"; color: Theme.surfaceText }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { root.editing = !root.editing; password.text = ""; } }
    }
    StyledText { width: parent.width; wrapMode: Text.WordWrap; text: NetworkService.hotspotError; visible: text.length > 0; color: Theme.error }
}
