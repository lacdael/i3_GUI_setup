#!/bin/bash
set -Eeuo pipefail

trap 'printf "Installation failed at line %s (exit status %s).\n" "$LINENO" "$?" >&2' ERR

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

[[ $EUID -eq 0 ]] || fail 'Run this script as root (for example, with sudo).'
[[ $# -le 1 ]] || fail "Usage: $0 [username]"

for command in apt-get getent id usermod; do
    command -v "$command" >/dev/null || fail "Required command not found: $command"
done

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
for file in .xinitrc .profile .Xresources .vimrc .rsync-homedir-excludes.txt; do
    [[ -f "$DIR/$file" && -r "$DIR/$file" ]] || fail "Missing or unreadable source: $DIR/$file"
done
for directory in Pictures .config; do
    [[ -d "$DIR/$directory" ]] || fail "Missing source directory: $DIR/$directory"
done

name="${1:-${SUDO_USER:-}}"
if [[ -z "$name" || "$name" == root ]]; then
    read -r -p 'Enter the username to configure: ' name || fail 'No username supplied.'
fi
[[ -n "$name" && "$name" != -* && "$name" != *:* ]] || fail 'Invalid username.'
account="$(getent passwd "$name")" || fail "User does not exist: $name"
IFS=: read -r account_name _ account_uid _ _ user_home _ <<< "$account"
[[ "$account_name" == "$name" && "$account_uid" != 0 ]] || fail 'Select an existing non-root user.'
[[ "$user_home" == /* && "$user_home" != / && -d "$user_home" ]] || fail "Invalid or missing home directory: $user_home"

# Install everything in one transaction; stop before copying files if apt fails.
packages=(
    x-window-system sudo i3 i3blocks ranger feh flameshot compton rofi
    udiskie clipit smbclient cifs-utils vim-gtk
    brightnessctl pamixer xsel xterm w3m network-manager dbus x11-xserver-utils
)
apt-get update
apt-get install -y "${packages[@]}"

getent group sudo >/dev/null || fail 'The sudo group does not exist.'
usermod -a -G sudo "$name"

# Run file operations as the target user so new files have the correct owner.
# Merge directories and retain numbered backups of any overwritten files.
sudo -u "$name" test -w "$user_home" || fail "Home directory is not writable by $name: $user_home"
sudo -u "$name" mkdir -p -- "$user_home/Documents" "$user_home/Pictures" "$user_home/.config"
for file in .xinitrc .profile .Xresources .vimrc .rsync-homedir-excludes.txt; do
    sudo -u "$name" cp --backup=numbered -- "$DIR/$file" "$user_home/$file"
done
sudo -u "$name" chmod u+x -- "$user_home/.xinitrc"
for directory in Pictures .config; do
    sudo -u "$name" cp -R --backup=numbered -- "$DIR/$directory/." "$user_home/$directory/"
done

printf 'Setup complete for %s. Existing files were backed up with numbered suffixes.\n' "$name"
printf 'Log out and log back in to apply the changes.\n'
