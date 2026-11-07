import Quickshell
import QtQuick
import Quickshell.Hyprland

PopupWindow {
    id: root
    // Set this to show or hide the popup. `visible` follows it and stays true
    // until the closing animation has finished.
    property bool open: false
    property bool closeOnUnfocus: true
    property int padding: 6
    default property alias contents: column.data

    visible: open || content.opacity > 0
    color: "transparent"
    implicitWidth: column.implicitWidth + 2 * padding
    implicitHeight: column.implicitHeight + 2 * padding

    // Only one popup open at a time: the last one opened wins.
    onOpenChanged: if (open) PopupManager.current = root
    Connections {
        target: PopupManager
        function onCurrentChanged() {
            if (PopupManager.current !== root)
                root.open = false
        }
    }

    HyprlandFocusGrab {
        // The bar is whitelisted too, so a click on another indicator reaches it
        // instead of only ending the grab.
        windows: [root, root.parentWindow]
        active: root.closeOnUnfocus && root.backingWindowVisible
        onCleared: root.open = false
    }

    Rectangle {
        id: content
        width: root.implicitWidth
        height: root.implicitHeight
        radius: 10
        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.6  // grows out of its top edge, which is next to the bar
        transformOrigin: Item.Top
        Behavior on opacity { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
        color: "white"

        Column {
            id: column
            anchors { fill: parent; margins: root.padding}
        }
    }
}
