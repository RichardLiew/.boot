class DefaultColor:
    """
    This class should have the default colors for every segment.
    Please test every new segment with this theme first.
    """
    # RESET is not a real color code. It is used as in indicator
    # within the code that any foreground / background color should
    # be cleared
    RESET = -1

    USERNAME_BG = 31
    USERNAME_FG = 87
    USERNAME_ROOT_BG = 124

    HOSTNAME_BG = 90
    HOSTNAME_FG = 15

    HOME_SPECIAL_DISPLAY = True
    HOME_BG = 31  # blueish
    HOME_FG = 192  # white
    PATH_BG = 58  # dark grey
    PATH_FG = 214  # light grey
    CWD_FG = 82  # nearly-white grey
    SEPARATOR_FG = 192

    READONLY_BG = 124
    READONLY_FG = 254

    SSH_BG = 166 # medium orange
    SSH_FG = 254

    REPO_CLEAN_BG = 148  # a light green color
    REPO_CLEAN_FG = 0  # black
    REPO_DIRTY_BG = 161  # pink/red
    REPO_DIRTY_FG = 15  # white

    JOBS_FG = 39
    JOBS_BG = 238

    CMD_PASSED_BG = 236
    CMD_PASSED_FG = 15

    CMD_FAILED_BG = 1
    CMD_FAILED_FG = 46

    ROOT_CHAR_BG = 239
    ROOT_CHAR_FG = 255

    TIME_BG = 226
    TIME_FG = 20

    SVN_CHANGES_BG = 148
    SVN_CHANGES_FG = 22  # dark green

    GIT_AHEAD_BG = 56
    GIT_AHEAD_FG = 250
    GIT_BEHIND_BG = 240
    GIT_BEHIND_FG = 225
    GIT_STAGED_BG = 22
    GIT_STAGED_FG = 227
    GIT_NOTSTAGED_BG = 130
    GIT_NOTSTAGED_FG = 154
    GIT_UNTRACKED_BG = 52
    GIT_UNTRACKED_FG = 14
    GIT_CONFLICTED_BG = 9
    GIT_CONFLICTED_FG = 194

    VIRTUAL_ENV_BG = 35  # a mid-tone green
    VIRTUAL_ENV_FG = 00

class Color(DefaultColor):
    """
    This subclass is required when the user chooses to use 'default' theme.
    Because the segments require a 'Color' class for every theme.
    """
    pass
