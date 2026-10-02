import QtQuick
import qs.Common
import qs.Widgets

Item {
    id: root
    property var axis: null
    property string section: "left"
    property var parentScreen: null
    property var barConfig: null
    property real barThickness: 36
    property real widgetThickness: 26
    property bool isActive: false
    readonly property alias visualContent: face
    readonly property real visualWidth: width
    readonly property real visualHeight: height
    signal clicked
    width: barThickness
    height: barThickness
    RoseBarTooltip { id: tooltip }
    Rectangle {
        id: face
        anchors.fill: parent
        radius: 0
        color: root.isActive ? Theme.withAlpha(Theme.surfaceVariant, 0.95) : area.containsMouse ? Theme.withAlpha(Theme.surfaceVariant, 0.6) : "transparent"
        StyledText {
            anchors.centerIn: parent
            text: "\uf313"
            font.family: Theme.monoFontFamily
            font.pixelSize: 14
            color: Theme.widgetIconColor
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: tooltip.showFor("Power menu", root, root.parentScreen)
        onExited: tooltip.hide()
        onClicked: { tooltip.hide(); root.clicked(); }
    }
}
