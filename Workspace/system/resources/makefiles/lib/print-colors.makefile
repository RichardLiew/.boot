# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Print Colors For Makefile" version 1.0
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
#   Print colors for makefile.
#
###############################################################################

ifndef __PRINT_COLORS__
define __PRINT_COLORS__
endef

###############################################################################

MKFLIB := .

###############################################################################

include $(MKFLIB)/strings.makefile
include $(MKFLIB)/painting.makefile

###############################################################################
#
# Format:
#   - front_color:back_color|sequence:group-lower_color:upper_color
#
###############################################################################

PAINTING_OPTIONS ?= 0:|v:51-1:256

###############################################################################

override _PARSE_PARAMS ?= function _PARSE_PARAMS() { \
	local params="$${1}"; \
	[[ "$${params}" != *"|"* ]] && params="$${params}|"; \
	\
	local colors="$${params%%|*}"; \
	[[ "$${colors}" != *":"* ]] && colors="$${colors}:"; \
	\
	local front_color="$${colors%%:*}"; \
	[ -z "$${front_color}" ] && front_color="-1"; \
	\
	local back_color="$${colors\#\#*:}"; \
	[ -z "$${back_color}" ] && back_color="-1"; \
	\
	local styles="$${params\#\#*|}"; \
	[[ "$${styles}" != *"-"* ]] && styles="$${styles}-"; \
	\
	local sequence_ngroups="$${styles%%-*}"; \
	[[ "$${sequence_ngroups}" != *":"* ]] && sequence_ngroups="$${sequence_ngroups}:"; \
	\
	local sequence="$${sequence_ngroups%%:*}"; \
	[ -z "$${sequence}" ] && sequence="h"; \
	\
	local ngroups="$${sequence_ngroups\#\#*:}"; \
	[ -z "$${ngroups}" ] && ngroups="8"; \
	\
	local ncolors="$${styles\#\#*-}"; \
	[[ "$${ncolors}" != *":"* ]] && ncolors="$${ncolors}:"; \
	\
	local lower_color="$${ncolors%%:*}"; \
	[ -z "$${lower_color}" ] && lower_color="0"; \
	\
	local upper_color="$${ncolors\#\#*:}"; \
	[ -z "$${upper_color}" ] && upper_color="256"; \
	\
	echo "$${front_color} $${back_color} $${sequence} $${ngroups} $${lower_color} $${upper_color}"; \
}; _PARSE_PARAMS

override _FORMAT_EXAMPLE ?= function _FORMAT_EXAMPLE() { \
	local -r front_color="$${1}"; \
	local -r back_color="$${2}"; \
	\
	local fc_counts="$$(( \
		3-$$(echo "$${front_color}" | cut -d ";" -f 1 | wc -L) \
	))"; \
	local example="$$($(REPEAT_SUBSTRING) " " "$${fc_counts}")"; \
	example="$${example}$${front_color}:$${back_color}"; \
	local bc_counts="$$(( \
		3-$$(echo "$${back_color}" | cut -d ";" -f 1 | wc -L) \
	))"; \
	example="$${example}$$($(REPEAT_SUBSTRING) " " "$${bc_counts}")"; \
	example=" $${example} EXAMPLE "; \
	\
	echo "$$( \
		$(PAINT_TEXT) "$${front_color}:$${back_color}" "$${example}" \
	)"; \
}; _FORMAT_EXAMPLE

override PRINT_COLORS ?= function PRINT_COLORS() { \
	local -r params=($$($(_PARSE_PARAMS) "$$@")); \
	\
	local -r front_color="$${params[0]}"; \
	local -r back_color="$${params[1]}"; \
	local -r sequence="$${params[2]}"; \
	local -r ngroups="$${params[3]}"; \
	local -r lower_color="$${params[4]}"; \
	local -r upper_color="$${params[5]}"; \
	\
	local colors=(); \
	for (( i=lower_color; i<upper_color; i++ )); do \
		colors[$$(($${i}-$${lower_color}))]=$$( \
			$(_FORMAT_EXAMPLE) \
				"$$( \
					[ "$${front_color:0:2}" = "-1" ] && \
						echo "$${i}$${front_color:2}" || echo "$${front_color}" \
				)" \
				"$$( \
					[ "$${back_color:0:2}" = "-1" ] && \
						echo "$${i}$${back_color:2}" || echo "$${back_color}" \
				)" \
		); \
		if [ "$${front_color:0:2}" != "-1" ]; then \
			if [ "$${back_color:0:2}" != "-1" ]; then \
				break; \
			fi; \
		fi; \
	done; \
	\
	if [ "$${sequence}" = "h" ]; then \
		local -r nrows="$$(($${\#colors[@]}/$${ngroups}+1))"; \
		local -r ncolumns="$${ngroups}"; \
	else \
		local -r ncolumns="$$(($${\#colors[@]}/$${ngroups}+1))"; \
		local -r nrows="$${ngroups}"; \
	fi; \
	\
	for (( i=0; i<nrows; i++ )); do \
		for (( j=0; j<ncolumns; j++ )); do \
			local coord=($$( \
				[ "$${sequence}" = "h" ] && echo "$${i} $${j}" || echo "$${j} $${i}" \
			)); \
			\
			local index=$$(($${coord[0]}*$${ngroups}+$${coord[1]})); \
			if [ "$${index}" -ge "$${\#colors[@]}" ]; then \
				continue; \
			fi; \
			\
			local separator=""; \
			if [ "$${sequence}" = "h" ]; then \
				if [ "$${index}" -ne "$$(($${\#colors[@]}-1))" ]; then \
					if [ "$${j}" -eq "$$(($${ngroups}-1))" ]; then \
						separator="\n\c"; \
					else \
						separator=" \c"; \
					fi; \
				fi; \
			else \
				if [ "$$(($${\#colors[@]}/$${ngroups}))" -gt 0 ]; then \
					if [ "$${index}" -ne "$$(($${\#colors[@]}-$${\#colors[@]}%$${ngroups}-1))" ]; then \
						if [ "$$(($${i}+$${ngroups}*($${j}+1)))" -ge "$${\#colors[@]}" ]; then \
							separator="\n\c"; \
						else \
							separator=" \c"; \
						fi; \
					fi; \
				fi; \
			fi; \
			\
			$(COLOR_PRINT) "$${colors[$${index}]}$${separator}"; \
		done; \
	done; \
}; PRINT_COLORS

###############################################################################

.PHONY: print-colors
print-colors:
	@$(PRINT_COLORS) "$(PAINTING_OPTIONS)"

###############################################################################

endif
