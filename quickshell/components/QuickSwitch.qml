// QuickToggle.qml
// A Controls switch drawn from Theme colors. The track and knob are drawn here,
// so the size is set with trackWidth / trackHeight / knobMargin.
//   orientation   Qt.Horizontal (knob slides right when on) or Qt.Vertical (knob slides up when on)
//   windowText    label     base   blended in when disabled
import QtQuick
import QtQuick.Controls.Basic

Switch {
    id: root

    // trackWidth is the long side, trackHeight the short side, whatever the orientation.
    property int trackWidth: 36
    property int trackHeight: 20
    property int knobMargin: 2
    property int orientation: Qt.Horizontal
    readonly property bool horizontal: orientation === Qt.Horizontal

    font.family: Theme.font
    padding: 0
    spacing: text ? 8 : 0

    palette.windowText: Theme.fg
    palette.base: Theme.bg

    indicator: Rectangle {
        implicitWidth: root.horizontal ? root.trackWidth : root.trackHeight
        implicitHeight: root.horizontal ? root.trackHeight : root.trackWidth
        x: root.text ? root.leftPadding
                     : root.leftPadding + (root.availableWidth - width) / 2
        y: root.topPadding + (root.availableHeight - height) / 2
        radius: Math.min(width, height) / 2
        color: root.checked ? Theme.accent : Theme.bgHover
        opacity: root.enabled ? 1 : 0.5

        Behavior on color { ColorAnimation { duration: 120 } }

        // The knob
        Rectangle {
            width: Math.min(parent.width, parent.height) - 2 * root.knobMargin
            height: width
            radius: width / 2
            x: root.horizontal
               ? (root.checked ? parent.width - width - root.knobMargin : root.knobMargin)
               : root.knobMargin
            y: root.horizontal
               ? root.knobMargin
               : (root.checked ? root.knobMargin : parent.height - height - root.knobMargin)
            color: Theme.fg

            Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
            Behavior on y { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
        }
    }
}
