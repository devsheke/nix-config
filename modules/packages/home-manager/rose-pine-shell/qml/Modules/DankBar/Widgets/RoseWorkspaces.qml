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
    readonly property var monitor: Hyprland.monitors.values.find(m => m.name === screenName) ?? null
    readonly property int activeId: monitor?.activeWorkspace?.id ?? 1
    // Read the name, not the specialWorkspace object: { id: 0, name: "" }
    // means no special workspace. DMS's fallback stringifies that object.
    readonly property string activeSpecialWorkspace: monitor?.lastIpcObject?.specialWorkspace?.name ?? ""
    readonly property var workspaceIds: {
        const ids = new Set([1, 2, 3, 4]);
        // Windows and gaming launchers appear only while active.
        if ((activeId === 5 || activeId === 6) && !activeSpecialWorkspace)
            ids.add(activeId);
        for (const ws of Hyprland.workspaces.values) {
            if (ws.id > 6 && (ws.id === activeId || windows.some(w => w.workspace?.id === ws.id)))
                ids.add(ws.id);
        }
        return Array.from(ids).sort((a, b) => a - b);
    }
    readonly property var symbols: ["", "\uf120", "\udb80\ude39", "\uf144", "\uf075", "", "\uf1b6", "\uf074"]
    readonly property var specialWorkspaces: ({
        "special:games": { icon: "\uf11b", label: "Games (Super+G)" },
        "special:ai": { icon: "\uf2db", label: "AI (Super+`)" },
        "special:reading": { icon: "\uf02d", label: "Reading — Readest (Super+R)" }
    })

    width: isVertical ? barThickness : strip.count * barThickness
    height: isVertical ? strip.count * barThickness : barThickness
    RoseBarTooltip { id: tooltip }

    Repeater {
        id: strip
        model: root.specialWorkspaces[root.activeSpecialWorkspace] ? root.workspaceIds.concat([root.activeSpecialWorkspace]) : root.workspaceIds
        delegate: Rectangle {
            id: square
            required property var modelData
            required property int index
            readonly property var specialWorkspace: root.specialWorkspaces[modelData] ?? null
            readonly property bool selected: specialWorkspace ? root.activeSpecialWorkspace === modelData : root.activeId === modelData && !root.activeSpecialWorkspace
            readonly property string label: specialWorkspace ? specialWorkspace.label : (modelData === 6 ? "Gaming — Steam / Heroic (Super+6)" : "Workspace " + modelData)
            x: root.isVertical ? 0 : index * root.barThickness
            y: root.isVertical ? index * root.barThickness : 0
            width: root.barThickness
            height: root.barThickness
            radius: 0
            color: selected ? Theme.withAlpha(Theme.surfaceVariant, 0.95) : (area.containsMouse ? Theme.withAlpha(Theme.surfaceVariant, 0.6) : "transparent")

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                y: (parent.height - height) / 2
                text: square.specialWorkspace ? square.specialWorkspace.icon : (root.symbols[square.modelData] || String(square.modelData))
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
                onClicked: {
                    if (square.specialWorkspace)
                        HyprlandService.toggleSpecial(square.modelData.slice("special:".length));
                    else
                        HyprlandService.focusWorkspace(square.modelData);
                }
                onEntered: tooltip.showFor(square.label, square, root.parentScreen)
                onExited: tooltip.hide()
                onWheel: event => {
                    if (!SettingsData.workspaceScrolling) { event.accepted = false; return; }
                    const step = (event.angleDelta.y > 0 ? -1 : 1) * (SettingsData.reverseScrolling ? -1 : 1);
                    const candidates = step < 0 ? root.workspaceIds.slice().reverse() : root.workspaceIds;
                    const next = candidates.find(id => step < 0 ? id < root.activeId : id > root.activeId);
                    if (next !== undefined)
                        HyprlandService.focusWorkspace(next);
                    event.accepted = true;
                }
            }
        }
    }
}
