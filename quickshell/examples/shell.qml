import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
  Text {
    id: boundText
    text: `button is pressed: ${theButton.pressed}`
  }

  Button {
    id: theButton
    text: "break the binding"
    onClicked: boundText.text = `button was pressed at the time the binding was broken: ${pressed}`
  }
}
