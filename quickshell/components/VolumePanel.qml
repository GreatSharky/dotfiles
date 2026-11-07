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
    // Fixed width: the popup window is sized from this, so nothing inside (a glyph, a
    // stream appearing) can resize or move the window.
    implicitWidth: 260
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var streams: Pipewire.nodes.values.filter(s => s.isStream)
    PwObjectTracker { objects: volumepanel.streams }

    Text {
        text: sink?.description ?? "No output"
        color: Theme.fg
    }

    RowLayout {
        Layout.fillWidth: true
        QuickSwitch {
            checkable: false                        // the mute state decides, not the click
            checked: !(sink?.audio.muted ?? false)  // on = sound on, off (dark) = muted
            text: !sink?.audio.muted ? "" : ""
            font.pixelSize: 16
            implicitHeight: 20
            onClicked: sink.audio.muted = !sink.audio.muted
        }
        Slider {
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            required property var modelData
            color: Theme.surface

            RowLayout {
                Text {
                    text: stream.modelData.properties["application.name"]
                    color: Theme.fg
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: stream.modelData?.audio.volume ?? 0
                    onMoved: stream.modelData.audio.volume = value
                }
            }
        }
    }
}
