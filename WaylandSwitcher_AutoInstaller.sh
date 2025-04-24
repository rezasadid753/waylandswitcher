#!/bin/bash

# Get user's home directory
USER_HOME="$HOME"
USER_NAME=$(whoami)

# Uninstall logic
if [[ "$1" == "--uninstall" ]]; then
    sudo echo "● Removing $USER_HOME/Wayland Switcher"
    sudo rm -rf "$USER_HOME/Wayland Switcher"
    echo "● Removing $USER_HOME/.local/share/applications/wayland_switcher.desktop"
    sudo rm -f "$USER_HOME/.local/share/applications/wayland_switcher.desktop"
    echo "● Wayland Switcher have been removed"
    echo "● Exiting"
    exit 0
fi

sudo echo '⨂ ATTENTION: In case you see an error, uninstall using "./WaylandSwitcher_AutoInstaller.sh --uninstall" and try installing again'

# Ask for install path
read -rp "○ Where do you want to save wayland_switcher.sh? [Default: $USER_HOME]: " install_path
install_path=${install_path:-$USER_HOME}

# Set up directories
SWITCHER_DIR="$install_path/Wayland Switcher"
ICONS_DIR="$SWITCHER_DIR/icons"
echo "● Creating $ICONS_DIR directory"
sudo mkdir -p "$ICONS_DIR"

# Paths
SCRIPT_PATH="$SWITCHER_DIR/wayland_switcher.sh"
DESKTOP_FILE="$USER_HOME/.local/share/applications/wayland_switcher.desktop"
ICON_ON="$ICONS_DIR/wayland_on.svg"
ICON_OFF="$ICONS_DIR/wayland_off.svg"
SESSION_FILE="/etc/gdm3/custom.conf"
ACCOUNT_FILE="/var/lib/AccountsService/users/$USER_NAME"

echo "● Creating $ICON_ON"
sudo touch $ICON_ON
sudo tee "$ICON_ON" > /dev/null <<EOL
<svg width="500" height="500" viewBox="0 0 500 500" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 130C0 58.203 58.203 0 130 0H370C441.797 0 500 58.203 500 130V289H0V130Z" fill="#007D51"/>
<path d="M101 222L255 68M240 228L288 180M99 68L99 222M400 228V180M328 68L168 228M400 180V148V80.0711C400 75.6165 394.614 73.3857 391.464 76.5355L320 148L288 180M400 180H288" stroke="white" stroke-width="30" stroke-linecap="round"/>
<path d="M0 289H500V370C500 441.797 441.797 500 370 500H130C58.203 500 0 441.797 0 370V289Z" fill="#383838"/>
<path d="M242.358 392.166V396.95C242.358 404.623 241.318 411.511 239.238 417.612C237.158 423.714 234.223 428.914 230.433 433.213C226.642 437.465 222.112 440.724 216.843 442.989C211.619 445.254 205.818 446.387 199.439 446.387C193.107 446.387 187.306 445.254 182.036 442.989C176.813 440.724 172.283 437.465 168.446 433.213C164.61 428.914 161.628 423.714 159.502 417.612C157.422 411.511 156.382 404.623 156.382 396.95V392.166C156.382 384.447 157.422 377.559 159.502 371.504C161.582 365.402 164.517 360.202 168.308 355.903C172.144 351.604 176.674 348.323 181.897 346.058C187.167 343.793 192.968 342.66 199.301 342.66C205.68 342.66 211.481 343.793 216.704 346.058C221.974 348.323 226.504 351.604 230.294 355.903C234.131 360.202 237.089 365.402 239.169 371.504C241.295 377.559 242.358 384.447 242.358 392.166ZM221.35 396.95V392.027C221.35 386.665 220.864 381.951 219.894 377.883C218.923 373.815 217.49 370.395 215.595 367.621C213.7 364.848 211.388 362.768 208.661 361.381C205.934 359.948 202.814 359.231 199.301 359.231C195.788 359.231 192.668 359.948 189.94 361.381C187.259 362.768 184.971 364.848 183.076 367.621C181.227 370.395 179.817 373.815 178.847 377.883C177.876 381.951 177.391 386.665 177.391 392.027V396.95C177.391 402.266 177.876 406.981 178.847 411.095C179.817 415.162 181.25 418.606 183.146 421.426C185.041 424.199 187.352 426.302 190.079 427.735C192.806 429.168 195.926 429.885 199.439 429.885C202.952 429.885 206.073 429.168 208.8 427.735C211.527 426.302 213.815 424.199 215.664 421.426C217.513 418.606 218.923 415.162 219.894 411.095C220.864 406.981 221.35 402.266 221.35 396.95ZM339.498 344.047V445H318.697L278.136 377.328V445H257.335V344.047H278.136L318.767 411.788V344.047H339.498Z" fill="white"/>
</svg>
EOL


