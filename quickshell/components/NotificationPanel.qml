import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    implicitWidth: 380
    implicitHeight: layout.implicitHeight

    property var modesettings: NotificationStore.settings.modes

    // Everything (111), nosounds(011), nopopups(001), noindicators(000)
    readonly property var modes: [
        {
            icon: "󰂞",
            values: { noSound: false, noPopups: false, noIndicators: false },
            name: "Sound"
        },
        {
            icon: "󰂚",
            values: { noSound: true, noPopups: false, noIndicators: false },
            name: "Popups"
        },
        {
            icon: "󰂛",
            values: { noSound: true, noPopups: true, noIndicators: false },
            name: "Indicators"
        },
        {
            icon: "󰈉",
            values: {
                noSound: true,
                noPopups: true,
                noIndicators: true
            },
            name: "Muted"
        }
    ]
    readonly property var modeIndex: modes.findIndex(m => Object.keys(m.values).every(k => m.values[k] === modesettings[k]))
    readonly property var modeIcon: modes[root.modeIndex]?.icon ?? ""
    function nextMode() {
        const next = modes[(modeIndex + 1) % modes.length];
        for (const key in next.values)
            NotificationStore.setMode(key, next.values[key]);
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: masterControl.implicitHeight
            color: Theme.surface
            RowLayout {
                id: masterControl
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                }
                Text {
                    text: modes[root.modeIndex]?.name ?? ""
                    font.family: Theme.font
                    font.pixelSize: 20
                    color: Theme.fg
                }
                Item {
                    Layout.fillWidth: true
                }

                QuickButton {
                    text: modes[root.modeIndex]?.icon ?? ""
                    font.pixelSize: 28
                    onClicked: root.nextMode()
                }
            }
        }
        Repeater {
            model: ScriptModel {
                values: NotificationStore.panelItems
            }
            PanelCard {
                required property var modelData
                implicitWidth: root.implicitWidth
                record: modelData
            }
        }
    }
}
