# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Common Makefile For Protobuf Building" version 1.0
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
#   The common makefile for protobuf building.
#
###############################################################################

ifndef __PROTOS__
define __PROTOS__
endef

###############################################################################

MKFLIB := ../../resources/makefiles/lib

include $(MKFLIB)/includes.makefile

###############################################################################

.PHONY: \
	all init install build clean \
	preinstall preinstall-all preinstall-start preinstall-clean \
		preinstall-init preinstall-execute preinstall-finish \
		preinstall-protobuf preinstall-protoc-gen-go preinstall-grpcio-tools \
	golang golang-all golang-start golang-clean \
		golang-init golang-build golang-finish \
	python python-all python-start python-clean \
		python-init python-include python-build python-finish

###############################################################################

override SOURCE_DIR    := $(WORKDIR)/source
override INCLUDE_DIR   := $(SOURCE_DIR)/include
override OUTPUT_DIR    := $(WORKDIR)/output
override GOLANG_OUTPUT := $(OUTPUT_DIR)/golang
override PYTHON_OUTPUT := $(OUTPUT_DIR)/python

###############################################################################

override INCLUDES := $(wildcard $(INCLUDE_DIR)/*.proto)
override SOURCES  := $(filter-out $(INCLUDES),$(shell find $(SOURCE_DIR) -name *.proto))

###############################################################################

PYTHON_COMMAND := python

###############################################################################

ifeq ($(GOLANG_OUTPUT),$(EMPTY))
$(error $(shell $(LOG_FATAL) "GOLANG_OUTPUT not allow to be empty!"))
else ifeq ($(GOLANG_OUTPUT),/)
$(error $(shell $(LOG_FATAL) "GOLANG_OUTPUT not allow to be root directory!"))
endif

ifeq ($(PYTHON_OUTPUT),$(EMPTY))
$(error $(shell $(LOG_FATAL) "PYTHON_OUTPUT not allow to be empty!"))
else ifeq ($(PYTHON_OUTPUT),/)
$(error $(shell $(LOG_FATAL) "PYTHON_OUTPUT not allow to be root directory!"))
endif

ifeq ($(findstring python,$(PYTHON_COMMAND)),$(EMPTY))
$(error $(shell $(LOG_FATAL) "PYTHON_COMMAND is invalid!"))
endif

###############################################################################

.DEFAULT_GOAL := init

###############################################################################

init: golang-init python-init

install: clean build

all: clean init build

build: golang-build python-build

clean: golang-clean python-clean

###############################################################################

preinstall-all: preinstall

preinstall: preinstall-start preinstall-clean \
	preinstall-init preinstall-execute preinstall-finish

preinstall-start:
	@$(LOG_START) "Starting to make preinstall ..."

preinstall-init:

preinstall-execute: preinstall-protobuf preinstall-protoc-gen-go preinstall-grpcio-tools

preinstall-protobuf:
	@brew install protobuf

preinstall-protoc-gen-go:
	@go get -u github.com/golang/protobuf/protoc-gen-go

preinstall-grpcio-tools:
	@$(PYTHON_COMMAND) -m pip install grpcio-tools

preinstall-clean:

preinstall-finish:
	@$(LOG_FINISH) "Make preinstall finished!"

###############################################################################

.PHONY: golang-all
golang-all: golang

.PHONY:
golang: golang-start golang-clean golang-init golang-build golang-finish

.PHONY:
golang-start:
	@$(LOG_START) "Starting to make golang protos ..."

.PHONY:
golang-init:
	@$(LOG_INFO) "Initing golang protos ..."
	@$(EXECUTE) 'mkdir -p $(GOLANG_OUTPUT)'
	@$(LOG_INFO) "Init golang protos finished!"

.PHONY:
golang-build: $(SOURCES) $(INCLUDES)
	@$(LOG_INFO) "Building golang protos ..."
	@$(foreach \
		proto, \
		$(SOURCES), \
		$(LOG_INFO) "Building '$(notdir $(proto))' for golang ..."; \
		mkdir -p $(subst $(SOURCE_DIR),$(GOLANG_OUTPUT),$(dir $(proto))); \
		protoc \
			--proto_path=$(dir $(proto)) \
			--go_out=plugins=grpc:$(subst $(SOURCE_DIR),$(GOLANG_OUTPUT),$(dir $(proto))) \
			$(proto); \
		$(LOG_INFO) "Build '$(notdir $(proto))' for golang finished!"; \
	)
	@$(LOG_INFO) "Build golang protos finished!"

.PHONY:
golang-clean:
	@$(LOG_INFO) "Cleaning golang protos ..."
	@-rm -rf $(GOLANG_OUTPUT)/*
	@$(LOG_INFO) "Clean golang protos finished!"

.PHONY:
golang-finish:
	@$(LOG_FINISH) "Make golang protos finished!"

###############################################################################

.PHONY:
python-all: python

.PHONY:
python: python-start python-clean python-init python-include python-build python-finish

.PHONY:
python-start:
	@$(LOG_START) "Starting to make python protos ..."

.PHONY:
python-init:
	@$(LOG_INFO) "Initing python protos ..."
	@mkdir -p $(PYTHON_OUTPUT)
	@$(LOG_INFO) "Init python protos finished!"

.PHONY:
python-include: $(INCLUDES)
	@$(LOG_INFO) "Building python include protos ..."
	@$(foreach \
		proto, \
		$(INCLUDES), \
		$(LOG_INFO) "Building '$(notdir $(proto))' for python include ..."; \
		mkdir -p $(subst $(SOURCE_DIR),$(PYTHON_OUTPUT),$(dir $(proto))); \
		$(PYTHON_COMMAND) \
			-m grpc_tools.protoc \
			--proto_path=$(dir $(proto)) \
			--python_out=$(subst $(SOURCE_DIR),$(PYTHON_OUTPUT),$(dir $(proto))) \
			--grpc_python_out=$(subst $(SOURCE_DIR),$(PYTHON_OUTPUT),$(dir $(proto))) \
			$(proto); \
		$(LOG_INFO) "Build '$(notdir $(proto))' for python include finished!"; \
	)
	@$(LOG_INFO) "Build python include protos finished!"

.PHONY:
python-build: python-include $(SOURCES)
	@$(LOG_INFO) "Building python protos ..."
	@$(foreach \
		proto, \
		$(SOURCES), \
		$(LOG_INFO) "Building '$(notdir $(proto))' for python ..."; \
		mkdir -p $(subst $(SOURCE_DIR),$(PYTHON_OUTPUT),$(dir $(proto))); \
		$(PYTHON_COMMAND) \
			-m grpc_tools.protoc \
			--proto_path=$(dir $(proto)) \
			--python_out=$(subst $(SOURCE_DIR),$(PYTHON_OUTPUT),$(dir $(proto))) \
			--grpc_python_out=$(subst $(SOURCE_DIR),$(PYTHON_OUTPUT),$(dir $(proto))) \
			$(proto); \
		$(LOG_INFO) "Build '$(notdir $(proto))' for python finished!"; \
	)
	@$(LOG_INFO) "Build python protos finished!"

.PHONY:
python-clean:
	@$(LOG_INFO) "Cleaning python protos ..."
	@-rm -rf $(PYTHON_OUTPUT)/*
	@$(LOG_INFO) "Clean python protos finished!"

.PHONY:
python-finish:
	@$(LOG_FINISH) "Make python protos finished!"

###############################################################################

.PHONY: help
help:
	$(info Available Targets:)
	@cat $(firstword $(MAKEFILE_LIST)) | \
		egrep -v ":=" | \
		egrep -v "^(\t+| +)" | \
		egrep -o "^.+:" | \
		egrep -v "^(#|\.)" | \
		sed -e "s/://g" -e "s/^/    /g"

###############################################################################

endif
