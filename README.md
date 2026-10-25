# dotfiles

Personal dotfiles for an Arch Linux + Hyprland desktop.

## Layout

Each directory mirrors its target under `~/.config/`.

| Directory   | Configures                                         | Target                |
| ----------- | -------------------------------------------------- | --------------------- |
| `hypr/`     | Hyprland (Lua config), hypridle, hyprlock          | `~/.config/hypr/`     |
| `git/`      | Global git config and ignore file                  | `~/.config/git/`      |
| `terminal/` | Terminal config (empty for now)                    | `~/.config/<name>/`   |

`.luarc.json` points the Lua language server at Hyprland's stubs for editor completion.

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

## Planned

- Move Claude Code config out of `~` to `~/.config/claude` via `CLAUDE_CONFIG_DIR`.
- Add waybar and Ghostty configs.
