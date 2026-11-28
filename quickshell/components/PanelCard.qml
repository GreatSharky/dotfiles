import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    required property var record
    property alias actions: actionRow.data

    property var settings: NotificationStore.settings
    property var appSettings: NotificationStore.settings.apps[record.key] ?? NotificationStore.quietDefaults
    property var soundIcon: appSettings.sound ? "󰂞" : "󱏧"
    property var toastIcon: appSettings.toast ? "" : "󰳯"
    property var panelIcon: appSettings.panel ? "󰂚" : "󰂛"
    property var indicatorIcon: appSettings.indicator ? "" : ""

    implicitHeight: column.implicitHeight + 2 * border.width
    radius: 10
    color: Theme.surface
    border.width: 1
    border.color: Theme.border

    function toggle(flag) {
        NotificationStore.setAppFlag(record.key, flag, !appSettings[flag]);
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: root.border.width
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: actionRow.implicitHeight + 4
            color: Theme.bgDark
            topLeftRadius: root.radius - root.border.width
            topRightRadius: root.radius - root.border.width

            RowLayout {
                id: actionRow
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                }
                Item {
                    Layout.fillWidth: true
                }

                QuickButton {
                    text: root.soundIcon
                    font.pixelSize: 20
                    onClicked: root.toggle("sound")
                }

                QuickButton {
                    text: root.toastIcon
                    font.pixelSize: 20
                    onClicked: root.toggle("toast")
                }

                QuickButton {
                    text: root.panelIcon
                    font.pixelSize: 20
                    //onClicked: root.toggle("panel")
                }

                QuickButton {
                    text: root.indicatorIcon
                    font.pixelSize: 20
                    onClicked: root.toggle("indicator")
                }

                QuickButton {
                    text: ""
                    font.pixelSize: 20
                    onClicked: NotificationStore.dismiss(root.record.id)
                }
            }
        }

        NotificationCard {
            Layout.fillWidth: true
            record: root.record
            color: "transparent"
            border.width: 0
        }
    }
}
