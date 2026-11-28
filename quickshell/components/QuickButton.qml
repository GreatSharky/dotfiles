// QuickButton.qml
// A Controls button that takes its colors from Theme. It draws its own background, so radius,
// borderWidth and borderColor can be set per button. The label color comes from the palette.
// The Basic style's `flat` and `highlighted` looks are not drawn.
import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    property int radius: 6
    property int borderWidth: 1
    property color borderColor: Theme.border

    font.family: Theme.fontmono
    padding: 6
    horizontalPadding: 10
    implicitHeight: 32
    implicitWidth: Math.max(implicitHeight, contentItem.implicitWidth + leftPadding + rightPadding)

    palette.buttonText: Theme.fg
    palette.windowText: Theme.fg

    background: Rectangle {
        radius: root.radius
        color: root.down || root.checked ? Theme.border : Theme.bgHover
        border.width: root.borderWidth
        border.color: root.hovered || root.visualFocus ? Theme.accent : root.borderColor
    }
}
