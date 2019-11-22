# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Logging Utils For Makefile" version 1.0
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
#   Logging utils for makefile.
#
###############################################################################

ifndef __LOGGING__
define __LOGGING__
endef

###############################################################################

include $(MKFLIB)/core.makefile
include $(MKFLIB)/strings.makefile
include $(MKFLIB)/painting.makefile

###############################################################################
#
# Levels:
#   - DEBUG INFO WARN ERROR FATAL OFF
#
###############################################################################

LOG_LEVEL  ?= INFO
LOG_OUTPUT ?= /dev/stderr
LOG_FORMAT ?= "%Y-%m-%d %H:%M:%S.%N %Z"
LOG_COLOR  ?= $(ON)

###############################################################################
#
# Introduction:
#   - 0: progress
#   - 1: timestamp
#   - 2: level
#   - 3: emoji
#   - 4: target
#   - 5: dependencies
#   - 6: message
#
###############################################################################

LOG_FIELDS ?= 012346

###############################################################################
#
# Order:
#   - DEBUG
#   - INFO
#   - WARN
#   - ERROR
#   - FATAL
#   - START
#   - FINISH
#
# Format: progress|timestamp|level|target|dependencies|message
#   - progress
#       - front-color:back-color
#   - timestamp
#       - front-color:back-color
#   - level
#       - front-color:back-color
#   - target
#       - front-color:back-color
#   - dependencies
#       - front-color:back-color
#   - message
#       - front-color:back-color
#
###############################################################################

override LOG_COLOR_OPTIONS ?= \
	[0:2|226:0|0:255|255:0|255:0|255:0] \
	[0:2|226:0|255:12|12:0|12:0|12:0] \
	[0:2|226:0|255;$(BLINK);$(BEEP):130|130;$(BLINK);$(BEEP):0|130;$(BLINK);$(BEEP):0|130;$(BLINK);$(BEEP):0] \
	[0:2|226:0|255;$(BLINK);$(BEEP):1|1;$(BLINK);$(BEEP):0|1;$(BLINK);$(BEEP):0|1;$(BLINK);$(BEEP):0] \
	[0:2|226:0|255;$(BLINK);$(BEEP):93|93;$(BLINK);$(BEEP):0|93;$(BLINK);$(BEEP):0|93;$(BLINK);$(BEEP):0] \
	[0:2|226:0|0:2|2:0|2:0|2:0] \
	[0:2|226:0|0:2|2:0|2:0|2:0]

###############################################################################
#
# Introduction:
#   - DEBUG INFO WARN ERROR FATAL START FINISH
#
###############################################################################

override LOG_COLOR_EMOJIS ?= 🤔 😃 🤭 😭 😱 😊 😁

###############################################################################

