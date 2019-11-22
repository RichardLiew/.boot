# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "String Painting Util For Makefile" version 1.0
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
#   String painting util for makefile.
#
###############################################################################

ifndef __PAINTING__
define __PAINTING__
endef

###############################################################################

override COLOR_COUNTS ?= 256

###############################################################################


override ESC  ?= \033
override BEEP ?= \007

###############################################################################

override BOLD                ?= 01
override HALF_LIGHT          ?= 02
override ITALIC              ?= 03
override UNDERLINE           ?= 04
override CLOSE_UNDERLINE     ?= 24
override BLINK               ?= 05
override CLOSE_BLINK         ?= 25
override REVERSE_VIDEO       ?= 07
override CLOSE_REVERSE_VIDEO ?= 27
override COMMON_DENSITY      ?= 22
override BLACK_OUT           ?= 8

###############################################################################

override END                              ?= $(ESC)[0m
override CLOSE_ALL_COLORS_KEYBOARD_LIGHTS ?= $(ESC)[0q
override CLEAR_SCREEN                     ?= $(ESC)[2J
override SET_SCROLL_LOCK_LIGHT            ?= $(ESC)[1q
override SET_NUM_LOCK_LIGHT               ?= $(ESC)[2q
override SET_CAPS_LOCK_LIGHT              ?= $(ESC)[3q

###############################################################################

override CLEAR_CURSOR_TO_LINE_END ?= $(ESC)[K
override SAVE_CURSOR_POSITION     ?= $(ESC)[s
override RECOVER_CURSOR_POSITION  ?= $(ESC)[u
override HIDE_CURSOR              ?= $(ESC)[?25l
override SHOW_CURSOR              ?= $(ESC)[?25h

###############################################################################

override FG         ?= 38;5
override BG         ?= 48;5

override FG_GREY    ?= 30
override FG_RED     ?= 31
override FG_GREEN   ?= 32
override FG_YELLOW  ?= 33
override FG_BLUE    ?= 34
override FG_VIOLET  ?= 35
override FG_SKYBLUE ?= 36
override FG_WHITE   ?= 37

override BG_BLACK   ?= 40
override BG_RED     ?= 41
override BG_GREEN   ?= 42
override BG_YELLOW  ?= 43
override BG_BLUE    ?= 44
override BG_VIOLET  ?= 45
override BG_SKYBLUE ?= 46
override BG_WHITE   ?= 47

###############################################################################

override SET_CURSOR_POSITION ?= function SET_CURSOR_POSITION() { \
	local -r x="$${1}"; \
	local -r y="$${2}"; \
	echo "$(ESC)[$${y};$${x}H"; \
}; SET_CURSOR_POSITION

override CURSOR_UP ?= function CURSOR_UP() { \
	local -r n="$${1}"; \
	echo "$(ESC)[$${n}A"; \
}; CURSOR_UP

override CURSOR_DOWN ?= function CURSOR_DOWN() { \
	local -r n="$${1}"; \
	echo "$(ESC)[$${n}B"; \
}; CURSOR_DOWN

override CURSOR_LEFT ?= function CURSOR_LEFT() { \
	local -r n="$${1}"; \
	echo "$(ESC)[$${n}D"; \
}; CURSOR_LEFT

override CURSOR_RIGHT ?= function CURSOR_RIGHT() { \
	local -r n="$${1}"; \
	echo "$(ESC)[$${n}C"; \
}; CURSOR_RIGHT

###############################################################################

override FORMAT_FC ?= function FORMAT_FC() { \
	local -r fc="$${1}"; \
	if [ -z "$${fc}" ]; then \
		echo ""; \
	else \
		echo "$(ESC)[$(FG);$${fc}m"; \
	fi; \
}; FORMAT_FC

override PAINT_FC ?= function PAINT_FC() { \
	local -r fc="$${1}"; \
	local -r text="$${2}"; \
	echo "$$($(FORMAT_FC) "$${fc}")$${text}$(END)"; \
}; PAINT_FC

override FORMAT_BC ?= function FORMAT_BC() { \
	local -r bc="$${1}"; \
	if [ -z "$${bc}" ]; then \
		echo ""; \
	else \
		echo "$(ESC)[$(BG);$${bc}m"; \
	fi; \
}; FORMAT_BC

override PAINT_BC ?= function PAINT_BC() { \
	local -r bc="$${1}"; \
	local -r text="$${2}"; \
	echo "$$($(FORMAT_BC) "$${bc}")$${text}$(END)"; \
}; PAINT_BC

override FORMAT_COLOR ?= function FORMAT_COLOR() { \
	local -r fc="$${1}"; \
	local -r bc="$${2}"; \
	echo "$$($(FORMAT_FC) "$${fc}")$$($(FORMAT_BC) "$${bc}")"; \
}; FORMAT_COLOR

override PAINT ?= function PAINT() { \
	local -r fc="$${1}"; \
	local -r bc="$${2}"; \
	local -r text="$${3}"; \
	echo "$$($(FORMAT_COLOR) "$${fc}" "$${bc}")$${text}$(END)"; \
}; PAINT

###############################################################################

override PLAIN_PRINT ?= function PLAIN_PRINT() { \
	local -r text="$${1}"; \
	echo "$${text}"; \
}; PLAIN_PRINT

override COLOR_PRINT ?= function COLOR_PRINT() { \
	local -r text="$${1}"; \
	echo "$${text}"; \
}; COLOR_PRINT

###############################################################################

override PAINT_TEXT ?= function PAINT_TEXT() { \
	local -r colors="$${1}"; \
	local -r text="$${2}"; \
	\
	echo "$$( \
		$(PAINT) $${colors%%:*} $${colors\#\#*:} "$${text}" \
	)"; \
}; PAINT_TEXT

override PAINT_LABEL ?= function PAINT_LABEL() { \
	local -r colors="$${1}"; \
	local -r label="$${2}"; \
	\
	echo "$$( \
		$(PAINT) $${colors%%:*} $${colors\#\#*:} "[$${label}]" \
	)"; \
}; PAINT_LABEL

override PAINT_TIMESTAMP ?= function PAINT_TIMESTAMP() { \
	local colors="$${1}"; \
	local timestamp="$${2}"; \
	\
	[ -z "$${colors}" ] && colors="0:226"; \
	[ -z "$${timestamp}" ] && timestamp="$$(date +\"%Y-%m-%d %H:%M:%S %Z\")"; \
	\
	echo "$$( \
		$(PAINT_TEXT) "$${colors}" "[$${timestamp}]" \
	)"; \
}; PAINT_TIMESTAMP

override PAINT_TEXT_WITH_LABEL ?= function PAINT_TEXT_WITH_LABEL() { \
	local colors="$${1}"; \
	local -r label="$${2}"; \
	local -r text="$${3}"; \
	\
	[[ "$${colors}" != *"|"* ]] && colors="|$${colors}"; \
	\
	local -r timestamp_colors="$${colors%%|*}"; \
	local -r lt_colors="$${colors\#\#*|}"; \
	\
	local -r label_color="$${lt_colors%%-*}"; \
	local -r text_color="$${lt_colors\#\#*-}"; \
	\
	local result="$$( \
		$(PAINT_LABEL) "$${label_color}" "$${label}" \
	)"; \
	result="$${result}$$( \
		$(PAINT_TEXT) "$${text_color}" "$${text}" \
	)"; \
	\
	if [ -n "$${timestamp_colors}" ]; then \
		result="$$($(PAINT_TIMESTAMP) "$${timestamp_colors}")$${result}"; \
	fi; \
	\
	echo "$${result}"; \
}; PAINT_TEXT_WITH_LABEL

###############################################################################

endif
