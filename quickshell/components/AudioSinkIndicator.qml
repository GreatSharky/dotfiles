import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

WrapperMouseArea {
    id: root

    required property PwNode audiosink
    readonly property PwNode defaultsink: Pipewire.defaultAudioSink
    PwObjectTracker {
        objects: root.audiosink
    }
    readonly property var textcolor: audiosink == defaultsink ? Theme.fg : Theme.fgDark

    onClicked: Pipewire.preferredDefaultAudioSink = audiosink
    cursorShape: Qt.PointingHandCursor

    RowLayout {
        spacing: 2

        Text {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: root.audiosink?.description ?? ""
            color: root.textcolor
            font.family: Theme.font
        }
    }
}
