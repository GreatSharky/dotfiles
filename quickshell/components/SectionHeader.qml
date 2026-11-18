// SectionHeader.qml
// A labeled divider: the label, then a thin line that takes the rest of the width.
//   SectionHeader { label: "Output"; Layout.fillWidth: true }
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    property string label: ""
    property int fontsize: 14
    property var textcolor: Theme.fgDark

    spacing: 6

    Text {
        text: parent.label
        color: root.textcolor
        font.family: Theme.font
        font.pixelSize: root.fontsize
    }

    Rectangle {
        Layout.fillWidth: true            // the line takes all the remaining width
        Layout.alignment: Qt.AlignVCenter
        implicitHeight: 1
        color: Theme.muted
    }
}
