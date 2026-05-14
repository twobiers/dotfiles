# Adapted from ghostty: https://github.com/ghostty-org/ghostty/blob/main/dist/linux/ghostty_nautilus.py
from gi.repository import Nautilus, GObject, Gio

def open_in_kitty(_, paths):
    for path in paths:
        Gio.Subprocess.new(['kitty', f'--directory={path}'], Gio.SubprocessFlags.NONE)

def get_paths(files):
    paths = []
    for file in files:
        location = file.get_location() if file.is_directory() else file.get_parent_location()
        path = location.get_path()
        if path and path not in paths:
            paths.append(path)
    return paths if len(paths) <= 10 else []

def make_items(name, files):
    paths = get_paths(files)
    if paths:
        item = Nautilus.MenuItem(name=name, label='Open in kitty')
        item.connect('activate', open_in_kitty, paths)
        return [item]
    return []

class KittyMenuProvider(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(self, files):
        return make_items('KittyNautilus::open_in_kitty', files)

    def get_background_items(self, file):
        return make_items('KittyNautilus::open_folder_in_kitty', [file])
