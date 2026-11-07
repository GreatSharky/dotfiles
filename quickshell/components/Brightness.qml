import QtQuick

Indicator {
    id: brightness
    property real level: 0
    readonly property var levelGlyphs: [
        { min: 0,   glyph: "" },
        { min: .3, glyph: "" },
        { min: .6, glyph: "" },
    ]


    icon: Functions.levelGlyph(level, levelGlyphs)
    percent: level * 100

    Poller {
        id: poller
        interval: 1000
        command: "brightnessctl -m -c backlight"
        onOutputChanged: {
            const fields = poller.output.trim().split(",")
            brightness.level = fields.length > 4 ? Number(fields[2]) / Number(fields[4]) : 0
        }
    }
}
