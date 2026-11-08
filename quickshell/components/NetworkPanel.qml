pragma ComponentBehavior: Bound
// NetworkPanel.qml
// Content of the volume popup: output name, mute toggle and volume slider.
import Quickshell.Networking
import Quickshell.Widgets
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: networkpopup
    // Fixed width, set on a plain Item: a layout recomputes its own implicitWidth from its
    // children, so only an Item can really pin the popup window size.
    implicitWidth: 200
    implicitHeight: layout.implicitHeight
    // The Wi-Fi device (not "the connected device", which could be the wired one).
    property NetworkDevice wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    // Set by the popup: scan for nearby networks only while it is open.
    property bool scanning: false
    property var stateGlyph: ({ connected: "", known: "󱓴", unknown: "󱚖" })

    // Nearby networks are only listed while the device scans. A Binding is used because
    // `wifi` is an object reference, and it follows the device if that changes.
    Binding {
        target: networkpopup.wifi
        property: "scannerEnabled"
        value: networkpopup.scanning
        when: networkpopup.wifi !== null
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent

        Repeater {
            model: ScriptModel { values: networkpopup.wifi?.networks.values ?? [] }
            WrapperRectangle {
                id: stream
                Layout.fillWidth: true
                required property var modelData
                color: Theme.surface
                property color textcolor: {
                    stream.modelData.connected ? Theme.fg
                    : stream.modelData.known ? Theme.fgDark
                    : Theme.warn
                }
                RowLayout {
                    spacing: 0
                    Text {
                        elide: Text.ElideRight
                        text: stream.modelData.name
                        color: stream.textcolor
                        font.family: Theme.font
                        font.pixelSize: 12
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: {
                            stream.modelData.connected ? networkpopup.stateGlyph.connected
                            : stream.modelData.known ? networkpopup.stateGlyph.known
                            : networkpopup.stateGlyph.unknown
                        }
                        color: stream.textcolor
                        font.family: Theme.font
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
