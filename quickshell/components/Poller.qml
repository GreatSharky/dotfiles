import Quickshell.Io
import Quickshell
import QtQuick

Scope {
    id: poller
    required property real interval
    required property string command
    property string output

    Process {
        id: reader
        command: { poller.command.trim().split(" ") }
        stdout: StdioCollector {
            onStreamFinished: {
                poller.output = text
            }
        }
    }

    Timer {
        interval: poller.interval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!reader.running) reader.running = true
    }
}
