# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Progressbar Util For Makefile" version 1.0
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
#   Progressbar util for makefile.
#
###############################################################################

ifndef __PROGRESSBAR__
define __PROGRESSBAR__
endef

###############################################################################

include $(MKFLIB)/tty.makefile
include $(MKFLIB)/core.makefile
include $(MKFLIB)/math.makefile
include $(MKFLIB)/painting.makefile
include $(MKFLIB)/logging.makefile

###############################################################################

override PROGRESSBAR_SWITCH              ?= $(ON)

override PROGRESSBAR_INTERVAL            ?= -1
override PROGRESSBAR_REPORTING_STEPS     ?= 1
override PROGRESSBAR_REPORTING_INTERVAL  ?= 1s
override PROGRESSBAR_STATUS_LINE_PADDING ?= 0
override PROGRESSBAR_FLUSH_INTERVAL      ?= 0s

override PROGRESSBAR_FOREGROUND_COLOR    ?= $(shell \
	$(TTY_SET_ANSI_FOREGROUND_COLOR) 0 \
)
override PROGRESSBAR_BACKGROUND_COLOR    ?= $(shell \
	$(TTY_SET_ANSI_BACKGROUND_COLOR) 3 \
)

###############################################################################

override PROGRESSBAR_COLORS ?= 87 86 85 84 83 82

###############################################################################

override PROGRESSBAR_LEFT_BRACKET ?= $(shell \
	$(PAINT_TEXT) "0:$(firstword $(PROGRESSBAR_COLORS))" "▉" \
)
override PROGRESSBAR_RIGHT_BRACKET ?= $(shell \
	$(PAINT_TEXT) "$(lastword $(PROGRESSBAR_COLORS)):0" "▏" \
)

###############################################################################

override PROGRESSBAR_FILL ?= function PROGRESSBAR_FILL() { \
	local -r color="$${1}"; \
	$(PAINT_TEXT) "$${color}:0" "▉"; \
}; PROGRESSBAR_FILL

override PROGRESSBAR_REMAIN ?= function PROGRESSBAR_REMAIN() { \
	local -r color="$${1}"; \
	$(PAINT_TEXT) "$${color}:0" "─"; \
}; PROGRESSBAR_REMAIN

###############################################################################

