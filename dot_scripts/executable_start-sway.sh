#!/usr/bin/env sh

if [ -e ~/.profile ]
then
    source ~/.profile
fi

export QT_QPA_PLATFORM=wayland
# export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export CLUTTER_BACKEND=wayland
export BEMENU_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

export WLR_NO_HARDWARE_CURSORS=1
export WLR_RENDERER=vulkan
export XWAYLAND_NO_GLAMOR=1

exec /usr/bin/sway --unsupported-gpu
