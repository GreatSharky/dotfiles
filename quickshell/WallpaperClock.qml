import Quickshell
import Quickshell.Wayland
import qs.components

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      WlrLayershell.layer: WlrLayer.Bottom
      exclusionMode: ExclusionMode.Ignore
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
        bottom: true
      }

      implicitHeight: clock.height
      implicitWidth: clock.width
      color: "transparent"

      ClockWidget {
        id: clock
        anchors.centerIn: parent
        font.pixelSize: 150
      }
    }
  }
}
