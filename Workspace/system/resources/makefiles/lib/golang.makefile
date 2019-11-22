# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Golang Utils For Makefile" version 1.0
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
#   Golang utils for makefile.
#
###############################################################################

ifndef __GOLANG__
define __GOLANG__
endef

###############################################################################

include $(MKFLIB)/includes.makefile
include $(MKFLIB)/system.makefile

###############################################################################

override TRANSLATE_GOARCH ?= function TRANSLATE_GOARCH() { \
	local -r arch="$${1}"; \
	if [ "$${arch}" = "i386" ]; then \
		echo "386"; \
	elif [ "$${arch}" = "x86_64" ]; then \
		echo "amd64"; \
	elif [ "$${arch}" = "amd64p32" ]; then \
		echo "amd64p32"; \
	elif [ "$${arch}" = "arm" ]; then \
		echo "arm"; \
	elif [ "$${arch}" = "arm64" ]; then \
		echo "arm64"; \
	elif [ "$${arch}" = "mips" ]; then \
		echo "mips"; \
	elif [ "$${arch}" = "mips64" ]; then \
		echo "mips64"; \
	elif [ "$${arch}" = "mips64le" ]; then \
		echo "mips64le"; \
	elif [ "$${arch}" = "mipsle" ]; then \
		echo "mipsle"; \
	elif [ "$${arch}" = "ppc64" ]; then \
		echo "ppc64"; \
	elif [ "$${arch}" = "ppc64le" ]; then \
		echo "ppc64le"; \
	elif [ "$${arch}" = "s390x" ]; then \
		echo "s390x"; \
	else \
		echo "$(ERROR_PREFIX)Unsupported arch $${arch}!"; \
	fi; \
}; TRANSLATE_GOARCH

###############################################################################

GOARCH ?= $(shell $(TRANSLATE_GOARCH) "$(ARCH)")
ifneq ($(findstring $(ERROR_PREFIX),$(GOARCH)),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "$(GOARCH:$(ERROR_PREFIX)=$(EMPTY))"))
endif
ifeq ($(GOARCH),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "GOARCH not allow to be empty!"))
endif

GOOSARCHS ?= $(SYSTEM)/$(GOARCH)
ifdef GOOSARCHS
ifeq ($(GOOSARCHS),all)
	GOOSARCHS := \
		darwin/amd64    \
		darwin/386      \
		linux/amd64     \
		linux/386       \
		linux/arm       \
		linux/arm64     \
		linux/ppc64     \
		linux/ppc64le   \
		linux/mips      \
		linux/mipsle    \
		linux/mips64    \
		linux/mips64le  \
		linux/s390x     \
		netbsd/386      \
		netbsd/amd64    \
		netbsd/arm      \
		openbsd/386     \
		openbsd/amd64   \
		openbsd/arm     \
		solaris/amd64   \
		windows/386     \
		windows/amd64   \
		dragonfly/amd64 \
		freebsd/386     \
		freebsd/amd64   \
		freebsd/arm     \
		#nacl/386       \
		#nacl/amd64p32  \
		#nacl/arm       \
		#plan9/386      \
		#plan9/amd64    \
		#plan9/arm
else
	GOOSARCHS := $(subst $(COMMA),$(SPACE),$(GOOSARCHS))
endif
endif
ifeq ($(GOOSARCHS),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "GOOSARCHS not allow to be empty!"))
endif

###############################################################################

endif
