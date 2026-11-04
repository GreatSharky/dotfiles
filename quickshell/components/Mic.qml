import Quickshell.Services.Pipewire

Indicator {
    PwObjectTracker { objects: [Pipewire.defaultAudioSource] }
    id: mic
    readonly property PwNodeAudio audiosink: Pipewire.defaultAudioSource?.audio
    readonly property string micGlyph: "󰍮"
    readonly property var muted: audiosink?.muted ?? false

    icon: muted ? "" : micGlyph
}
