#!/usr/bin/env python3

import i3ipc

i3 = i3ipc.Connection()

def set_borders(container):
    if container.border == "pixel":
        container.command("border normal")
    else:
        container.command("border pixel 1")

container = i3.get_tree().find_focused()
set_borders(container)
