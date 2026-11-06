// AppIcon.qml
// A clickable icon that grows and shrinks smoothly.
//   source   icon path or file URL (anything IconImage accepts)
//   size     icon size in pixels, changes are animated
//   enabled  inherited: a disabled icon is dimmed and ignores clicks
//   clicked  inherited signal from the mouse area, use onClicked
//   hovered  true while the mouse is over the icon
import QtQuick
import Quickshell.Widgets

WrapperMouseArea {
    id: root

    property string source
    property real size: 22
    readonly property bool hovered: containsMouse

    hoverEnabled: true
    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

    IconImage {
        implicitSize: root.size
        source: root.source
        opacity: root.enabled ? 1.0 : 0.4

        Behavior on implicitSize {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on opacity {
            NumberAnimation { duration: 120 }
        }
    }
}
