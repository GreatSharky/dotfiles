// QuickSlider.qml
// A Controls slider that takes its colors from Theme. Palette roles used by the Basic style:
//   midlight   track              dark       filled part of the track
//   window     handle             light      handle while pressed
//   mid        handle outline     highlight  handle outline when focused
import QtQuick
import QtQuick.Controls.Basic

Slider {
    id: root

    palette.midlight: Theme.bgHover
    palette.dark: Theme.accent
    palette.window: Theme.fg
    palette.light: Theme.fgDark
    palette.mid: Theme.border
    palette.highlight: Theme.accent
    palette.windowText: Theme.fg
}
