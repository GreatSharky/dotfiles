import Quickshell
import QtQuick
import Quickshell.Hyprland

PopupWindow {
    id: root
    // Set this to show or hide the popup. `visible` follows it and stays true
    // until the closing animation has finished.
    property bool open: false
    property bool closeOnUnfocus: true

    visible: open || content.opacity > 0
    color: "transparent"
    implicitWidth: 200
    implicitHeight: 200

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
        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.6  // grows out of its top edge, which is next to the bar
        transformOrigin: Item.Top

        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }
}
