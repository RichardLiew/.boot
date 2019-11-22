#!/usr/bin/env python
# -*- coding: utf-8 -*-

##################################################################
#
# Print Xterm-256-Color chart.
#
##################################################################


def get_colors():
    colors = ''
    for i in range(0, 256):
        whitespace_counts = 6
        if 10 <= i < 100:
            whitespace_counts -= 1
        elif i >= 100:
            whitespace_counts -= 2
        colors += '\\033[48;5;{}m{}{}{}\\033[0m\\n'.format(
            i, i, ' ' * whitespace_counts, 'EXAMPLE'
        )
    return colors


if __name__ == "__main__":
    import os
    os.system('echo "{}"'.format(get_colors()))
