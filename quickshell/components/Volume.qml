import Quickshell.Services.Pipewire

Indicator {
    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
    id: audio
    readonly property PwNodeAudio audiosink: Pipewire.defaultAudioSink?.audio
    readonly property var levelGlyphs: [
        { min: 0,   glyph: "" },
        { min: .11, glyph: "" },
        { min: .3, glyph: "" },
        { min: .6, glyph: "" }
    ]
    readonly property string mutedGlyph: ""
    readonly property var muted: audiosink?.muted ?? false

    icon: muted ? mutedGlyph : Functions.levelGlyph(audiosink?.volume ?? 0, levelGlyphs)
    text: muted ? "0 %" : `${Math.round((audiosink?.volume ?? 0)* 100)}%`
}
