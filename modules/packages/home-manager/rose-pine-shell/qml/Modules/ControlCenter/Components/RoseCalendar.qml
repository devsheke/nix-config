import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Widgets

Column {
    id: root
    SystemClock { id: systemClock; precision: SystemClock.Minutes }
    property date month: new Date(systemClock.date.getFullYear(), systemClock.date.getMonth(), 1)
    spacing: 12
    function shift(delta) { month = new Date(month.getFullYear(), month.getMonth() + delta, 1); }
    function today() { month = new Date(systemClock.date.getFullYear(), systemClock.date.getMonth(), 1); }
    StyledText {
        text: Qt.formatDateTime(systemClock.date, "dddd, dd MMMM yyyy")
        font.pixelSize: Theme.fontSizeMedium
        color: Theme.surfaceText
    }
    StyledText {
        text: Qt.formatDateTime(systemClock.date, "HH:mm")
        font.pixelSize: 28
        color: Theme.primary
    }
    RowLayout {
        width: parent.width
        DankActionButton { iconName: "chevron_left"; buttonSize: 32; onClicked: root.shift(-1) }
        StyledText {
            text: Qt.formatDate(root.month, "MMMM yyyy")
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: Theme.surfaceText
            font.pixelSize: Theme.fontSizeMedium
        }
        DankActionButton { iconName: "chevron_right"; buttonSize: 32; onClicked: root.shift(1) }
    }
    GridLayout {
        columns: 7
        width: parent.width
        columnSpacing: 2
        rowSpacing: 2
        Repeater {
            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
            delegate: StyledText {
                required property string modelData
                text: modelData
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: Theme.surfaceVariantText
                font.pixelSize: Theme.fontSizeSmall
                height: 28
            }
        }
        Repeater {
            model: 42
            delegate: Rectangle {
                required property int index
                readonly property date day: new Date(root.month.getFullYear(), root.month.getMonth(), 1 + index - (root.month.getDay() + 6) % 7)
                readonly property bool current: day.toDateString() === systemClock.date.toDateString()
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 16
                color: current ? Theme.primary : "transparent"
                StyledText {
                    anchors.centerIn: parent
                    text: parent.day.getDate()
                    color: parent.current ? Theme.primaryText : parent.day.getMonth() === root.month.getMonth() ? Theme.surfaceText : Theme.surfaceVariantText
                    opacity: parent.day.getMonth() === root.month.getMonth() ? 1 : 0.5
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
        }
    }
    Rectangle {
        width: parent.width
        height: 32
        radius: 16
        color: todayArea.containsMouse ? Theme.primaryHover : Theme.surfaceVariant
        StyledText { anchors.centerIn: parent; text: "Today"; color: Theme.surfaceText }
        MouseArea { id: todayArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.today() }
    }
}
