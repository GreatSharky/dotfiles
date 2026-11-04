pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Column {
    id: container
    readonly property var workspaces: Hyprland.workspaces.values.filter(w => w.id >= 0)
    readonly property int focusedIndex: workspaces.findIndex(w => w.focused)
    spacing: 2
    topPadding: 2
    bottomPadding: 2
    Repeater {
        model: ScriptModel {
            values: Hyprland.workspaces.values.filter(entry => entry.id >= 0)
        }

        WrapperRectangle {
            id: wrapper
            required property var modelData
            required property int index
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                implicitWidth: Functions.gaussianWidth(
                    Math.abs(container.focusedIndex - wrapper.index), 8, 24, 5, 4.5)
                implicitHeight: 3
                radius: 12
                color: wrapper.modelData.focused ? "white" : "darkgray"
                visible: implicitWidth > 0

                Behavior on implicitWidth {
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: 120 }
                }
            }
        }
    }
}
