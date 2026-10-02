import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Services
import qs.Widgets

BasePill {
    id: root
    property bool compactMode: false
    property real maxLabelWidth: 220
    readonly property var player: MprisController.activePlayer
    visible: player !== null
    readonly property string label: MprisController.stableTitle + (MprisController.stableArtist ? " — " + MprisController.stableArtist : "")
    readonly property bool isHovered: mediaMouse.containsMouse
    readonly property bool overIcon: mediaMouse.mouseX < horizontalPadding + 17
    RoseBarTooltip { id: tooltip }
    function updateTooltip() {
        if (isHovered) tooltip.showFor(overIcon ? "Open media player" : label || player?.identity || "Media", root, parentScreen);
        else tooltip.hide();
    }
    onIsHoveredChanged: updateTooltip()
    onOverIconChanged: if (isHovered) updateTooltip()
    function transport(button) {
        if (button === Qt.LeftButton && player?.canTogglePlaying) player.togglePlaying();
        else if (button === Qt.RightButton && player?.canGoNext) player.next();
        else if (button === Qt.MiddleButton && player?.canGoPrevious) player.previous();
    }
    MouseArea {
        id: mediaMouse
        anchors.fill: parent
        z: 2
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: mouse => {
            tooltip.hide();
            if (mouse.button === Qt.LeftButton && (root.overIcon || root.compactMode)) root.clicked();
            else root.transport(mouse.button);
        }
        onWheel: event => event.accepted = false
    }
    content: Component {
        Row {
            spacing: 6
            DankIcon { anchors.verticalCenter: parent.verticalCenter; name: "music_note"; size: 14; color: Theme.widgetIconColor }
            StyledText {
                visible: !root.compactMode
                width: Math.min(root.maxLabelWidth, implicitWidth)
                text: root.label || root.player?.identity || "Media"
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                maximumLineCount: 1
                font.pixelSize: 13
                color: Theme.widgetTextColor
            }
        }
    }
}
