import Quickshell
import Quickshell.Wayland

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
      }
    }
  }
}
