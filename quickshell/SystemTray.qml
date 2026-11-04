import Quickshell
import Quickshell.Widgets
import qs.components
import QtQuick

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: systemtray
      required property var modelData
      property var margin: MarginWrapperManager {
        leftMargin: 5
        topMargin: 2
        bottomMargin: 2
      }
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30
      color: Qt.rgba(.2,.2,.2,.5)

      ClockWidget {
        id: clock
        anchors.centerIn: parent
        font.pixelSize: 25
      }
      Workspaces {
        id: workspaces
        anchors {
          left: parent.left
          leftMargin: systemtray.margin.leftMargin
          verticalCenter: parent.verticalCenter
        }
      }
    }
  }
}
