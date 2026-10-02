import QtQuick
import qs.Common
import qs.Modules.ControlCenter.Details
import qs.Modules.ControlCenter.Widgets
import qs.Widgets

Item {
    id: root
    property string kind: "wifi"
    property var host: null
    implicitHeight: kind === "wifi" || kind === "bluetooth" ? 360 : kind === "audio" || kind === "audioInput" ? 340 : details.item?.implicitHeight ?? 300
    Loader {
        id: details
        width: parent.width
        height: root.implicitHeight
        sourceComponent: root.kind === "wifi" ? network : root.kind === "bluetooth" ? bluetooth : root.kind === "audio" ? audio : root.kind === "audioInput" ? inputAudio : root.kind === "hotspot" ? hotspot : root.kind === "vpn" ? vpn : root.kind === "battery" ? battery : brightness
    }
    Component {
        id: network
        NetworkDetail {
            selectedType: "wifi"
            color: "transparent"
            border.width: 0
        }
    }
    Component {
        id: bluetooth
        BluetoothDetail {
            color: "transparent"
            border.width: 0
            bluetoothCodecModalRef: codecSelector
            onShowCodecSelector: device => codecSelector.show(device)
        }
    }
    Component {
        id: audio
        AudioOutputDetail {
            color: "transparent"
            border.width: 0
            hasVolumeSliderInCC: false
            onShowPortSelector: node => portSelector.show(node)
        }
    }
    Component {
        id: inputAudio
        AudioInputDetail {
            color: "transparent"
            border.width: 0
        }
    }
    Component { id: hotspot; RoseHotspot {} }
    Component { id: vpn; VpnDetailContent { parentPopout: root.host } }
    Component { id: battery; BatteryDetail {} }
    Component { id: brightness; BrightnessDetail {} }
    BluetoothCodecSelector { id: codecSelector; anchors.fill: parent; z: 10; visible: false }
    AudioPortSelector { id: portSelector; anchors.fill: parent; z: 10; visible: false }
}
