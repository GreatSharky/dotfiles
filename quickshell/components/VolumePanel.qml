// VolumePanel.qml
// Content of the volume popup: output name, mute toggle and volume slider.
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: volumepanel
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var streams: Pipewire.nodes.values.filter(s => s.isStream)
    PwObjectTracker { objects: volumepanel.streams }

    Text {
        text: sink?.description ?? "No output"
        color: Theme.fg
    }

    RowLayout {
        Button {
            text: sink?.audio.muted ? "" : ""
            font.family: Theme.font
            flat: sink.audio.muted
            onClicked: sink.audio.muted = !sink.audio.muted
        }
        Slider {
            from: 0
            to: 1
            value: sink?.audio.volume ?? 0
            onMoved: sink.audio.volume = value
        }
    }

    Repeater {
        model: ScriptModel { values: volumepanel.streams }
        WrapperRectangle {
            id: stream
            required property var modelData
            color: Theme.surface

            RowLayout {
                Text {
                    text: stream.modelData.properties["application.name"]
                    color: Theme.fg
                }
                Slider {
                    from: 0
                    to: 1
                    value: stream.modelData?.audio.volume ?? 0
                    onMoved: stream.modelData.audio.volume = value
                }
            }
        }
    }
}
