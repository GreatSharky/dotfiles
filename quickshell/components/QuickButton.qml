// QuickButton.qml
// A Controls button that takes its colors from Theme. Palette roles used by the Basic style:
//   button       fill            buttonText / windowText  label (windowText when flat)
//   mid          pressed shade   dark                     fill when checked or highlighted
//   brightText   label on a checked or highlighted button
//   highlight    keyboard focus outline
import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    font.family: Theme.font
    padding: 6
    horizontalPadding: 10
    implicitHeight: 32
    implicitWidth: Math.max(implicitHeight, contentItem.implicitWidth + leftPadding + rightPadding)

    palette.button: Theme.bgHover
    palette.buttonText: Theme.fg
    palette.windowText: Theme.fg
    palette.dark: Theme.accent
    palette.brightText: Theme.bg
    palette.mid: Theme.border
    palette.highlight: Theme.accent
}
