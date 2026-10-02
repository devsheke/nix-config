pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool active: false
    property string qalcCommand: "qalc --defaults -t"
    property string lastResult: ""
    property bool failed: false
    property string pendingExpression: ""
    property int revision: 0
    property bool ready: false
    signal resultReady(string result)

    function splitCommand(command) {
        const args = [];
        let token = "", quoted = false;
        for (const c of command) {
            if (c === '"') quoted = !quoted;
            else if (c === " " && !quoted) { if (token) { args.push(token); token = ""; } }
            else token += c;
        }
        if (token) args.push(token);
        return args.filter(arg => arg !== "-i");
    }
    function calculate(expression) {
        revision++;
        pendingExpression = expression;
        lastResult = "";
        ready = false;
        debounce.restart();
    }
    function launch() {
        if (!active || !ready || process.running || !pendingExpression) return;
        ready = false;
        process.requestRevision = revision;
        process.command = splitCommand(qalcCommand).concat(["--", pendingExpression]);
        process.running = true;
        timeout.restart();
    }
    onActiveChanged: if (!active) { ready = false; debounce.stop(); process.running = false; }
    Timer { id: debounce; interval: 150; onTriggered: { root.ready = true; root.launch(); } }
    Timer {
        id: timeout
        interval: 8000
        onTriggered: {
            if (process.requestRevision === root.revision) {
                root.lastResult = "Error: Calculation timed out";
                root.resultReady(root.lastResult);
            }
            process.timedOut = true;
            process.running = false;
        }
    }
    Process {
        id: process
        property int requestRevision: -1
        property bool timedOut: false
        stdout: StdioCollector { id: output }
        stderr: StdioCollector { id: errors }
        onStarted: timedOut = false
        onExited: (exitCode, exitStatus) => {
            timeout.stop();
            if (root.active && requestRevision === root.revision && !timedOut) {
                const lines = output.text.replace(/\x1b\[[0-9;]*m/g, "").trim().split("\n").filter(Boolean);
                const result = lines[lines.length - 1] || "";
                root.lastResult = exitCode === 0 && result ? result : "Error: " + (errors.text.trim().split("\n")[0] || "Invalid expression");
                root.resultReady(root.lastResult);
            }
            Qt.callLater(root.launch);
        }
    }
}
