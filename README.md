# dotfiles

Personal dotfiles for an Arch Linux + Hyprland desktop.

## Layout

Each directory mirrors its target under `~/.config/`.

| Directory  | Configures                                                  | Target                               |
| ---------- | ----------------------------------------------------------- | ------------------------------------ |
| `hypr/`    | Hyprland (Lua config), hypridle, hyprlock                   | `~/.config/hypr/`                    |
| `git/`     | Global git config and ignore file                           | `~/.config/git/`                     |
| `ghostty/` | Ghostty terminal (Tokyo Night theme, JetBrainsMono Nerd Font) | `~/.config/ghostty/`               |
| `bash/`    | Bash startup files                                          | `~/.bashrc`, `~/.bash_profile` (home) |

`.luarc.json` points the Lua language server at Hyprland's stubs for editor completion.

Bash is the exception to the convention: it has no XDG location, so `bash/bashrc` and `bash/bash_profile` link to `~/.bashrc` and `~/.bash_profile` in `$HOME`.

## Linking

This repo only holds the config files. Linking them into `~/.config` is handled by a separate project: <link to be added>.

## Dependencies

The configs expect these programs to be installed:

- Hyprland (with Lua config support), hypridle, hyprlock, hyprpaper, hyprlauncher
- waybar
- Ghostty
- Nautilus
- nm-applet
- brightnessctl
- Firefox

## Conventions

- Directory names match their `~/.config/<name>` target.
- No secrets in the repo. `.gitignore` excludes common secret file names, and `git/ignore` is the global ignore file installed to `~/.config/git/ignore`.

## Notes

- `bash/bashrc` sets history options, loads bash-completion, defines the `ll` alias, and builds a Tokyo Night prompt (time, user, full path, git branch and status) using truecolor escapes and git's `git-prompt.sh`.
- Hyprland uses the Finnish layout with the `nodeadkeys` variant, so `~` and `^` type with a single AltGr combination.
- Ghostty reads its config only at startup or on reload (Ctrl+Shift+, by default). If a long-running instance, such as the autostarted quake terminal, was started before the config was linked, reload it or restart it.

## Planned

- Move Claude Code config out of `~` to `~/.config/claude` via `CLAUDE_CONFIG_DIR`.
- Add a waybar config.
