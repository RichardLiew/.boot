# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "System Utils For Makefile" version 1.0
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
#   System utils for makefile.
#
###############################################################################

ifndef __SYSTEM__
define __SYSTEM__
endef

###############################################################################

ARCH ?= $(shell uname -m | tr [A-Z] [a-z])
ifeq ($(ARCH),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "ARCH not allow to be empty!"))
endif

SYSTEM ?= $(shell uname -s | tr [A-Z] [a-z])
ifeq ($(SYSTEM),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "SYSTEM not allow to be empty!"))
endif

###############################################################################

override SET_ENV ?= function SET_ENV() { \
	local -r content="$${1}"; \
	local -r bashrc="$${HOME}/.bash_profile"; \
	if [ -n "$${content}" ]; then \
		if [ -z "$$(cat $${bashrc} | egrep "^$${content}$$")" ]; then \
			echo "$${content}" >> $${bashrc}; \
		fi; \
	fi; \
}; SET_ENV

###############################################################################

endif
