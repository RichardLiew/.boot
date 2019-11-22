# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Git Utils For Makefile" version 1.0
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
#   Git utils for makefile.
#
###############################################################################

ifndef __GIT__
define __GIT__
endef

###############################################################################

GIT_REPO ?= $(shell git remote -v | grep "(fetch)" | awk "{print \$$2}")
ifeq ($(GIT_REPO),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "GIT_REPO not allow to be empty!"))
endif

GIT_BRANCH ?= $(shell git symbolic-ref --short -q HEAD)
ifeq ($(GIT_BRANCH),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "GIT_BRANCH not allow to be empty!"))
endif

MONITOR_BRANCH ?= $(GIT_BRANCH)
ifeq ($(MONITOR_BRANCH),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "MONITOR_BRANCH not allow to be empty!"))
endif

MONITOR_INTERVAL ?= 1m
ifeq ($(MONITOR_INTERVAL),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "MONITOR_INTERVAL not allow to be empty!"))
endif

COMMIT_INTERVAL ?= 5m
ifeq ($(COMMIT_INTERVAL),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "COMMIT_INTERVAL not allow to be empty!"))
endif

###############################################################################

endif
