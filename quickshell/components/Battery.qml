import Quickshell.Services.UPower
import QtQuick

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
    property bool lowPower: powerinfo.percentage < .10
    property bool blinkRed: false

    visible: powerinfo.isLaptopBattery
    icon: charging ? chargingGlyph : Functions.levelGlyph(powerinfo.percentage, levelGlyphs)
    percent: powerinfo.percentage * 100
    color: blinkRed ? Theme.bad : Theme.offWhite

    Timer {
        id: blinker
        running: battery.lowPower
        interval: 10000 * battery.powerinfo.percentage
        repeat: battery.lowPower
        onTriggered: { battery.blinkRed = !battery.blinkRed}
    }
}
