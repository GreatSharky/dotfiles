import QtQuick
import Quickshell.Hyprland

Indicator {
    id: brightness
    property real level: 0
    readonly property var levelGlyphs: [
        { min: 0,   glyph: "" },
        { min: .3, glyph: "" },
        { min: .6, glyph: "" },
    ]

    // Parse a brightnessctl machine-readable line: device,class,value,percent,max
    function apply(state) {
        const fields = state.trim().split(",")
        level = fields.length > 4 ? Number(fields[2]) / Number(fields[4]) : 0
    }

    // hyprland.lua sends the new state right after the brightness keys change it:
    // `custom>>brightness:<brightnessctl line>`. Keep the name in sync with changeBrightness().
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "custom" && event.data.startsWith("brightness:"))
                brightness.apply(event.data.slice("brightness:".length))
        }
    }

    icon: Functions.levelGlyph(level, levelGlyphs)
    percent: level * 100

    Poller {
        id: poller
        // Slow fallback: the keys report their own changes, this catches everything else.
        interval: 10000
        command: "brightnessctl -m -c backlight"
        onOutputChanged: brightness.apply(poller.output)
    }
}
