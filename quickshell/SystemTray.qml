import Quickshell
import Quickshell.Widgets
import qs.components
import QtQuick

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 25
      color: Qt.rgba(.2,.2,.2,.5)

      ClockWidget {
        id: clock
        anchors.centerIn: parent
        font.pixelSize: 30
      }
      Workspaces {
        id: workspaces
        anchors.left: parent.left
      }
    }
  }
}
