# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "String Utils For Makefile" version 1.0
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
#   String utils for makefile.
#
###############################################################################

ifndef __STRINGS__
define __STRINGS__
endef

###############################################################################

override REPEAT_SUBSTRING ?= function REPEAT_SUBSTRING() { \
	local -r substring="$${1}"; \
	local -ir counts="$${2}"; \
	\
	local result=""; \
	if [[ -n "$${substring}" && -n "$${counts}" && "$${counts}" -gt 0 ]]; then \
		for (( i=0; i<counts; i++ )); do \
			result="$${result}$${substring}"; \
		done; \
	fi; \
	echo "$${result}"; \
}; REPEAT_SUBSTRING

override ERASE_SUBSTRING ?= function ERASE_SUBSTRING() { \
	local -r source_string="$${1}"; \
	local -r substring="$${2}"; \
	\
	echo "$${source_string}" | sed "s/$${substring}//g"; \
}; ERASE_SUBSTRING

override REPLACE_SUBSTRING ?= function REPLACE_SUBSTRING() { \
	local -r source_string="$${1}"; \
	local -r old_substring="$${2}"; \
	local -r new_substring="$${3}"; \
	\
	echo "$${source_string}" | sed "s/$${old_substring}/$${new_substring}/g"; \
}; REPLACE_SUBSTRING

###############################################################################

override ERASE_BEGINNING ?= function ERASE_BEGINNING() { \
	local -r string="$${1}"; \
	local -ir counts="$${2}"; \
	echo "$${string:$${counts}}"; \
}; ERASE_BEGINNING

override function ERASE_ENDING() { \
	local -r string="$${1}"; \
	local -ir counts="$${2}"; \
	echo "$${string:0:$$(($${#string}-$${counts}))}"; \
}; ERASE_ENDING

###############################################################################

override STRING_LENGTH ?= STRING_LENGTH() { \
	local -r source="$${1}"; \
	echo "$${source}" | wc -L; \
}; STRING_LENGTH

override ARRAY_SIZE ?= ARRAY_SIZE() { \
	local -r source="$${1}"; \
	local separator="$${2}"; \
	echo "$${source}" | awk -F "$${separator:- }" "{print NF}"; \
}; ARRAY_SIZE

###############################################################################

override STRING_SPLIT ?= STRING_SPLIT() { \
	local -r source="$${1}"; \
	local separator="$${2}"; \
	echo "$${source}" | awk -F "$${separator:- }" "\
		BEGIN{ \
			result=""; \
		} \
		{ \
			for (i=1; i<=NF; i++) { \
				if (length(result) > 0) { \
					result += " "; \
				} \
				result += "\$$i"; \
			} \
		} \
		END { \
			print result; \
		} \
	}"; \
}; STRING_SPLIT

###############################################################################

override LTRIM ?= function LTRIM() { \
	local -r source_string="$${1}"; \
	local substring="$${2}"; \
	\
	if [ -z "$${substring}" ]; then \
		 substring="[ \t\n\r]"; \
	fi; \
	\
	echo "$${source_string}" | awk "gsub(/^"$${substring}"*/, \"\")"; \
}; LTRIM

override RTRIM ?= function RTRIM() { \
	local -r source_string="$${1}"; \
	local substring="$${2}"; \
	\
	if [ -z "$${substring}" ]; then \
		substring="[ \t\n\r]"; \
	fi; \
	\
	echo "$${source_string}" | awk "gsub("$${substring}"*$/, \"\")"; \
}; RTRIM

override TRIM ?= function TRIM() { \
	local -r source_string="$${1}"; \
	local -r substring="$${2}"; \
	\
	$(RTRIM) "$$($(LTRIM) "$${source_string}" "$${substring}")" "$${substring}"; \
}; TRIM

###############################################################################

endif
