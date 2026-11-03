pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Column {
    id: container
    readonly property var workspaces: Hyprland.workspaces.values.filter(w => w.id >= 0)
    readonly property int focusedIndex: workspaces.findIndex(w => w.focused)
    Repeater {
        model: ScriptModel {
            values: Hyprland.workspaces.values.filter(entry => entry.id >= 0)
        }

        WrapperRectangle {
            id: wrapper
            required property var modelData
            required property int index
            topMargin: 2
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                implicitWidth: Math.max(0, 24 - 8 * Math.abs(wrapper.index - container.focusedIndex))
                implicitHeight: 3
                radius: 12
                color: wrapper.modelData.focused ? "white" : "darkgray"
           }
        }
    }
}
