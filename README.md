# i3_GUI_setup

This is my minimal i3 desktop setup. It brings together the window manager, a program launcher, a status bar and a few desktop tools, along with my personal Vim configuration.

The files are in [minimal_i3_setup](minimal_i3_setup). The install script installs the packages and copies the configuration into an existing user's home directory. Some of the configuration still contains paths from my own machine, so those need checking before use.

## Requirements

The scripts use Bash, `apt-get`, `dpkg-query` and GNU command-line tools. They are intended for a Debian-style system with an existing non-root user and home directory. Run them as root, either through `sudo` or from a root shell.

The package names are taken directly from the install script. Their availability depends on the configured repositories; the script does not select alternatives when a package is missing.

## What gets installed

| Package | Purpose |
| --- | --- |
| `x-window-system` | X window system |
| `sudo` | Run commands as another user |
| `i3` | Tiling window manager |
| `i3blocks` | Status information for the i3 bar |
| `ranger` | Terminal file browser |
| `feh` | Image viewer and desktop background |
| `flameshot` | Screenshot tool |
| `compton` | Window compositor |
| `rofi` | Program launcher |
| `udiskie` | Removable-drive handling |
| `clipit` | Clipboard manager |
| `smbclient`, `cifs-utils` | Access to SMB file shares |
| `vim-gtk` | Vim editor |

The installer also adds the selected user to the `sudo` group and creates `Documents`, `Pictures` and `.config` directories where needed.

## Configuration

These paths are relative to the selected user's home directory.

| File | Purpose |
| --- | --- |
| `.profile` | Shell login settings, including a call to `startx` |
| `.xinitrc` | Load X resources and start i3 through `dbus-run-session` |
| `.Xresources` | X application settings |
| `.config/i3/config` | Shortcuts, workspaces, status bar and startup applications |
| `.config/compton.conf` | Compositor settings |
| `.vimrc` | Personal Vim settings using built-in features |
| `Pictures/background.jpg` | Desktop background loaded by `feh` |

Before installing, review these details in the supplied files:

- `.xinitrc` loads `/home/christian/.Xresources`. Change this to your own path, or use `userresources="$HOME/.Xresources"`.
- The i3 file-browser shortcut runs `/home/christian/.local/bin/ranger`. Adjust it to the Ranger executable on your system.
- The i3 configuration starts `parcellite`, while the installer installs `clipit`. Choose the clipboard manager you want and make the startup command match.
- The configuration also calls `nmtui-connect`, `brightnessctl`, `pamixer`, `xsel`, `xterm` and `w3m`. The installer does not explicitly install these tools. The affected shortcuts require them to be available.
- `.profile` calls `startx` without checking whether X is already running or whether the login is on a local console. Adjust this if you use a display manager or remote shell logins. The session also needs `startx` and `dbus-run-session` to be available.

The Vim configuration enables line numbers, case-aware searching, manual folding and persistent undo. Vim creates `~/.vim/undo` when persistent undo is supported. The uninstaller leaves that directory in place.

## Installation

From the repository directory, run:

```bash
sudo bash minimal_i3_setup/install.sh username
```

Replace `username` with the existing account to configure. If you omit it, the script uses `SUDO_USER` when available, otherwise it asks for a username. From a root shell, run the same command without `sudo`.

The script checks the account and source files, updates the package index, then installs the packages with `apt-get install -y`. It uses the home directory recorded for the account rather than assuming `/home/username`.

Existing configuration files are replaced, with numbered backups kept alongside them, such as `.vimrc.~1~`. The `Pictures` and `.config` directories are merged with the supplied directories. Unrelated files are retained. Running the installer again creates further backups for files it replaces.

The script stops if a command fails and reports the line number. Earlier changes are not automatically rolled back. After a successful installation, log out and log back in to apply the group membership and login settings.

## i3 shortcuts

`Mod` is set to `Mod4`, normally the Super or Windows key.

