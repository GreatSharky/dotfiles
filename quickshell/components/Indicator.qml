// Indicator.qml
// A reusable icon + optional text pair for the status area.
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperMouseArea {
  id: root
  // In a layout, fill the full height so the whole bar height is clickable.
  Layout.fillHeight: true
  // Nerd Font glyph, e.g. "󰁹"
  property string icon: ""
  // Value text next to the icon. Leave empty to show only the icon.
  property string text: ""
  property color color: Theme.offWhite
  property int fontSize: 16
  property BarPopup popup

  onClicked: {
    console.log(`${root.icon}-${root.text} clicked`)
    if (popup) popup.open = !popup.open
  }
  cursorShape: enabled && popup ? Qt.PointingHandCursor : Qt.ArrowCursor

  Row {
    spacing: 4

    Text {
      visible: root.icon !== ""
      text: root.icon
      color: root.color
      font.family: Theme.font
      font.pixelSize: root.fontSize
      anchors.verticalCenter: parent.verticalCenter
    }

    Text {
      visible: root.text !== ""
      text: root.text
      color: root.color
      font.family: Theme.font
      font.pixelSize: root.fontSize
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
