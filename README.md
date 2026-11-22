# dotfiles

Personal dotfiles for an Arch Linux + Hyprland desktop.

## Layout

Each directory mirrors its target under `~/.config/`.

| Directory     | Configures                                                    | Target                                |
| ------------- | ------------------------------------------------------------- | ------------------------------------- |
| `hypr/`       | Hyprland (Lua config), hypridle, hyprlock, hyprpaper          | `~/.config/hypr/`                     |
| `quickshell/` | Quickshell: the bar, wallpaper clock and popups (see its README) | `~/.config/quickshell/`            |
| `git/`        | Global git config and ignore file                             | `~/.config/git/`                      |
| `ghostty/`    | Ghostty terminal (Tokyo Night theme, JetBrainsMono Nerd Font) | `~/.config/ghostty/`                  |
| `bash/`       | Bash startup files                                            | `~/.bashrc`, `~/.bash_profile` (home) |

`.luarc.json` points the Lua language server at Hyprland's stubs for editor completion.

Bash is the exception to the convention: it has no XDG location, so `bash/bashrc` and `bash/bash_profile` link to `~/.bashrc` and `~/.bash_profile` in `$HOME`.

## Linking

This repo only holds the config files. Linking them into `~/.config` is handled by a separate project: <link to be added>.

## Dependencies

Dependencies are designed to be handled by an Ansible-playbook that also does the linking for these configs. The configs expect these programs to be installed:

- Hyprland (with Lua config support), hypridle, hyprlock, hyprpaper, hyprlauncher, hyprpolkitagent
- Quickshell (the bar, see `quickshell/README.md` for its own requirements)
- Ghostty
- Nautilus
- Firefox
- NetworkManager
- PipeWire with WirePlumber (`wpctl`), and `alsa-utils` (`amixer`) for the mute keys
- `brightnessctl`
- `playerctl` for the media keys
- BlueZ (`bluez`, `bluez-utils`) for Bluetooth
- dunst for notifications, until Quickshell takes that over
- JetBrainsMono Nerd Font

## Conventions

- Directory names match their `~/.config/<name>` target.
- No secrets in the repo. `.gitignore` excludes common secret file names, and `git/ignore` is the global ignore file installed to `~/.config/git/ignore`.

## Notes

- `bash/bashrc` sets history options, loads bash-completion, defines the `ll` alias, and builds a Tokyo Night prompt (time, user, full path, git branch and status) using truecolor escapes and git's `git-prompt.sh`.
- `bash/bash_profile` sets the XDG directories, `CLAUDE_CONFIG_DIR` and `ANSIBLE_HOME`, picks `nvim` as `EDITOR` when it is installed (otherwise `vim`), and only redirects the less and Python history files when their state directories already exist.
- Hyprland uses the Finnish layout with the `nodeadkeys` variant, so `~` and `^` type with a single AltGr combination, and the `scrolling` layout.
- Some Hyprland key binds are Lua functions that also tell Quickshell what changed, by emitting a custom event (for example `nav-refresh` after swapping columns, and the new value after a brightness key). The events and where they are handled are listed in `quickshell/README.md`.
- Hyprland starts the session programs itself: Quickshell, hyprpaper, Firefox, hypridle, the polkit agent and a quake-style Ghostty. greetd launches Hyprland, so `bash_profile` is not read there. Environment for the desktop session is set in `hypr/hyprland.lua`.
- Ghostty reads its config only at startup or on reload (Ctrl+Shift+, by default). If a long-running instance, such as the autostarted quake terminal, was started before the config was linked, reload it or restart it.
- After a long gap between updates, run a full `sudo pacman -Syu` before installing anything. A stale package database gives 404 errors, and `pacman -Sy <package>` alone is a partial upgrade that can break the system.

## Planned

- Track the Claude Code config in `~/.config/claude` (settings and skills only, never credentials).
- Quickshell: Bluetooth audio and a notification daemon (see `quickshell/README.md`).
