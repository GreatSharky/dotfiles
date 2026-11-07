// StatusArea.qml
// Right-hand side of the bar. Add one indicator component per item.
import QtQuick
import QtQuick.Layouts

RowLayout {
  spacing: 12

  // Placeholder to check the layout. Replace it with `Battery {}` once
  // components/Battery.qml exists, and add the other indicators below it.

  Mic {}
  Volume {
    id: volume
    popup: Popup { 
      id: volpop
      anchor.item: volume
      anchor.rect.y: volume.height
      anchor.rect.x: volume.x - volpop.implicitWidth / 2
    }
  }
  Brightness {
    id: brightness
    popup: Popup {
      id: bpop
      anchor.item: brightness
      anchor.rect.y: brightness.height
      anchor.rect.x: brightness.x - bpop.implicitWidth / 2
    }
  }
  Battery {}
  Network {}
}
