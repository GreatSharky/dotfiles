# Quickshell

The desktop shell for Hyprland: a top bar, a wallpaper clock and popups, written in QML with [Quickshell](https://quickshell.org).

## Running

- Hyprland starts it from the autostart in `hypr/hyprland.lua` (`quickshell & hyprpaper & ...`).
- `~/.config/quickshell` is a symlink to this directory, and `shell.qml` is the entry point.
- `quickshell -c <name>` runs the config in `~/.config/quickshell/<name>/`. `quickshell -p <file>` runs a single file, which is handy for trying one component in isolation.
- Reloads when files are saved. Reloading sometimes does not trigger after a *new* file is added: save another file again, or restart.
- Logs are in `/run/user/<uid>/quickshell/by-pid/<pid>/log.qslog`. QML errors, `console.log` output and received Hyprland events all go there.
- `.qmlls.ini` is managed by Quickshell for the QML language server (`qmlls6`). It is machine specific, so it is gitignored.

## Layout

| Path | What it is |
| ---- | ---------- |
| `shell.qml` | Entry point: the wallpaper clock and the bar |
| `SystemTray.qml` | The bar. One `PanelWindow` per screen, 50 px tall but only 30 px reserved (`exclusiveZone`), so icons can grow below the strip.|
| `WallpaperClock.qml` | A large clock on the `bottom` layer, behind the windows |
| `components/` | Everything the bar is built from (below) |
| `icons/` | Custom app icons (see Conventions) |

## Components

Layout inside the bar: workspaces on the left, then the window map, the clock in the middle and the status area on the right.

| Component | What it does |
| --------- | ------------ |
| `Theme` | Singleton with the Tokyo Night colors and the font. Use `Theme.fg`, `Theme.accent` and so on instead of literals |
| `Functions` | Singleton with helpers: `levelGlyph` (pick a glyph for a 0 to 1 value from a `{ min, glyph }` list), `patternMatch`, and three width curves for the workspace pills |
| `Time`, `ClockWidget` | The clock: `Time` is a singleton text from `SystemClock`, `ClockWidget` is the `Text` that shows it (in the bar and on the wallpaper) |
| `Workspaces` | One pill per workspace, the focused one is widest |
| `NavigationBar` | The window map: icons of the tiled windows on the focused workspace, sorted by x position, click to focus |
| `AppIcon` | A clickable icon that animates its size |
| `Indicator` | An icon plus an optional value, with an optional `popup`. `percent` formats a value as `" 5 %"`, `"10 %"`, `"100%"` and keeps the width fixed so the bar and popups do not move |
| `StatusArea` | The right side of the bar |
| `Volume`, `Mic`, `Brightness`, `Battery`, `Network` | The indicators. Battery uses UPower, the network one uses `Quickshell.Networking` |
| `Poller` | A `Process` run on a timer, with its output in `output` |
| `QuickPopup`, `PopupManager` | The popup window (fade and grow animation, closes on a click outside via a Hyprland focus grab) and a singleton that keeps one popup open at a time |
| `VolumePanel`, `AudioSinkIndicator` | Volume popup: mute, volume, the list of outputs (a click sets the preferred default sink) and per-app streams |
| `NetworkPanel`, `WifiConnectionIndicator` | Wi-Fi popup: lists networks while open, a click connects (asks for a password inline when needed), a right click forgets a saved network |
| `QuickButton`, `QuickSlider`, `QuickSwitch` | Controls themed from `Theme`, built on `QtQuick.Controls.Basic` |
| `SectionHeader` | A labeled divider line |

## Conventions and gotchas

- **`components/qmldir` must list every component**, and singletons need the `singleton` prefix. A file that is not listed is "not a type" at runtime. The file exists so `qmlls` can see the singletons, which is why `Theme.fg` shows no `missing-property` warnings.
- **Custom icons:** `icons/<name>.svg` or `.png`, with the lowercase window class as the name, wins over the desktop-entry icon. A program inside a terminal is matched on the window title instead (`nvim`, `claude-code` in `NavigationBar.qml`). Unknown apps fall back to a generic icon.
- **Do not name a component after a Qt type.** A file that imports `QtQuick.Controls` sees Qt's own `Popup` instead of yours, which is why the popup is called `QuickPopup`.
- **Fixed-width popup content.** A layout recomputes its own `implicitWidth` from its children, so popup content is a plain `Item` with a fixed `implicitWidth` and the layout fills it. Otherwise the popup resizes and moves when a value changes.
- **Popups need `focusable: true` on the bar window** to receive keyboard input (the Wi-Fi password field).
- **Object models:** `Hyprland.workspaces`, `Pipewire.nodes` and similar are models. Use `.values` to get an array, and not on something that is already an array.
- **Mute state:** the mute keys switch both the PipeWire sink and the ALSA switch (see `hypr/hyprland.lua`), so the two agree.

## Hyprland and Quickshell talking to each other

Hyprland sends no event for a layout swap or for a brightness change, so `hypr/hyprland.lua` emits a custom event after the key runs. Quickshell receives it as `Hyprland.onRawEvent` with `name === "custom"`.

| Event data | Sent by | Handled in |
| ---------- | ------- | ---------- |
| `nav-refresh` | `swapColumn` binds (`SUPER+SHIFT+H/L`) | `NavigationBar.qml`, which re-reads the windows |
| `brightness:<brightnessctl -m line>` | the brightness keys (`changeBrightness`) | `Brightness.qml`, which reads the new value from the event |

The event names are plain strings in both places, so change them together.

## Dependencies

- Quickshell, Hyprland, PipeWire with WirePlumber
- NetworkManager, and `hyprpolkitagent` (connecting to a new network can need a polkit prompt)
- `brightnessctl`
- BlueZ, for Bluetooth (`bluez`, `bluez-utils`)
- JetBrainsMono Nerd Font (glyphs and the UI font)

## Notifications (spec, not built yet)

Notifications still come from `dunst`, which owns `org.freedesktop.Notifications` on the session bus. Only one program can own that name. This is the spec for replacing dunst with a Quickshell notification server (`Quickshell.Services.Notifications`). Losing notifications while Quickshell is not running is accepted, so there is no fallback daemon.

### Goals

1. Notifications do not distract. Quiet is the default.
2. Control per app: which styles an app may use.
3. From a notification, go to the app, even when its window is on another workspace.

### Styles

A notification can be presented in four ways, each decided separately:

| Style | What it is |
| ----- | ---------- |
| Sound | A short sound file played with `pw-play` (no Qt Multimedia is installed). Rate limited |
| Toast | A small text popup on a screen edge. Overlay window, no keyboard focus, click-through outside the card, short timeout, a limit on how many show at once |
| Panel | A dropdown from the bar with the stored notifications grouped by app, dismiss and clear all, the global modes and the per-app settings |
| Indicator | A bell with an unread count in the status area, and a dot on the app's icon in the navigation bar |

### Rules

- Every notification is stored and shown in the panel. The other styles are decided one by one.
- A style fires only when **the app allows it and no global mode blocks it**.
- The app is identified by the `desktopEntry` hint, falling back to `appName`.
- **A new app is quiet:** panel and indicator only, sound and toast off. It is added to the settings when it first notifies, and its styles are opted into from the panel.
- **Global modes** are three independent switches: no sound, no popups (the toast) and no indicators. They apply to every notification, and the panel stays available on demand.
- **No urgency passes the filters.** Critical notifications obey the modes and the app settings like all others.
- **Modes persist** until you change them, and survive a restart. No expiry.
- **The toast is configurable:** which edge or corner, and which monitor (the focused one or a named output).

### Going to the app

On a click, find the app's window and focus it with `hl.dsp.focus({ window = "address:0x…" })` through `Hyprland.dispatch`. This should also switch to the window's workspace (verify when building). The window is matched from the app (desktop entry or name) to the window class, the same way `NavigationBar` finds icons. With several matching windows, take the most recently focused. If none is running, launch the app's desktop entry. Then mark the notification as read. Do not rely on the notification's own default action, because on Wayland an app often cannot raise itself.

### Storage

Settings live in `Quickshell.statePath("notifications.json")`, not in the repo, so they are kept per machine. Rough shape:

```json
{
  "modes": { "noSound": false, "noPopups": false, "noIndicators": false },
  "toast": { "position": "top-right", "monitor": "focused" },
  "apps": { "org.telegram.desktop": { "sound": false, "toast": false, "panel": true, "indicator": true } }
}
```

### Build order

1. **Receive notifications.** Start a `NotificationServer`, log what arrives and test with `notify-send -a <app> ...`. Stop dunst first (below).
2. **Data model and settings.** Store notifications, load and save the settings file, resolve the app key and apply the rules (defaults, modes, no urgency bypass).
3. **Toast.** The edge popup, with position and monitor from the settings.
4. **Bell and panel.** Unread count in the bar and the panel with the notification list and the three mode switches.
5. **Per-app settings.** Edit the four styles per app from the panel.
6. **Sound.** Play a file for apps that allow it.
7. **Go to the app.** Window lookup and focus, launching the app if needed, and the dot on the app icon in the navigation bar.

### Shutting dunst down

dunst runs as the systemd user unit `dunst.service`, started on demand by D-Bus when the first notification arrives.

```
systemctl --user stop dunst.service      # stop it now
systemctl --user mask dunst.service      # stop D-Bus from starting it again
```
Undo with `systemctl --user unmask dunst.service`. Removing the package (`sudo pacman -Rns dunst`) has the same effect for good. With dunst masked and Quickshell not running, programs that send a notification get an error and nothing is shown.

## Roadmap

- Build the notification system above.

## Resources

- Quickshell guide and types reference (v0.3.2): https://quickshell.org/docs/v0.3.2/
- The Qt Quick documentation for the QML side (properties, bindings, layouts, `Repeater`, signals).
