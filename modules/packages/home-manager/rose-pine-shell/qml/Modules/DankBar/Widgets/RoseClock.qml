import QtQuick
import Quickshell
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

BasePill {
    id: root
    signal clockClicked
    SystemClock { id: systemClock; precision: SystemClock.Minutes }
    onClicked: clockClicked()
    content: Component {
        Row {
            spacing: 8
            DankIcon {
                anchors.verticalCenter: parent.verticalCenter
                name: "schedule"
                size: 13
                color: Theme.widgetTextColor
            }
            StyledText {
                text: Qt.formatDateTime(systemClock.date, "ddd MMM dd HH:mm yyyy")
                font.pixelSize: 13
                color: Theme.widgetTextColor
            }
        }
    }
}
