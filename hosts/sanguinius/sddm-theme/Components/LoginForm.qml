// Derived from Keyitdev's Astronaut theme, GPL-3.0-or-later.
import QtQuick
import QtQuick.Layouts
import SddmComponents 2.0 as SDDM

Item {
    id: formContainer
    SDDM.TextConstants { id: textConstants }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Number(config.FormPadding || "24")
        spacing: Number(config.FormSpacing || "12")

        Item { Layout.fillHeight: true }

        Clock {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: implicitHeight
        }

        Input {
            id: input
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }

        SystemButtons {
            id: systemButtons
            visible: config.HideSystemButtons != "true"
            Layout.alignment: Qt.AlignHCenter
            exposedSession: input.exposeSession
        }

        SessionButton {
            id: sessionSelect
            Layout.fillWidth: true
            Layout.preferredHeight: root.font.pointSize * 3
        }

        VirtualKeyboardButton {
            visible: config.HideVirtualKeyboard == "false"
            Layout.fillWidth: true
            Layout.preferredHeight: root.font.pointSize * 3
        }

        Item { Layout.fillHeight: true }
    }
}
