def add_time_segment(powerline):
    if powerline.args.shell == 'bash':
        time = ' \\t \\d '
    elif powerline.args.shell == 'zsh':
        time = ' %* '
    else:
        import time
        time = ' %s ' % time.strftime('%H:%M:%S')

    powerline.append(time, Color.TIME_FG, Color.TIME_BG)
