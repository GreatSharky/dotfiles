import Quickshell.Networking

Indicator {
    id: network
    readonly property NetworkDevice connectedDev: Networking.devices.values.find(d => d.connected)
    readonly property bool internet: Networking.connectivity == NetworkConnectivity.Full
    readonly property bool isWifi: connectedDev.type == DeviceType.Wifi
    readonly property WifiNetwork connection: isWifi ? connectedDev.networks.values.find(d => d.connected) : null 
    readonly property var levelGlyphs: [
        { min: 0,   glyph: "󰤯" },
        { min: 0.4, glyph: "󰤢" },
        { min: 0.6, glyph: "󰤨" },
    ]
    readonly property var connectionName: connection?.name
    readonly property real signalStrenght: connection?.signalStrength

    icon: !connectedDev ? "󰤮" 
    : !internet ? "󰤩"
    : !isWifi ? "󱘖"
    : Functions.levelGlyph(signalStrenght, levelGlyphs)
}
