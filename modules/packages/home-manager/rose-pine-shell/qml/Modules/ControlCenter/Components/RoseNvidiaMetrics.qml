import QtQuick
import Quickshell.Io

Item {
    id: root
    property bool live: false
    property var command: ["@nvidiaMetricsPython@", "@nvidiaMetricsScript@"]
    property var gpus: []
    property string status: "Loading…"
    visible: false
    function refresh() {
        if (!live || sample.running) return;
        sample.running = true;
        watchdog.restart();
    }
    onLiveChanged: {
        if (live) {
            gpus = [];
            status = "Loading…";
            refresh();
        } else {
            watchdog.stop();
            sample.running = false;
        }
    }
    Component.onCompleted: refresh()
    Timer { interval: 5000; repeat: true; running: root.live; onTriggered: root.refresh() }
    Timer {
        id: watchdog
        interval: 4500
        onTriggered: {
            root.gpus = [];
            root.status = "NVIDIA monitoring timed out";
            sample.timedOut = true;
            sample.running = false;
        }
    }
    Process {
        id: sample
        property bool timedOut: false
        command: root.command
        stdout: StdioCollector { id: output }
        onStarted: timedOut = false
        onExited: (exitCode, exitStatus) => {
            watchdog.stop();
            if (!root.live || timedOut) return;
            try {
                const result = JSON.parse(output.text);
                root.gpus = exitCode === 0 && result.available ? result.gpus : [];
                root.status = root.gpus.length ? "" : result.message || "NVIDIA monitoring unavailable";
            } catch (error) {
                root.gpus = [];
                root.status = "NVIDIA monitoring unavailable";
            }
        }
    }
}
