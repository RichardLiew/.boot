# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Release Utils For Makefile" version 1.0
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
#   Release utils for makefile.
#
###############################################################################

ifndef __RELEASE__
define __RELEASE__
endef

###############################################################################

include $(MKFLIB)/includes.makefile

###############################################################################

RELEASE_APP ?=
RELEASE_VERSION ?=

###############################################################################

RELEASE_DIR ?= $(WORKDIR)/release
ifeq ($(RELEASE_DIR),$(EMPTY))
	$(error $(shell $(LOG_FATAL) "RELEASE_DIR not allow to be empty!"))
else ifeq ($(RELEASE_DIR),/)
	$(error $(shell $(LOG_FATAL) "RELEASE_DIR not allow to be root directory!"))
endif

###############################################################################

.DEFAULT_GOAL := release-all

###############################################################################

.PHONY: release-all
release-all: release

.PHONY: release
release: release-start release-precheck release-clean release-init release-execute release-finish

.PHONY: release-start
release-start:
	@$(LOG_START) "Starting to make release ..."

.PHONY: release-precheck
release-precheck:
	@$(LOG_INFO) "Prechecking release ..."
ifndef RELEASE_VERSION
	$(error $(shell $(LOG_FATAL) "Missing \"RELEASE_VERSION\"!"))
endif
	@$(LOG_INFO) "Precheck release finished!"

.PHONY: release-init
release-init: release-precheck
	@$(LOG_INFO) "Initting release ..."
	@mkdir -p $(RELEASE_DIR)/$(RELEASE_VERSION)
	@-rm -rf $(RELEASE_DIR)/$(RELEASE_VERSION)/*
	@$(LOG_INFO) "Init release finished!"

.PHONY: release-execute
release-execute: release-init
	@$(LOG_INFO) "Executing release ..."
	@$(LOG_INFO) "Releasing $(RELEASE_APP) ..."
	@$(LOG_INFO) "Tarring ..."
	@tar -cvzf \
		$(RELEASE_DIR)/$(RELEASE_VERSION)/$(APPNAME)-$(subst /,-,$(osarch))-release-$(VERSION).tar.gz \
		$(BIN_DIR)/$(osarch)/$(APPNAME)
	@$(LOG_INFO) "Tar finished!"
	@$(LOG_INFO) "Zipping ..."
	@zip \
		$(RELEASE_DIR)/$(VERSION)/$(APPNAME)-$(subst /,-,$(osarch))-release-$(VERSION).zip \
		$(BIN_DIR)/$(osarch)/$(APPNAME)
	@$(LOG_INFO) "Zip finished!"
	@$(LOG_INFO) "Release $(TARGET_APP) finished!"
	@$(LOG_INFO) "Execute release finished!"

.PHONY: release-clean
release-clean: release-precheck
	@$(LOG_INFO) "Cleaning release ..."
	@-rm -rf $(RELEASE_DIR)/$(RELEASE_VERSION)
	@$(LOG_INFO) "Clean release finished!"

.PHONY: release-clean-all
release-clean-all:
	@$(LOG_INFO) "Cleaning all versions of release ..."
	@-rm -rf $(RELEASE_DIR)/*
	@$(LOG_INFO) "Clean all versions of release finished!"

.PHONY: release-finish
release-finish:
	@$(LOG_FINISH) "Make release finished!"

###############################################################################

endif
