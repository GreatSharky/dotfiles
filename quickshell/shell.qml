import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import qs.components

Scope {
  WallpaperClock {}
  SystemTray {}

  // Lets keybinds trigger a refresh: `qs ipc call nav refresh`
  IpcHandler {
    target: "nav"
    function refresh(): void { Hyprland.refreshToplevels() }
  }
}