override EXECUTE ?= function EXECUTE() { \
	set -a; \
	export LC_ALL=C; \
	\
	local -i start_invoked="-1"; \
	local -i stop_invoked="-1"; \
	local -i tty_height="0"; \
	local -i tty_width="0"; \
	local -i last_reported_progress="-1"; \
	\
	local progress_string=""; \
	local percentage="0.0"; \
	\
	function tty_set_size() { \
		set -- $$($(STTY_SIZE)); \
		tty_height="$${1}"; \
		tty_width="$${2}"; \
	}; \
	\
	function tty_change_scroll_area() { \
		local -i row_counts="$${1}"; \
		if (( row_counts > 1 )); then \
			(( row_counts-=2 )); \
			\
			echo; \
			$(TTY_SAVE_CURSOR); \
			$(TTY_SCROLL_AREA) "0" "$${row_counts}"; \
			$(TTY_RESTORE_CURSOR); \
			$(TTY_MOVE_UP) "2"; \
			echo; \
			\
			(( ++row_counts )); \
			\
			trap - WINCH; \
			$(STTY_ROWS) "$${row_counts}"; \
			trap tty_handle_sigwinch WINCH; \
		fi; \
	}; \
	\
	function tty_generate_progress_string() { \
		local -r percent="$${1}"; \
		local -i size="$${2}"; \
		\
		if (( size < 3 )); then \
			echo; \
		else \
			local -i bar_size="$$(( size-2 ))"; \
			local -i bar_done="$$( \
				$(MATH_MAX) 0 "$$( \
					$(MATH_MIN) "$${bar_size}" "$$( \
						$(MATH_FLOOR) "$$( \
							$(MATH_CALCULATE) "$${percent}*$${bar_size}" \
						)" \
					)" \
				)" \
			)"; \
			\
			function calculate_color() { \
				local -ir curr="$${1}"; \
				local -ir size="$${2}"; \
				\
				local -ir counts="$(words $(PROGRESSBAR_COLORS))"; \
				local -i index="$$($(MATH_FLOOR) \
					"$${curr}/$${size}*$${counts}" \
				)"; \
				[ "$${index}" -le "0" ] && index="1"; \
				[ "$${index}" -gt "$${counts}" ] && index="$${counts}"; \
				echo "$(PROGRESSBAR_COLORS)" | awk "{print \$$"$${index}"}"; \
			}; \
			\
			local result="$(PROGRESSBAR_LEFT_BRACKET)"; \
			for (( i=0; i<bar_done; i++ )); do \
				result+="$$($(PROGRESSBAR_FILL) \
					"$$(calculate_color "$${i}" "$${bar_size}")" \
				)"; \
			done; \
			\
			for (( i=bar_done; i<bar_size; i++ )); do \
				result+="$$($(PROGRESSBAR_REMAIN) \
					"$$(calculate_color "$${i}" "$${bar_size}")" \
				)"; \
			done; \
			\
			result+="$(PROGRESSBAR_RIGHT_BRACKET)"; \
			\
			echo "$${result}"; \
		fi; \
	}; \
	\
	function tty_draw_status_line() { \
		tty_set_size; \
		if (( tty_height < 1 || tty_width < 1 )); then \
			return "$(FAIL)"; \
		fi; \
		\
		$(TTY_SAVE_CURSOR); \
		$(TTY_DISABLE_CURSOR); \
		$(TTY_MOVE_TO) "$${tty_height}" "0"; \
		\
		local -r header="$$(printf "%s%s%s%s" \
			"$(PROGRESSBAR_BACKGROUND_COLOR)" \
			"$(PROGRESSBAR_FOREGROUND_COLOR)" \
			"$${progress_string}" \
			"$(TTY_RESET_COLOR)" \
		)"; \
		\
		local -i progressbar_size="$$(( \
			tty_width-$(PROGRESSBAR_STATUS_LINE_PADDING)-$${\#progress_string} \
		))"; \
		local -r current_percent="$$($(MATH_CALCULATE) "$${percentage}/100.00")"; \
		\
		local -r bar="$$(tty_generate_progress_string \
			"$${current_percent}" \
			"$${progressbar_size}" \
		)"; \
		\
		printf "%s%s" "$${header}$${bar}"; \
		\
		$(TTY_RESTORE_CURSOR); \
		$(TTY_ENABLE_CURSOR); \
		\
		last_reported_progress="$$($(MATH_ROUND) "$${percentage}")"; \
		\
		return "$(SUCCESS)"; \
	}; \
	\
	function render_progressbar() { \
		local -r percentage_min="$${1}"; \
		local -r percentage_max="$${2}"; \
		\
		percentage="$${percentage_min}"; \
		\
		while true; do \
			if [ "$(PROGRESSBAR_INTERVAL)" -lt "0" ]; then \
				percentage="$${percentage_max}"; \
			else \
				percentage="$$($(MATH_CALCULATE) \
					"$${percentage}+$(PROGRESSBAR_INTERVAL)" \
				)"; \
			fi; \
			\
			if [ "$$(echo "$${percentage}>$${percentage_max}"|bc)" -eq "1" ]; then \
				percentage="$${percentage_max}"; \
			fi; \
			\
			local -i int_percentage="$$($(MATH_ROUND) "$${percentage}")"; \
			\
			printf -v progress_string "$@: [%3li%%]" "$${int_percentage}"; \
			\
			local -i reported="$$(( \
				last_reported_progress + \
				$(PROGRESSBAR_REPORTING_STEPS) - int_percentage \
			))"; \
			if (( reported > 1 )); then \
				break; \
			fi; \
			\
			tty_draw_status_line; \
			if [ "$$?" -ne "0" ]; then \
				break; \
			fi; \
			\
			sleep $(PROGRESSBAR_REPORTING_INTERVAL); \
			\
			if [ "$${percentage}" = "$${percentage_max}" ]; then \
				break; \
			fi; \
		done; \
	}; \
	\
	function bar_status_changed() { \
		if (( ! $${start_invoked:-0} )); then \
			exit "$(FAIL)"; \
		fi; \
		\
		local -ir steps_done="$${1}"; \
		local -ir total_steps="$${2}"; \
		\
		local -i done_min="$$(($${steps_done}-1))"; \
		[ "$${done_min}" -lt "0" ] && done_min="0"; \
		local -i done_max="$${steps_done}"; \
		[ "$${done_max}" -lt "0" ] && done_max="0"; \
		\
		local -r percentage_min="$$($(MATH_CALCULATE) \
			"$$($(MATH_CALCULATE) "$${done_min}/$${total_steps}")*100.00" \
		)"; \
		local -r percentage_max="$$($(MATH_CALCULATE) \
			"$$($(MATH_CALCULATE) "$${done_max}/$${total_steps}")*100.00" \
		)"; \
		\
		render_progressbar "$${percentage_min}" "$${percentage_max}"; \
		\
		sleep $(PROGRESSBAR_FLUSH_INTERVAL); \
	}; \
	\
	bar_start() { \
		start_invoked="-1"; \
		tty_set_size; \
		tty_change_scroll_area "$${tty_height}"; \
	}; \
	\
	bar_stop() { \
		stop_invoked="-1"; \
		if (( $${start_invoked:-0} )); then \
			start_invoked="0"; \
			tty_set_size; \
			if (( tty_height > 0 )); then \
				tty_change_scroll_area "$$((tty_height+2))"; \
				trap "printf \"\033[J\"" ERR; \
				$(TTY_FLUSH); \
				trap - ERR; \
				$(TTY_MOVE_UP) "1"; \
				echo; \
			fi; \
			trap - WINCH; \
		fi; \
	}; \
	\
	tty_handle_sigwinch() { \
		tty_set_size; \
		tty_change_scroll_area "$${tty_height}"; \
		tty_draw_status_line; \
	}; \
	\
	tty_handle_exit() { \
		(( ! $${stop_invoked:-0} )) && bar_stop; \
		trap - EXIT; \
	}; \
	\
	set +a; \
	\
	trap tty_handle_sigwinch WINCH; \
	trap tty_handle_exit EXIT INT HUP QUIT PIPE TERM; \
	\
	function show_bar() { \
		if [ "$(LOG_COLOR)" != "$(ON)" ]; then \
			echo "$(FALSE)"; \
		else \
			if [ "$(PROGRESSBAR_SWITCH)" != "$(ON)" ]; then \
				echo "$(FALSE)"; \
			else \
				echo "$(TRUE)"; \
			fi; \
		fi; \
	}; \
	\
	function main() { \
		local -a steps=("$$@"); \
		\
		if [ "$$(show_bar)" = "$(TRUE)" ]; then \
			bar_start; \
			local -i steps_done="0"; \
			bar_status_changed "$${steps_done}" "$${\#steps[@]}"; \
		fi; \
		for step in "$${steps[@]}"; do \
			eval "$${step}"; \
			if [ "$$(show_bar)" = "$(TRUE)" ]; then \
				steps_done="$$((steps_done+1))"; \
				bar_status_changed "$${steps_done}" "$${\#steps[@]}"; \
			fi; \
		done; \
		if [ "$$(show_bar)" = "$(TRUE)" ]; then \
			bar_stop; \
		fi; \
	}; \
	\
	main "$$@"; \
}; $(eval CURRENT_STEP := $(shell echo "$$(($(CURRENT_STEP)+1))")) EXECUTE

###############################################################################

endif