override _LOG ?= function _LOG() { \
	local -r level="$${1}"; \
	local -r message="$${2}"; \
	\
	function translate_log_level() { \
		local -r level="$$(echo "$${1}" | tr [a-z] [A-Z])"; \
		if [ "$${level}"   = "DEBUG" ]; then \
			echo "1"; \
		elif [ "$${level}" = "INFO" ]; then \
			echo "2"; \
		elif [ "$${level}" = "WARN" ]; then \
			echo "3"; \
		elif [ "$${level}" = "ERROR" ]; then \
			echo "4"; \
		elif [ "$${level}" = "FATAL" ]; then \
			echo "5"; \
		elif [ "$${level}" = "START" ]; then \
			echo "6"; \
		elif [ "$${level}" = "FINISH" ]; then \
			echo "7"; \
		elif [ "$${level}" = "OFF" ]; then \
			echo "8"; \
		else \
			echo "0"; \
		fi; \
	}; \
	\
	function show_log_progress() { \
		if [ -n "$$(echo "$(LOG_FIELDS)" | grep 0)" ]; then \
			echo "$(TRUE)"; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function show_log_timestamp() { \
		if [ -n "$$(echo "$(LOG_FIELDS)" | grep 1)" ]; then \
			echo "$(TRUE)"; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function show_log_level() { \
		if [ -n "$$(echo "$(LOG_FIELDS)" | grep 2)" ]; then \
			echo "$(TRUE)"; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function show_log_emoji() { \
		if [ "$(LOG_COLOR)" == "$(ON)" ]; then \
			if [ -n "$$(echo "$(LOG_FIELDS)" | grep 3)" ]; then \
				echo "$(TRUE)"; \
			else \
				echo "$(FALSE)"; \
			fi; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function show_log_target() { \
		if [ -n "$$(echo "$(LOG_FIELDS)" | grep 4)" ]; then \
			echo "$(TRUE)"; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function show_log_dependencies() { \
		if [ -n "$$(echo "$(LOG_FIELDS)" | grep 5)" ]; then \
			echo "$(TRUE)"; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function show_log_message() { \
		if [ -n "$$(echo "$(LOG_FIELDS)" | grep 6)" ]; then \
			echo "$(TRUE)"; \
		else \
			echo "$(FALSE)"; \
		fi; \
	}; \
	\
	function wrap_log_progress() { \
		local -r progress="[$${1}]"; \
		echo "$${progress}"; \
	}; \
	\
	function wrap_log_timestamp() { \
		local -r timestamp="[$${1}]"; \
		echo "$${timestamp}"; \
	}; \
	\
	function wrap_log_level() { \
		local -r level="[$${1}]"; \
		local -r counts="$$((8-$$(echo "$${level}" | wc -L)))"; \
		echo "$${level}$$($(REPEAT_SUBSTRING) " " "$${counts}")"; \
	}; \
	\
	function wrap_log_target() { \
		local -r target="[$${1}]"; \
		echo "$${target}"; \
	}; \
	\
	function wrap_log_dependencies() { \
		local -r dependencies="[$${1}]"; \
		echo "$${dependencies}"; \
	}; \
	\
	function wrap_log_message() { \
		local -r message="$${1}"; \
		echo "$${message}"; \
	}; \
	\
	function append_log() { \
		local -r result="$${1}"; \
		local -r text="$${2}"; \
		if [ -n "$${result}" ]; then \
			echo "$${result} $${text}"; \
		else \
			echo "$${result}$${text}"; \
		fi; \
	}; \
	\
	function wrap_log() { \
		local -r progress="$${1}"; \
		local -r timestamp="$${2}"; \
		local -r level="$${3}"; \
		local -r emoji="$${4}"; \
		local -r target="$${5}"; \
		local -r dependencies="$${6}"; \
		local -r message="$${7}"; \
		\
		local result=""; \
		[ "$$(show_log_progress)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${progress}")"; \
		[ "$$(show_log_timestamp)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${timestamp}")"; \
		[ "$$(show_log_level)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${level}")"; \
		[ "$$(show_log_emoji)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${emoji}")"; \
		[ "$$(show_log_target)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${target}")"; \
		[ "$$(show_log_dependencies)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${dependencies}")"; \
		[ "$$(show_log_message)" = "$(TRUE)" ] && \
			result="$$(append_log "$${result}" "$${message}")"; \
		echo "$${result}"; \
	}; \
	\
	function get_color_option() { \
		local -r level="$$(translate_log_level "$${1}")"; \
		echo "$$( \
			echo "$(LOG_COLOR_OPTIONS)" | \
			awk -v level="$${level}" "{ \
				for (i = 1; i <= NF; i++) { \
					if (i == level) { \
						print \$$i; \
					} \
				} \
			}" | \
			sed -e "s/^\[//g" -e "s/\]$$//g" | \
			sed -e "s/|/ /g" \
		)"; \
	}; \
	\
	function get_color_emoji() { \
		local -r level="$$(translate_log_level "$${1}")"; \
		echo "$$( \
			echo "$(LOG_COLOR_EMOJIS)" | \
			awk -v level="$${level}" "{ \
				for (i = 1; i <= NF; i++) { \
					if (i == level) { \
						print \$$i; \
					} \
				} \
			}" \
		)"; \
	}; \
	\
	function calculate_progress() { \
		local -r result="$$($(REPEAT_SUBSTRING) " " \
			"$$(( \
				$$($(STRING_LENGTH) "$(TOTAL_STEPS)")-$$($(STRING_LENGTH) "$(CURRENT_STEP)") \
			))" \
		)$(CURRENT_STEP)/$(TOTAL_STEPS)"; \
		echo "$${result}"; \
	}; \
	\
	function format_color_log() { \
		local progress="$${1}"; \
		local timestamp="$${2}"; \
		local level="$${3}"; \
		local target="$${4}"; \
		local dependencies="$${5}"; \
		local message="$${6}"; \
		\
		local -r emoji="$$(get_color_emoji "$${level}")"; \
		local -r colors=($$(get_color_option "$${level}")); \
		\
		local -r progress_color="$${colors[0]}"; \
		progress="$$( \
			$(PAINT) \
				"$${progress_color%%:*}" \
				"$${progress_color\#\#*:}" \
				"$$(wrap_log_progress "$${progress}")" \
		)"; \
		\
		local -r timestamp_color="$${colors[1]}"; \
		timestamp="$$( \
			$(PAINT) \
				"$${timestamp_color%%:*}" \
				"$${timestamp_color\#\#*:}" \
				"$$(wrap_log_timestamp "$${timestamp}")" \
		)"; \
		\
		local -r level_color="$${colors[2]}"; \
		level="$$( \
			$(PAINT) \
				"$${level_color%%:*}" \
				"$${level_color\#\#*:}" \
				"$$(wrap_log_level "$${level}")" \
		)"; \
		\
		local -r target_color="$${colors[3]}"; \
		target="$$( \
			$(PAINT) \
				"$${target_color%%:*}" \
				"$${target_color\#\#*:}" \
				"$$(wrap_log_target "$${target}")" \
		)"; \
		\
		local -r deps_color="$${colors[4]}"; \
		dependencies="$$( \
			$(PAINT) \
				"$${deps_color%%:*}" \
				"$${deps_color\#\#*:}" \
				"$$(wrap_log_dependencies "$${dependencies}")" \
		)"; \
		\
		local -r message_color="$${colors[5]}"; \
		message="$$( \
			$(PAINT) \
				"$${message_color%%:*}" \
				"$${message_color\#\#*:}" \
				"$$(wrap_log_message "$${message}")" \
		)"; \
		\
		echo "$$( \
			wrap_log \
				"$${progress}" \
				"$${timestamp}" \
				"$${level}" \
				"$${emoji}" \
				"$${target}" \
				"$${dependencies}" \
				"$${message}" \
		)"; \
	}; \
	\
	function format_plain_log() { \
		local -r progress="$${1}"; \
		local -r timestamp="$${2}"; \
		local -r level="$${3}"; \
		local -r target="$${4}"; \
		local -r dependencies="$${5}"; \
		local -r message="$${6}"; \
		\
		echo "$$( \
			wrap_log \
				"$$(wrap_log_progress "$${progress}")" \
				"$$(wrap_log_timestamp "$${timestamp}")" \
				"$$(wrap_log_level "$${level}")" \
				"$$(wrap_log_target "$${target}")" \
				"$$(wrap_log_dependencies "$${dependencies}")" \
				"" \
				"$$(wrap_log_message "$${message}")" \
		)"; \
	}; \
	\
	local -r progress="$$(calculate_progress)"; \
	local -r timestamp="$$(date +$(LOG_FORMAT))"; \
	local -r env_level="$$(translate_log_level $(LOG_LEVEL))"; \
	local -r cur_level="$$(translate_log_level $${level})"; \
	\
	if [ "$${cur_level}" -ge "$${env_level}" ]; then \
		if [ "$(LOG_COLOR)" = "$(ON)" ]; then \
			$(COLOR_PRINT) "$$( \
				format_color_log \
					"$${progress}" "$${timestamp}" "$${level}" "$@" "$^" "$${message}" \
			)" >> $(LOG_OUTPUT); \
		else \
			$(PLAIN_PRINT) "$$( \
				format_plain_log \
					"$${progress}" "$${timestamp}" "$${level}" "$@" "$^" "$${message}" \
			)" >> $(LOG_OUTPUT); \
		fi; \
	fi; \
}; _LOG

###############################################################################

override LOG_DEBUG ?= function LOG_DEBUG() { \
	local -r message="$${1}"; \
	$(_LOG) "DEBUG" "$${message}"; \
}; LOG_DEBUG

override LOG_INFO ?= function LOG_INFO() { \
	local -r message="$${1}"; \
	$(_LOG) "INFO" "$${message}"; \
}; LOG_INFO

override LOG_WARN ?= function LOG_WARN() { \
	local -r message="$${1}"; \
	$(_LOG) "WARN" "$${message}"; \
}; LOG_WARN

override LOG_ERROR ?= function LOG_ERROR() { \
	local -r message="$${1}"; \
	$(_LOG) "ERROR" "$${message}"; \
}; LOG_ERROR

override LOG_FATAL ?= function LOG_FATAL() { \
	local -r message="$${1}"; \
	$(_LOG) "FATAL" "$${message}"; \
}; LOG_FATAL

override LOG_START ?= function LOG_START() { \
	local -r message="$${1}"; \
	$(_LOG) "START" "$${message}"; \
}; LOG_START

override LOG_FINISH ?= function LOG_FINISH() { \
	local -r message="$${1}"; \
	$(_LOG) "FINISH" "$${message}"; \
}; LOG_FINISH

###############################################################################

endif
