import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    implicitWidth: 380
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.fill: parent

        Repeater {
            model: ScriptModel {
                values: NotificationStore.panelItems
            }
            NotificationCard {
                required property var modelData
                implicitWidth: root.implicitWidth
                record: modelData
            }
        }
    }
}
