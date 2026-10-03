// Local Rosé Pine layout. Login controls are derived from Keyitdev's Astronaut.
// Distributed under GPL-3.0-or-later; see LICENSE and README.md.
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import "Components"

Pane {
    id: root
    width: Number(config.ScreenWidth || "1920")
    height: Number(config.ScreenHeight || "1080")
    padding: 0
    font.family: config.Font
    font.pointSize: Number(config.FontSize || "10")
    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor
    focus: true

    LayoutMirroring.enabled: config.RightToLeftLayout == "true" || Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: config.Background
        fillMode: config.CropBackground == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
        asynchronous: true
        mipmap: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.forceActiveFocus()
    }

    Rectangle {
        anchors.fill: parent
        color: config.DimBackgroundColor
        opacity: Number(config.DimBackground || "0")
    }

    ShaderEffectSource {
        id: blurSource
        sourceItem: backgroundImage
        sourceRect: Qt.rect(form.x, form.y, form.width, form.height)
        textureSize: Qt.size(form.width, form.height)
        visible: false
    }

    Rectangle {
        id: panelMask
        width: form.width
        height: form.height
        radius: Number(config.RoundCorners || "16")
        color: "white"
        layer.enabled: true
        visible: false
    }

    MultiEffect {
        anchors.fill: form
        source: blurSource
        blurEnabled: true
        blur: Number(config.Blur || "0.8")
        blurMax: Number(config.BlurMax || "32")
        maskEnabled: true
        maskSource: panelMask
        autoPaddingEnabled: false
        visible: config.PartialBlur == "true"
    }

    Rectangle {
        anchors.fill: form
        radius: Number(config.RoundCorners || "16")
        color: config.FormBackgroundColor
        opacity: Number(config.FormOpacity || "0.9")
    }

    LoginForm {
        id: form
        property real margin: Math.min(Number(config.FormMargin || "48"), root.width / 10)
        width: Math.min(Number(config.FormWidth || "440"), root.width - margin * 2)
        height: Math.min(Number(config.FormHeight || "600"), root.height - margin * 2)
        x: config.FormPosition == "right" ? root.width - width - margin
            : config.FormPosition == "center" ? (root.width - width) / 2 : margin
        anchors.verticalCenter: parent.verticalCenter
    }

    Loader {
        id: virtualKeyboard
        source: "Components/VirtualKeyboard.qml"
        width: root.width * Number(config.KeyboardSize || "0.4")
        anchors.bottom: parent.bottom
        x: config.VirtualKeyboardPosition == "right" ? root.width - width
            : config.VirtualKeyboardPosition == "center" ? (root.width - width) / 2 : 0
        visible: state == "visible"
        state: "hidden"
        property bool keyboardActive: item ? item.active : false

        function switchState() {
            if (!item)
                return;
            if (state == "hidden") {
                state = "visible";
                item.activated = true;
                Qt.inputMethod.show();
            } else {
                item.activated = false;
                Qt.inputMethod.hide();
                state = "hidden";
            }
        }
    }
}
