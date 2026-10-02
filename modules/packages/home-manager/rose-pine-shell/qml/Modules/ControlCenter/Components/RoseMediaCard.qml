import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root
    property bool live: false
    readonly property var player: MprisController.activePlayer
    implicitHeight: player ? 158 + (MprisController.availablePlayers.length > 1 ? 32 : 0) : 72
    radius: 16
    color: Theme.nestedSurface
    Timer { interval: 1000; repeat: true; running: root.live && root.player?.isPlaying; onTriggered: root.player?.positionChanged() }
    Column {
        x: 12
        y: 12
        width: parent.width - 24
        spacing: 8
        RowLayout {
            width: parent.width
            spacing: 10
            MediaArtwork { width: 48; height: 48; artUrl: root.player?.trackArtUrl ?? "" }
            Column {
                Layout.fillWidth: true
                spacing: 3
                StyledText { width: parent.width; text: MprisController.stableTitle || "Nothing playing"; elide: Text.ElideRight; wrapMode: Text.NoWrap; maximumLineCount: 1; color: Theme.surfaceText; font.pixelSize: Theme.fontSizeMedium }
                StyledText { width: parent.width; text: MprisController.stableArtist || root.player?.identity || "Media controls"; elide: Text.ElideRight; wrapMode: Text.NoWrap; maximumLineCount: 1; color: Theme.surfaceVariantText; font.pixelSize: Theme.fontSizeSmall }
            }
        }
        Row {
            visible: root.player !== null
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            DankActionButton { iconName: "skip_previous"; buttonSize: 32; enabled: root.player?.canGoPrevious ?? false; onClicked: root.player.previous() }
            DankActionButton { iconName: root.player?.isPlaying ? "pause" : "play_arrow"; buttonSize: 32; enabled: root.player?.canTogglePlaying ?? false; onClicked: root.player.togglePlaying() }
            DankActionButton { iconName: "skip_next"; buttonSize: 32; enabled: root.player?.canGoNext ?? false; onClicked: root.player.next() }
        }
        DankSlider {
            width: parent.width
            height: 24
            visible: root.player !== null
            enabled: (root.player?.canSeek ?? false) && MprisController.activePlayerStableLength > 0
            minimum: 0
            maximum: 1000
            showValue: false
            valueOverride: MprisController.activePlayerStableLength > 0 ? Math.min(1000, (root.player?.position ?? 0) / MprisController.activePlayerStableLength * 1000) : 0
            onSliderValueChanged: newValue => { if (root.player?.canSeek) root.player.position = Math.max(0.1, newValue / 1000 * MprisController.activePlayerStableLength * 0.999); }
        }
        Row {
            visible: MprisController.availablePlayers.length > 1
            spacing: 4
            Repeater {
                model: MprisController.availablePlayers
                delegate: Rectangle {
                    required property var modelData
                    width: Math.min(100, (root.width - 24) / MprisController.availablePlayers.length - 4)
                    height: 28
                    radius: 14
                    color: root.player === modelData ? Theme.primary : Theme.surfaceVariant
                    StyledText { anchors.centerIn: parent; width: parent.width - 12; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight; text: parent.modelData.identity; font.pixelSize: Theme.fontSizeSmall; color: root.player === parent.modelData ? Theme.primaryText : Theme.surfaceText }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: MprisController.setActivePlayer(parent.modelData) }
                }
            }
        }
    }
}
