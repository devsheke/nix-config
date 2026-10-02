import QtQuick
import qs.Common
import qs.Modules.ControlCenter.Components
import qs.Services
import qs.Widgets

DankPopout {
    id: root
    property string kind: "wifi"
    property string loadedKind: ""
    property var triggerScreen: null
    screen: triggerScreen
    layerNamespace: "dms:rose-panel"
    popupWidth: kind === "calendar" ? 360 : kind === "metrics" ? 460 : 420
    popupHeight: Math.min((triggerScreen?.height ?? 1080) - 100, (contentLoader.item?.implicitHeight ?? 380))
    backgroundInteractive: !NetworkService.credentialsRequested && !PopoutService.wifiPasswordModal?.shouldBeVisible && !PopoutService.bluetoothPairingModal?.shouldBeVisible
    onBackgroundClicked: close()
    Component.onCompleted: loadedKind = kind
    onKindChanged: {
        if (loadedKind === "bluetooth" && BluetoothService.adapter?.discovering) BluetoothService.adapter.discovering = false;
        loadedKind = kind;
        if (shouldBeVisible && kind === "wifi" && NetworkService.wifiEnabled) NetworkService.scanWifi();
    }
    onShouldBeVisibleChanged: {
        if (shouldBeVisible && kind === "wifi" && NetworkService.wifiEnabled) NetworkService.scanWifi();
        if (!shouldBeVisible && kind === "bluetooth" && BluetoothService.adapter?.discovering) BluetoothService.adapter.discovering = false;
    }
    content: Component {
        Item {
            implicitHeight: panelLoader.item ? panelLoader.item.implicitHeight + 32 : 380
            DankFlickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: panelLoader.item ? panelLoader.item.implicitHeight + 32 : 380
                clip: true
                interactive: contentHeight > height
                Loader {
                    id: panelLoader
                    x: 16
                    y: 16
                    width: parent.width - 32
                    sourceComponent: root.kind === "calendar" ? calendar : root.kind === "metrics" ? metrics : root.kind === "media" ? media : details
                }
            }
            Component { id: calendar; RoseCalendar {} }
            Component { id: metrics; RoseMetrics { live: root.shouldBeVisible } }
            Component { id: media; RoseMediaCard { live: root.shouldBeVisible } }
            Component { id: details; RoseDetails { kind: root.kind; host: root } }
        }
    }
}
