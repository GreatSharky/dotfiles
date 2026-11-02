# Quickshell

Notes and a roadmap for replacing Waybar with a Quickshell bar.

## Resources

- Guide: https://quickshell.org/docs/v0.3.2/guide/
- Types reference: the same site, under the v0.3.2 docs. Most useful modules for the bar:
  `Quickshell`, `Quickshell.Io`, `Quickshell.Hyprland`, `Quickshell.Services`, `Quickshell.Widgets`.
- QML itself: the Qt Quick documentation (properties, bindings, `Item`, `Rectangle`, `Row`, `Column`, `Text`, `Repeater`, signals, `Timer`).
- Other people's configs: search GitHub for `quickshell` for structure and ideas.

## Running

- `quickshell` loads `~/.config/quickshell/shell.qml`, which links to this directory.
- `quickshell -c <name>` runs the config in `~/.config/quickshell/<name>/`.
- It live-reloads when files are saved.
- `.qmlls.ini` is generated for the QML language server and is machine-specific, so it is gitignored.

## Learning order for the bar

1. **A window with a clock.** A `PanelWindow` anchored to the top with a `Text` driven by a clock (`SystemClock`, or a `Process` running `date` as in `Time.qml`).
2. **Workspaces** from `Quickshell.Hyprland`.
3. **Volume and mic status** from `Quickshell.Services.Pipewire`. Mute state needs both PipeWire and the ALSA switches to agree (see `hypr/hyprland.lua`).
4. **Battery, network and the tray**, which are service modules under `Quickshell.Services`.
5. **Theme it** with the Tokyo Night colors already used in the bash prompt and Ghostty.

## Goal: window map

A navigation widget that shows the windows to the left and right of the focused one, each with its app icon. Hyprland uses the `scrolling` layout, so windows sit side by side in columns and "left and right" is meaningful.

Approach to try (verify each piece against the docs, the API names below are from memory):

- **Window list:** `Hyprland.toplevels` from `Quickshell.Hyprland`. Each toplevel exposes its IPC data through `lastIpcObject`, which should include the window position (`at`), size, class and workspace. Call `Hyprland.refreshToplevels()` when it goes stale.
- **Order:** keep only windows on the focused workspace and sort them by x position. Find the focused one (`activated`) and take its neighbours.
- **Icons:** map the window class or app id to a desktop entry with `DesktopEntries` and show it with `IconImage` (`Quickshell.Widgets`) and `Quickshell.iconPath(...)`. Needs a fallback icon for unknown apps.
- **Display:** a `Row` with a `Repeater` over the sorted list, with the focused window highlighted.
- **Interaction (later):** clicking an icon focuses that window through `Hyprland.dispatch(...)`.
- **Updates:** react to Hyprland events instead of polling, if the module exposes them.

Open questions to answer while building:

- Does `lastIpcObject` expose enough position data to order windows inside the scrolling layout?
- Should it show all windows on the workspace, or only a fixed number on each side?
