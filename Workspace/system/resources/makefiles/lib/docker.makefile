# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Docker Utils For Makefile" version 1.0
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
#   Docker utils for makefile.
#
###############################################################################

ifndef __DOCKER__
define __DOCKER__
endef

###############################################################################

include $(MKFLIB)/includes.makefile

###############################################################################

override PARSE_DOCKERFILE ?= function PARSE_DOCKERFILE() { \
	local -r dockerfile="$${1}"; \
	if [ ! -e "$${dockerfile}" ]; then \
		echo "$(ERROR_PREFIX)Dockerfile $${dockerfile} not exists!"; \
	else \
		local -r name=$$( \
			cat $${dockerfile} | \
			egrep -o "Vendor[ \t]*=[ \t]*\"[a-zA-Z0-9_=\\-]+\"" | \
			egrep -o "\"[a-zA-Z0-9_=\\-]+\"" | \
			sed -e "s/^.//g" -e "s/.$$//g" \
		); \
		if [ -z "$${name}" ]; then \
			echo "$(ERROR_PREFIX)Invalid name!"; \
		else \
			local -r version=$$( \
				cat $${dockerfile} | \
				egrep -o "Version[ \t]*=[ \t]*\"[a-zA-Z0-9_.\\-]+\"" | \
				egrep -o "\"[a-zA-Z0-9_.\\-]+\"" | \
				sed -e "s/^.//g" -e "s/.$$//g" | \
				sed -e "s/^/v/g" \
			); \
			if [ -z "$${version}" ]; then \
				echo "$(ERROR_PREFIX)Invalid version!"; \
			else \
				echo "$${name}:$${version}"; \
			fi; \
		fi; \
	fi; \
}; PARSE_DOCKERFILE

###############################################################################

endif