echo "● Creating $ICON_OFF"
sudo touch $ICON_OFF
sudo tee "$ICON_OFF" > /dev/null <<EOL
<svg width="500" height="500" viewBox="0 0 500 500" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 130C0 58.203 58.203 0 130 0H370C441.797 0 500 58.203 500 130V289H0V130Z" fill="#BB0707"/>
<path d="M101 222L255 68M240 228L288 180M99 68L99 222M400 228V180M328 68L168 228M400 180V148V80.0711C400 75.6165 394.614 73.3857 391.464 76.5355L320 148L288 180M400 180H288" stroke="white" stroke-width="30" stroke-linecap="round"/>
<path d="M0 289H500V370C500 441.797 441.797 500 370 500H130C58.203 500 0 441.797 0 370V289Z" fill="#383838"/>
<path d="M214.555 392.166V396.95C214.555 404.623 213.515 411.511 211.435 417.612C209.354 423.714 206.419 428.914 202.629 433.213C198.839 437.465 194.309 440.724 189.039 442.989C183.816 445.254 178.015 446.387 171.636 446.387C165.303 446.387 159.502 445.254 154.232 442.989C149.009 440.724 144.479 437.465 140.643 433.213C136.806 428.914 133.825 423.714 131.698 417.612C129.618 411.511 128.578 404.623 128.578 396.95V392.166C128.578 384.447 129.618 377.559 131.698 371.504C133.778 365.402 136.714 360.202 140.504 355.903C144.34 351.604 148.87 348.323 154.094 346.058C159.363 343.793 165.164 342.66 171.497 342.66C177.876 342.66 183.677 343.793 188.9 346.058C194.17 348.323 198.7 351.604 202.49 355.903C206.327 360.202 209.285 365.402 211.365 371.504C213.492 377.559 214.555 384.447 214.555 392.166ZM193.546 396.95V392.027C193.546 386.665 193.061 381.951 192.09 377.883C191.119 373.815 189.686 370.395 187.791 367.621C185.896 364.848 183.585 362.768 180.857 361.381C178.13 359.948 175.01 359.231 171.497 359.231C167.984 359.231 164.864 359.948 162.137 361.381C159.456 362.768 157.168 364.848 155.272 367.621C153.424 370.395 152.014 373.815 151.043 377.883C150.072 381.951 149.587 386.665 149.587 392.027V396.95C149.587 402.266 150.072 406.981 151.043 411.095C152.014 415.162 153.447 418.606 155.342 421.426C157.237 424.199 159.548 426.302 162.275 427.735C165.003 429.168 168.123 429.885 171.636 429.885C175.149 429.885 178.269 429.168 180.996 427.735C183.723 426.302 186.011 424.199 187.86 421.426C189.709 418.606 191.119 415.162 192.09 411.095C193.061 406.981 193.546 402.266 193.546 396.95ZM250.332 344.047V445H229.531V344.047H250.332ZM290.547 387.174V403.398H244.646V387.174H290.547ZM295.4 344.047V360.341H244.646V344.047H295.4ZM328.266 344.047V445H307.465V344.047H328.266ZM368.48 387.174V403.398H322.58V387.174H368.48ZM373.334 344.047V360.341H322.58V344.047H373.334Z" fill="white"/>
</svg>
EOL


# Create wayland_switcher.sh
echo "● Creating $SCRIPT_PATH"
sudo touch $SCRIPT_PATH
sudo tee "$SCRIPT_PATH" > /dev/null <<EOL
#!/bin/bash

# Constants
DESKTOP_FILE="$DESKTOP_FILE"
ICON_ON="$ICON_ON"
ICON_OFF="$ICON_OFF"
SESSION_FILE="/etc/gdm3/custom.conf"
ACCOUNT_FILE="/var/lib/AccountsService/users/$USER_NAME"

# Function to toggle Wayland globally
toggle_wayland() {
    if [ "\$1" == "wayland" ]; then
        sudo sed -i '/^#*WaylandEnable=/d' "\$SESSION_FILE"
        echo "WaylandEnable=true" | sudo tee -a "\$SESSION_FILE" > /dev/null
    else
        sudo sed -i 's/^WaylandEnable=.*/WaylandEnable=false/' "\$SESSION_FILE" || echo "WaylandEnable=false" | sudo tee -a "\$SESSION_FILE" > /dev/null
    fi
}

# Function to update the desktop file's icon
update_icon() {
    local icon=\$( [ "\$1" == "wayland" ] && echo "\$ICON_ON" || echo "\$ICON_OFF" )
    sed -i "s|^Icon=.*|Icon=\$icon|" "\$DESKTOP_FILE"
}

# Get current session from file
current_session=\$(grep "^Session=" "\$ACCOUNT_FILE" | cut -d'=' -f2)
current_session=\$([[ "\$current_session" == "ubuntu-wayland" ]] && echo "wayland" || echo "xorg")

# Determine target session
TARGET=\$([[ "\$current_session" == "wayland" ]] && echo "xorg" || echo "wayland")

# Print session info and ask for confirmation
echo -e "\\nCurrent session: \\e[1m\$current_session\\e[0m"
echo -e "Target session:  \\e[1m\$TARGET\\e[0m"
read -rp \$'\\nDo you want to switch? [Y/n]: ' confirm

if [[ "\${confirm,,}" != "y" ]]; then
    echo "Aborted."
    exit 0
fi

# Apply session change
echo -e "\\nApplying changes..."

if [ "\$TARGET" == "xorg" ]; then
    sudo sed -i 's/^Session=.*/Session=ubuntu-xorg/' "\$ACCOUNT_FILE"
else
    sudo sed -i 's/^Session=.*/Session=ubuntu-wayland/' "\$ACCOUNT_FILE"
fi

toggle_wayland "\$TARGET"
update_icon "\$TARGET"

echo -e "\\n\\e[32mRebooting to apply changes...\\e[0m"
sleep 2
systemctl reboot
EOL

sudo chmod +x "$SCRIPT_PATH"

# Create desktop file
echo "● Creating $DESKTOP_FILE"
sudo touch $DESKTOP_FILE
sudo tee "$DESKTOP_FILE" > /dev/null <<EOL
[Desktop Entry]
Name=Wayland Switcher
Comment=Toggle between Wayland and Xorg session
Exec=gnome-terminal -- bash -c "sudo '$SCRIPT_PATH'"
Icon=$ICON_OFF
Terminal=true
Type=Application
EOL

echo "● Installation completed"
echo "⨂ ATTENTION: You can now use Wayland Switcher using the application menu"

