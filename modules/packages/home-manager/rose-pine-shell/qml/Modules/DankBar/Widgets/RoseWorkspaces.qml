import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root
    property var axis: null
    property string screenName: ""
    property real widgetHeight: 30
    property real barThickness: 36
    property var barConfig: null
    property var blurBarWindow: null
    property var parentScreen: null
    property var hyprlandOverviewLoader: null
    property bool isFirst: false
    property bool isLast: false
    property bool isLeftBarEdge: false
    property bool isRightBarEdge: false
    property bool isTopBarEdge: false
    property bool isBottomBarEdge: false
    property real sectionSpacing: 0
    property real crossEdgeExtension: 0
    readonly property bool isVertical: axis?.isVertical ?? false
    readonly property var windows: Array.from(Hyprland.toplevels.values)
    readonly property int activeId: Hyprland.monitors.values.find(m => m.name === screenName)?.activeWorkspace?.id ?? 1
    readonly property var workspaceIds: {
        const ids = new Set([1, 2, 3, 4, 5]);
        for (const ws of Hyprland.workspaces.values) {
            if (ws.id > 5 && (ws.id === activeId || windows.some(w => w.workspace?.id === ws.id)))
                ids.add(ws.id);
        }
        return Array.from(ids).sort((a, b) => a - b);
    }
    readonly property var symbols: ["", "\uf120", "\udb80\ude39", "\uf144", "\uf075", "\uf17a", "\uf002", "\uf074"]

    width: isVertical ? barThickness : strip.count * barThickness
    height: isVertical ? strip.count * barThickness : barThickness
    RoseBarTooltip { id: tooltip }

    Repeater {
        id: strip
        model: root.workspaceIds
        delegate: Rectangle {
            id: square
            required property int modelData
            required property int index
            readonly property bool selected: root.activeId === modelData
            x: root.isVertical ? 0 : index * root.barThickness
            y: root.isVertical ? index * root.barThickness : 0
            width: root.barThickness
            height: root.barThickness
            radius: 0
            color: selected ? Theme.withAlpha(Theme.surfaceVariant, 0.95) : (area.containsMouse ? Theme.withAlpha(Theme.surfaceVariant, 0.6) : "transparent")

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                y: (parent.height - height) / 2
                text: root.symbols[square.modelData] || String(square.modelData)
                font.family: Theme.monoFontFamily
                font.pixelSize: 13
                color: square.selected ? Theme.surfaceText : Theme.surfaceVariantText
            }
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: Theme.primary
                visible: square.selected
            }
            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: HyprlandService.focusWorkspace(square.modelData)
                onEntered: tooltip.showFor("Workspace " + square.modelData, square, root.parentScreen)
                onExited: tooltip.hide()
                onWheel: event => {
                    if (!SettingsData.workspaceScrolling) { event.accepted = false; return; }
                    const i = root.workspaceIds.indexOf(root.activeId);
                    const step = (event.angleDelta.y > 0 ? -1 : 1) * (SettingsData.reverseScrolling ? -1 : 1);
                    const next = Math.max(0, Math.min(root.workspaceIds.length - 1, i + step));
                    HyprlandService.focusWorkspace(root.workspaceIds[next]);
                    event.accepted = true;
                }
            }
        }
    }
}
