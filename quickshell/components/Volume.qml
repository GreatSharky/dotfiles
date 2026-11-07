import Quickshell.Services.Pipewire
import QtQuick

Indicator {
    id: audio
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    readonly property PwNodeAudio audiosink: Pipewire.defaultAudioSink?.audio
    readonly property var levelGlyphs: [
        { min: 0, glyph: "" },
        { min: .11, glyph: "" },
        { min: .3, glyph: "" },
        { min: .6, glyph: "" }
    ]
    readonly property string mutedGlyph: ""
    readonly property var muted: audiosink?.muted ?? false

    icon: muted ? mutedGlyph : Functions.levelGlyph(audiosink?.volume ?? 0, levelGlyphs)
    text: muted ? "0 %" : `${Math.round((audiosink?.volume ?? 0) * 100)}%`

    popup: BarPopup {
        id: popup
        anchor.item: audio
        anchor.rect.y: audio.height
        anchor.rect.x: audio.x - popup.implicitWidth / 2

        VolumePanel {}
    }
}
