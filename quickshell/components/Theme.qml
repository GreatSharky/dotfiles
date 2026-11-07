// Theme.qml
// Tokyo Night colors and shared style values. Use as `Theme.bg`, `Theme.accent`, ...
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  // Backgrounds, darkest to lightest
  readonly property color transparent: "transparent"
  readonly property color bgDark:    "#16161e"
  readonly property color bg:        "#1a1b26"
  readonly property color surface:   "#1f2335"   // popups, cards
  readonly property color bgHover:   "#292e42"   // hover, buttons, track of a slider
  readonly property color border:    "#3b4261"

  // Text
  readonly property color fg:        "#c0caf5"
  readonly property color fgDark:    "#a9b1d6"   // secondary text
  readonly property color muted:     "#565f89"   // comments, disabled, placeholders

  // Grays, darkest to lightest (blue-tinted like the rest of Tokyo Night)
  readonly property color lightGray:     "#2f3549"
  readonly property color gray:     "#545c7e"
  readonly property color darkGray:     "#9aa5ce"

  // Whites, brightest first
  readonly property color white:     "#ffffff"
  readonly property color offWhite:  "#e0e4f7"   // soft white with a slight blue tint
  readonly property color paleWhite: "#cdd3ee"   // dimmer, still brighter than fg

  // Meaning
  readonly property color accent:   "#7aa2f7"   // focus, selection, active
  readonly property color good:      "#9ece6a"
  readonly property color warn:      "#e0af68"
  readonly property color bad:       "#f7768e"

  // Extra hues
  readonly property color cyan:      "#7dcfff"
  readonly property color teal:      "#1abc9c"
  readonly property color blue:      "#7aa2f7"
  readonly property color sky:       "#7bb9fb"   // halfway between blue/accent and cyan
  readonly property color purple:    "#9d7cd8"
  readonly property color magenta:   "#bb9af7"
  readonly property color orange:    "#ff9e64"

  // Fonts
  readonly property string font:     "JetBrainsMono Nerd Font"
}
