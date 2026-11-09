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
        leftMargin: 10
        topMargin: 2
        bottomMargin: 2
      }
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      // The window is taller than the visible bar so icons can extend below it.
      // Only the bar height is reserved, and clicks in the transparent part pass through.
      implicitHeight: 50
      exclusiveZone: 30
      color: "transparent"
      mask: Region { item: bar }
      // Lets the popups (which belong to this window) receive keyboard input, e.g. the Wi-Fi
      // password field. The default is false, and a popup of a non-focusable window gets no keys.
      focusable: true

      // The visible bar. Everything is positioned relative to this strip.
      Item {
        id: bar
        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
        }
        height: 30

        Rectangle {
          anchors.fill: parent
          color: Qt.alpha(Theme.bg, 0.4)
        }

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
        StatusArea {
          id: statusarea
          anchors {
            right: parent.right
            rightMargin: systemtray.margin.leftMargin
            top: parent.top
            bottom: parent.bottom
          }
        }
        NavigationBar {
          anchors {
            left: workspaces.right
            leftMargin: systemtray.margin.leftMargin
            verticalCenter: parent.verticalCenter
          }
        }
      }
    }
  }
}
