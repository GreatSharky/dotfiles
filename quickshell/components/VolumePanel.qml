// VolumePanel.qml
// Content of the volume popup: output name, mute toggle and volume slider.
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: volumepanel
    // Fixed width, set on a plain Item: a layout recomputes its own implicitWidth from its
    // children, so only an Item can really pin the popup window size.
    implicitWidth: 240
    implicitHeight: layout.implicitHeight
    // Every row is split in two equal halves: switch or label on the left, slider on the right.
    readonly property real sliderWidth: implicitWidth * .67
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var streams: Pipewire.nodes.values.filter(s => s.isStream)
    PwObjectTracker { objects: volumepanel.streams }

    ColumnLayout {
        id: layout
        anchors.fill: parent

        Text {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: sink?.description ?? "No output"
            color: Theme.fg
            font.family: Theme.font
            font.pixelSize: 14
            font.bold: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            Item {
                Layout.preferredWidth: volumepanel.width - volumepanel.sliderWidth
                implicitHeight: muteSwitch.implicitHeight
                QuickSwitch {
                    id: muteSwitch
                    anchors.verticalCenter: parent.verticalCenter
                    checkable: false                        // the mute state decides, not the click
                    checked: !(sink?.audio.muted ?? false)  // on = sound on, off (dark) = muted
                    text: !sink?.audio.muted ? "" : ""
                    font.pixelSize: 16
                    implicitHeight: 20
                    onClicked: sink.audio.muted = !sink.audio.muted
                }
            }
            Slider {
                Layout.preferredWidth: volumepanel.sliderWidth
                from: 0
                to: 1
                value: sink?.audio.volume ?? 0
                onMoved: sink.audio.volume = value
            }
        }
        MenuSeparator {
            topPadding: 6
            bottomPadding: 6
            Layout.fillWidth: true
            contentItem: Rectangle {
                implicitWidth: volumepanel.implicitWidth
                implicitHeight: 1
                color: Theme.muted
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
                    spacing: 0
                    Text {
                        Layout.preferredWidth: volumepanel.width - volumepanel.sliderWidth
                        elide: Text.ElideRight
                        text: stream.modelData.properties["media.name"]
                        color: Theme.fg
                    }
                    Slider {
                        Layout.preferredWidth: volumepanel.sliderWidth
                        from: 0
                        to: 1
                        value: stream.modelData?.audio.volume ?? 0
                        onMoved: stream.modelData.audio.volume = value
                    }
                }
            }
        }
    }
}
