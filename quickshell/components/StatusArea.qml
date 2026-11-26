// StatusArea.qml
// Right-hand side of the bar. Add one indicator component per item.
import QtQuick
import QtQuick.Layouts

RowLayout {
  spacing: 12

  // Placeholder to check the layout. Replace it with `Battery {}` once
  // components/Battery.qml exists, and add the other indicators below it.
  NotificationIndicator {}
  Mic {}
  Volume {}
  Brightness {}
  Battery {}
  Network {}
}
