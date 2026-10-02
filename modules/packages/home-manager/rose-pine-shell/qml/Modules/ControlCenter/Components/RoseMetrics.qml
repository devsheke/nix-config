import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

Column {
    id: root
    property bool live: false
    property bool held: false
    property var gpuIds: []
    spacing: 14
    RoseNvidiaMetrics { id: nvidia; live: root.live }
    function percent(value) { return value === null ? "Unavailable" : Math.round(value) + "%"; }
    function memory(gpu) {
        return gpu.memoryUsed === null || gpu.memoryTotal === null ? "Unavailable" : (gpu.memoryUsed / 1024).toFixed(1) + " / " + (gpu.memoryTotal / 1024).toFixed(1) + " GiB";
    }
    function sync() {
        if (live === held) return;
        held = live;
        if (held) {
            DgopService.addRef(["cpu", "memory", "disk", "diskmounts", "gpu"]);
            syncGpus();
        } else {
            DgopService.removeRef(["cpu", "memory", "disk", "diskmounts", "gpu"]);
            for (const id of gpuIds) DgopService.removeGpuPciId(id);
            gpuIds = [];
        }
    }
    function syncGpus() {
        if (!held) return;
        const next = DgopService.availableGpus.filter(g => !/nvidia|geforce|quadro|\brtx\b|10de:/i.test(g.displayName || "")).map(g => g.pciId).filter(Boolean);
        for (const id of next) if (!gpuIds.includes(id)) DgopService.addGpuPciId(id);
        for (const id of gpuIds) if (!next.includes(id)) DgopService.removeGpuPciId(id);
        gpuIds = next;
    }
    onLiveChanged: sync()
    Component.onCompleted: sync()
    Component.onDestruction: { live = false; sync(); }
    Connections { target: DgopService; function onAvailableGpusChanged() { root.syncGpus(); } }
    component MetricLine: RowLayout {
        property string iconName: ""
        property string label: ""
        property string value: ""
        width: parent.width
        spacing: 10
        DankIcon { name: parent.iconName; size: 18; color: Theme.primary; Layout.alignment: Qt.AlignTop }
        Column {
            Layout.fillWidth: true
            spacing: 3
            StyledText { width: parent.width; text: parent.parent.label; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; wrapMode: Text.WordWrap }
            StyledText { width: parent.width; text: parent.parent.value; font.pixelSize: Theme.fontSizeMedium; color: Theme.surfaceText; wrapMode: Text.WordWrap }
        }
    }
    Row {
        spacing: 10
        DankIcon { name: "speed"; size: 20; color: Theme.primary }
        StyledText { text: "Stats"; font.pixelSize: Theme.fontSizeLarge; color: Theme.surfaceText }
    }
    StyledText { visible: !DgopService.dgopAvailable; text: "Monitoring unavailable"; color: Theme.surfaceVariantText }
    MetricLine { iconName: "developer_board"; label: "CPU"; value: Math.round(DgopService.cpuUsage) + "%" }
    MetricLine { iconName: "memory"; label: "RAM"; value: (DgopService.usedMemoryMB / 1024).toFixed(1) + " / " + (DgopService.totalMemoryMB / 1024).toFixed(1) + " GiB" }
    MetricLine { iconName: "thermostat"; label: "CPU temperature"; value: DgopService.cpuTemperature > 0 ? Math.round(DgopService.cpuTemperature) + " °C" : "Unavailable" }
    Repeater {
        model: DgopService.availableGpus.filter(g => g.temperature > 0 && !/nvidia|geforce|quadro|\brtx\b|10de:/i.test(g.displayName || ""))
        delegate: MetricLine {
            required property var modelData
            iconName: "developer_board"
            label: /8086:/i.test(modelData.displayName || "") ? "Intel GPU temperature" : modelData.displayName
            value: modelData.temperature > 0 ? Math.round(modelData.temperature) + " °C" : "Temperature unavailable"
        }
    }
    MetricLine { visible: nvidia.gpus.length === 0; iconName: "developer_board"; label: "NVIDIA GPU"; value: nvidia.status }
    Repeater {
        model: nvidia.gpus
        delegate: Column {
            required property var modelData
            width: parent.width
            spacing: 10
            MetricLine { iconName: "developer_board"; label: modelData.name; value: "GPU usage · " + root.percent(modelData.usage) }
            MetricLine { iconName: "memory"; label: "VRAM"; value: root.memory(modelData) }
            MetricLine { iconName: "thermostat"; label: "GPU temperature"; value: modelData.temperature === null ? "Unavailable" : Math.round(modelData.temperature) + " °C" }
            MetricLine { iconName: "bolt"; label: "GPU power"; value: modelData.power === null ? "Unavailable" : modelData.power.toFixed(1) + " W" }
        }
    }
    Repeater {
        model: DgopService.diskMounts
        delegate: MetricLine {
            required property var modelData
            iconName: "storage"
            label: modelData.mount
            value: modelData.percent + " used · " + modelData.avail + " free / " + modelData.size
        }
    }
    MetricLine {
        iconName: "swap_vert"
        label: "Disk activity"
        value: "Read " + (DgopService.diskReadRate / 1048576).toFixed(1) + " MiB/s · Write " + (DgopService.diskWriteRate / 1048576).toFixed(1) + " MiB/s"
    }
}
