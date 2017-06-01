#!/usr/bin/env python

import psutil


right_segment_light = "\uE0b3"

def cpu():
    cpu_usage = psutil.cpu_percent(interval = 0.5,percpu = False)
#    cpu_count = len(cpu_usage)
#    output = ""
#    for ci in range(cpu_count):
#        output = output + " Core" + str(ci) + ": " + str(cpu_usage[ci]) + "% "
#        if ci < cpu_count - 1:
#            output += right_segment_light
#
    return (" CPU: %s%%" % cpu_usage)

print(cpu())
