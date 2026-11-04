import Quickshell.Services.UPower

Indicator {
    id: battery
    readonly property UPowerDevice powerinfo: UPower.displayDevice
    readonly property var levelGlyphs: [
        { min: 0,   glyph: "󰁺" },
        { min: 0.2, glyph: "󰁼" },
        { min: 0.4, glyph: "󰁾" },
        { min: 0.6, glyph: "󰂁" },
        { min: 0.8, glyph: "󰁹" }
    ]
    readonly property string chargingGlyph: "󰂄"
    readonly property var charging: powerinfo.state == UPowerDeviceState.Charging || powerinfo.state == UPowerDeviceState.FullyCharged

    visible: powerinfo.isLaptopBattery
    icon: charging ? chargingGlyph : Functions.levelGlyph(powerinfo.percentage, levelGlyphs)
    text: `${Math.round(powerinfo.percentage * 100)}%`
}
