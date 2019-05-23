#!/usr/bin/python -v

import i3ipc
import sys
#import power

#Defining Segments

left_segment_thick = "\uE0B0"
right_segment_thick = "\uE0B2"

left_segment_light = "\uE0b1"
right_segment_light = "\uE0b3"


panel_left_init = "%{l}"
panel_left_output = ""

panel_right_init = "%{r}"
panel_right_output = ""

# Begin Script

workspaces = ""
mode = "default"
focused = ""

i3 = i3ipc.Connection()

# i3 workspaces

def i3_workspace_output():
    workspaces = i3.get_workspaces()
    workspace_length = len(workspaces)
    output = "%{F-}"
    for i in range(workspace_length):
        w = workspaces[i]
        last_workspace = i == workspace_length - 1
        if w['focused']:
            output = output + "%{B#00ffee}%{F#101010} " + w['name']
            if last_workspace:
                output = output + " %{F#00ffee}"
            else:
                output = output + " %{B#000000}%{F#00ffee}" + left_segment_thick + "%{F-}"

        else:
            output = output + "%{B#000000} " + w['name']
            next_w = workspaces[i+1] if i < workspace_length-1 else workspaces[i]
            if next_w['focused']:

                output = output + " %{B#00ffee}%{F#000000}" + left_segment_thick + "%{F-}"
            elif last_workspace:
                output = output + " %{F#000000}"
            else:
                output = output + " " + left_segment_light

    return output



def i3_active_window():
    focused = i3.get_tree().find_focused()
    if focused:
        return " Focused Client: " + focused.name
    else:
        return ""

def on_window_focused(i3,event):
    global focused
    focused = i3_active_window()
    print_string()


def on_mode_change(i3,event):
    global mode
    mode = event.change
    print_string()

def on_workspace_focused(i3,event):
    print(event.current)

def print_string():
    print (mode , workspaces , focused)
    sys.stdout.flush()

def init():
    global workspaces
    global focused
    workspaces = i3_workspace_output()
    focused = i3_active_window()
    print_string()

init()

i3.on("mode", on_mode_change)
i3.on("workspace::focus", on_workspace_focused)
i3.on("window::focus", on_window_focused)
i3.main()
