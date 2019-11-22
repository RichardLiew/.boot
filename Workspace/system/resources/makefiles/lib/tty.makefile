# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "TTY Util For Makefile" version 1.0
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#    * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#    * Neither the name of Ayoume Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES_; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ---
# Author:  Zichoole
# Created: 2019-03-07 10:46:00
# E-mail:  zichoole@gmail.com
#
# ---
# Description:
#   TTY util for makefile.
#
###############################################################################

ifndef __TTY__
define __TTY__
endef

###############################################################################

override TTY_LINES                        ?= $(shell tput lines)
override TTY_COLUMNS                      ?= $(shell tput cols)
override TTY_RESET_COLOR                  ?= $(shell tput sgr0)

override TTY_BOLD_MODE                    ?= tput bold
override TTY_BLINK_MODE                   ?= tput blink
override TTY_DIM_MODE                     ?= tput dim
override TTY_ENABLE_UNDERLINE_MODE        ?= tput smul
override TTY_DISABLE_UNDERLINE_MODE       ?= tput rmul
override TTY_ENABLE_REVERSE_VIDEO_MODE    ?= tput rev
override TTY_ENTER_STD_MODE               ?= tput smso
override TTY_EXIT_STD_MODE                ?= tput rmso

override TTY_SET_ANSI_FOREGROUND_COLOR    ?= tput setaf
override TTY_SET_ANSI_BACKGROUND_COLOR    ?= tput setab
override TTY_SET_NONANSI_FOREGROUND_COLOR ?= tput setf
override TTY_SET_NONANSI_BACKGROUND_COLOR ?= tput setb

override TTY_SAVE_CURSOR                  ?= tput sc
override TTY_RESTORE_CURSOR               ?= tput rc
override TTY_DISABLE_CURSOR               ?= tput civis
override TTY_ENABLE_CURSOR                ?= tput cnorm

override TTY_SCROLL_AREA                  ?= tput csr

override TTY_MOVE_TO                      ?= tput cup
override TTY_MOVE_UP                      ?= tput cuu
override TTY_MOVE_FORWARD                 ?= tput cuf
override TTY_MOVE_BACK                    ?= tput cub
override TTY_MOVE_TO_LASTLINE             ?= tput ll

override TTY_BELL                         ?= tput bel

override TTY_ERASE                        ?= tput ech
override TTY_CLEAR_TO_LINE                ?= tput el
override TTY_CLEAR_TO_SCREEN_END          ?= tput ed
override TTY_INSERT_CHARACTERS            ?= tput ich
override TTY_INSERT_LINES                 ?= tput il

override TTY_FLUSH                        ?= $(TTY_CLEAR_TO_SCREEN_END)
override TTY_CLEAR                        ?= tput clear

###############################################################################

override STTY_SIZE                        ?= stty size
override STTY_SPEED                       ?= $(shell stty speed)

override STTY_ROWS                        ?= stty rows
override STTY_COLUMNS                     ?= stty cols
override STTY_LINE                        ?= stty line

override STTY_SET_INPUT_SPEED             ?= stty ispeed
override STTY_SET_OUTPUT_SPEED            ?= stty ospeed

###############################################################################

endif
