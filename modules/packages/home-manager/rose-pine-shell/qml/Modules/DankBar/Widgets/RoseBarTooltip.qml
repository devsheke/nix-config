import QtQuick
import Quickshell
import qs.Widgets

DankTooltip {
    id: root
    // A separate, input-transparent surface cannot steal the bar's hover.
    mask: Region {}
    function showFor(text, item, screen) {
        const pos = item.mapToItem(null, 0, 0);
        root.show(text, pos.x + item.width / 2, pos.y + item.height + 8, screen);
    }
}