| Shortcut | Action |
| --- | --- |
| `Mod + Enter` | Open a terminal |
| `Mod + d` | Open Rofi |
| `Mod + o` | Open Ranger using the configured path |
| `Mod + i` | Open `nmtui-connect` in a terminal |
| `Print` | Open Flameshot's screenshot interface |
| `Mod + u` | Open the clipboard URL in `w3m` through `xterm` |
| `Mod + arrow keys` | Move focus between windows |
| `Mod + j` / `k` / `l` / `;` | Focus left / down / up / right |
| `Mod + Shift + arrow keys` | Move the focused window |
| `Mod + Shift + j` / `k` / `l` / `;` | Move the window left / down / up / right |
| `Mod + 1` to `Mod + 0` | Switch to workspaces 1–10 |
| `Mod + Shift + 1` to `Mod + Shift + 0` | Move the window to a workspace |
| `Mod + h` / `Mod + v` | Set horizontal / vertical splitting |
| `Mod + f` | Toggle fullscreen |
| `Mod + s` | Use a stacked layout |
| `Mod + w` | Use a tabbed layout |
| `Mod + e` | Toggle the split layout |
| `Mod + a` | Focus the parent container |
| `Mod + r` | Enter resize mode; use Enter or Escape to leave |
| `Mod + Shift + Space` | Toggle the focused window between tiling and floating |
| `Mod + Space` | Switch focus between tiling and floating windows |
| `Mod + mouse drag` | Move a floating window |
| `Mod + Shift + q` | Close the focused window |
| `Mod + Shift + c` | Reload the configuration |
| `Mod + Shift + r` | Restart i3 in place |
| `Mod + Shift + e` | Ask to exit the i3 session |

The letter keys follow the order in the configuration: `j` moves left, `k` down, `l` up and `;` right. They are alternatives to the arrow keys.

After pressing `Mod + r`, use these keys without holding Mod. Each resize binding requests a change of `10 px or 10 ppt`, as written in the i3 configuration.

| Resize-mode key | Action |
| --- | --- |
| `Left` or `j` | Shrink the width |
| `Down` or `k` | Grow the height |
| `Up` or `l` | Shrink the height |
| `Right` or `;` | Grow the width |
| `Enter` or `Escape` | Leave resize mode |

The media keys use these commands. They require `brightnessctl` and `pamixer`, which are not explicitly installed by the script.

| Key | Command |
| --- | --- |
| Brightness up | `brightnessctl set +10%` |
| Brightness down | `brightnessctl set 10%-` |
| Volume up | `pamixer -i 5` |
| Volume down | `pamixer -d 5` |
| Mute | `pamixer -t` |

## Uninstalling

Keep the setup directory available. The uninstaller uses its files to identify which paths to handle.

To see the file and package candidates without changing anything:

```bash
sudo bash minimal_i3_setup/uninstall.sh --dry-run username
```

To uninstall interactively:

```bash
sudo bash minimal_i3_setup/uninstall.sh username
```

The script asks separately before changing each configuration file and before uninstalling each installed package from the setup list. Pressing Enter keeps the item. Answer `y` or `yes` to approve a change.

For a file with numbered backups, it offers to restore the oldest backup. The current file and the numbered backups are saved in a private `.minimal-i3-uninstall.*` directory in the user's home. For a file without a backup, it asks to move the file into that archive. This includes files you have edited since installation. The archive path is printed when it is created.

Package removal uses `apt-get remove`, with APT's normal confirmation so you can review any dependent removals. The installer does not record which packages were already present, so the uninstaller also offers packages that may predate this setup. `sudo` is offered last; keep it if you still need it to administer the machine.

Unrelated files, directories and `sudo` group membership are retained. Symlinked file paths and paths beneath symlinked directories are skipped. The script does not purge package configuration or run `autoremove`, so it does not return the whole system to a recorded pre-install state. Each run reviews the current files again, including any settings restored on a previous run.

## Useful applications

These are additional applications to consider separately. They are not installed by the setup script.

| Purpose | Application |
| --- | --- |
| Video editor | Kdenlive |
| Audio editor | Audacity |
| Media player | mpv |
| Browser | Midori |
| PCB designer | KiCad |
| Image editor | GIMP |
| 3D designer | FreeCAD |
| Android screen mirroring | scrcpy |
| Video downloader | yt-dlp |
| EPUB editor | Sigil |
| Screen recorder | Kazam |

## Programming

- Android Studio and Flutter
- STM32CubeIDE
- Arduino IDE
