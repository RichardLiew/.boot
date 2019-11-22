# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Common Makefile For Projects Building" version 1.0
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
#   The common makefile for projects building.
#
###############################################################################

ifndef __WORKFLOW_ENGINE__
define __WORKFLOW_ENGINE__
endef

###############################################################################

MKFLIB := resources/makefiles/lib

###############################################################################

include $(MKFLIB)/common.makefile

###############################################################################

.PHONY: \
	all start init build install clean stop docker help \
	alls alls-init alls-execute alls-clean alls-stop \
	preinstall preinstall-all preinstall-start preinstall-clean \
		preinstall-init preinstall-execute preinstall-finish \
		preinstall-make preinstall-go preinstall-go-env preinstall-protos \
		preinstall-fswatch preinstall-pre-commit preinstall-syntax-check \
	apps apps-all apps-start apps-init apps-compile apps-clean apps-finish \
	protos protos-all protos-start protos-init \
		protos-build protos-clean protos-finish \
	releases releases-all releases-start releases-precheck releases-init \
		releases-execute releases-clean releases-clean-all releases-finish \
	tests tests-all tests-start tests-init tests-execute \
		tests-bench tests-cover tests-func tests-clean tests-finish \
	watch watch-stop \
	serve serve-stop \
	monitor monitor-stop \
	commit-init commit commit-stop \
	logs-start logs-backup logs-init logs-clean logs-finish \
	docker docker-all docker-dev-all docker-dev docker-dev-build \
		docker-dev-start docker-dev-stop \
		ocker-dev-remove-containers docker-dev-remove-images \
		docker-stage docker-prod

###############################################################################

override BIN_DIR      := $(WORKDIR)/bin
override LOGS_DIR     := $(WORKDIR)/logs
override CONFIG_DIR   := $(WORKDIR)/config
override RELEASES_DIR := $(WORKDIR)/releases

###############################################################################

override PARSE_CONFIG := function PARSE_CONFIG() { \
	local config="$${1}"; \
	if [ ! -e "$${config}" ]; then \
		echo '$(ERROR_PREFIX)Config file "$${config}" not exists!'; \
	else \
		local port=$$( \
			cat $${config} | \
			egrep -o "^[ \t]*port[ \t]*:[ \t]*['\"]?[0-9]+['\"]?[ \t]*$$" | \
			egrep -o '[0-9]+' \
		); \
		if [ -z "$${port}" ]; then \
			echo "$(ERROR_PREFIX)Invalid port!"; \
		else \
			echo "$${port}"; \
		fi; \
	fi; \
}; PARSE_CONFIG

###############################################################################

override CONFIG := $(CONFIG_DIR)/$(APPNAME).dev.yaml

###############################################################################

ifeq ($(BIN_DIR),$(EMPTY))
$(error $(strip $(call ERROR,BIN_DIR not allow to be empty!)))
else ifeq ($(BIN_DIR),/)
$(error $(strip $(call ERROR,BIN_DIR not allow to be root directory!)))
endif

ifeq ($(LOGS_DIR),$(EMPTY))
$(error $(strip $(call ERROR,LOGS_DIR not allow to be empty!)))
else ifeq ($(LOGS_DIR),/)
$(error $(strip $(call ERROR,LOGS_DIR not allow to be root directory!)))
endif

###############################################################################

init: apps-init

install: clean build

all: clean init build

build: apps-compile

clean: apps-clean

start: stop logs
	@$(MAKE) monitor 2>&1 >> $(LOGS_DIR)/$(APPNAME)_monitor.log &
	@$(MAKE) commit 2>&1 >> $(LOGS_DIR)/$(APPNAME)_commit.log &
	@$(MAKE) watch 2>&1 >> $(LOGS_DIR)/$(APPNAME)_watch.log &
	@tail -f $(LOGS_DIR)/*.log

stop: monitor-stop commit-stop watch-stop

restart: stop start

###############################################################################

alls: preinstall-all protos-all tests-all releases-all apps-all logs-all

alls-init: preinstall-init protos-init tests-init releases-init apps-init \
	logs-init commit-init

alls-execute: preinstall-execute protos-build tests-execute apps-compile \
	releasess-execute logs-backup monitor watch serve commit

alls-clean: preinstall-clean protos-clean tests-clean releases-clean apps-clean logs-clean

alls-stop: watch-stop monitor-stop serve-stop commit-stop

###############################################################################

preinstall-all: preinstall

preinstall: preinstall-start preinstall-clean preinstall-init preinstall-execute preinstall-finish

preinstall-start:
	@message=$(strip $(call INFO,Starting to make preinstall ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

preinstall-init:
	@cd protos && $(MAKE) $@ && cd $(WORKDIR)

preinstall-execute: preinstall-make preinstall-go preinstall-go-env preinstall-protos \
	preinstall-fswatch preinstall-pre-commit preinstall-syntax-check

preinstall-make:
	@brew install make

preinstall-go:
	@brew install go

preinstall-go-env: go
	@echo $(strip $(call SET_ENVS,"export GOROOT=$$(go env GOROOT)")) >/dev/null
	@echo $(strip $(call SET_ENVS,"GO111MODULE=on")) >/dev/null
	@echo $(strip $(call SET_ENVS,"export GOPATH=$$\{HOME\}/.go")) >/dev/null
	@echo $(strip $(call \
		SET_ENVS,"export PATH=$$\{GOROOT\}/bin:$$\{GOPATH\}/bin:$$\{PATH\}" \
	)) >/dev/null
	@mkdir -p $${HOME}/.go/bin

preinstall-protos: preinstall-go-env
	@source $${HOME}/.bash_profile && \
		cd protos && $(MAKE) preinstall && cd $(WORKDIR)

preinstall-fswatch:
	@brew install fswatch

preinstall-pre-commit:
	@brew install pre-commit

preinstall-syntax-check:
	@go get -u golang.org/x/lint/golint
	@go get -u github.com/sqs/goreturns
	@go get -u golang.org/x/tools/cmd/goimports

preinstall-clean:
	@cd protos && $(MAKE) $@ && cd $(WORKDIR)

preinstall-finish:
	@message=$(strip $(call INFO,Make preinstall finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

logs-all: logs

logs: logs-start logs-backup logs-init logs-finish

logs-start:
	@message=$(strip $(call INFO,Starting to make logs ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

logs-init:
	@message=$(strip $(call INFO,Initting logs ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@mkdir -p $(LOGS_DIR)
	@message=$(strip $(call INFO,Init logs finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

logs-backup:
	@message=$(strip $(call INFO,Backing up logs ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@logfiles=$(wildcard $(LOGS_DIR)/*.log) \
	&& \
	if [ -n "$${logfiles}" ]; then \
		backdir=$$(date "+%Y%m%d%H%M%S"); \
		mkdir -p $(LOGS_DIR)/$${backdir}; \
		mv $${logfiles} $(LOGS_DIR)/$${backdir}/; \
	fi
	@message=$(strip $(call INFO,Back up logs finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

logs-clean:
	@message=$(strip $(call INFO,Cleaning logs ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@-rm -rf $(LOGS_DIR)/*
	@message=$(strip $(call INFO,Clean logs finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

logs-finish:
	@message=$(strip $(call INFO,Make logs finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

apps-all: apps

apps: apps-start apps-clean apps-init apps-compile apps-finish

apps-start:
	@message=$(strip $(call INFO,Starting to make apps ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

apps-init: protos
	@message=$(strip $(call INFO,Initting apps ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@env GO111MODULE=on go mod vendor
	@message=$(strip $(call INFO,Init apps finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

.ONESHELL:
apps-compile: main.go
	@message=$(strip $(call INFO,Compiling apps ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@$(foreach \
		osarch, \
		$(GOOSARCHS), \
		message=$(strip $(call INFO,Compiling $(osarch)/$(APPNAME) ...)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
		env \
			GO111MODULE=on \
			GOOS=$(firstword $(subst /,$(SPACE),$(osarch))) \
			GOARCH=$(lastword $(subst /,$(SPACE),$(osarch))) \
			go build -mod=vendor -o $(BIN_DIR)/$(osarch)/$(APPNAME) $<; \
		message=$(strip $(call INFO,Compile $(osarch)/$(APPNAME) finished!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	)
	@-rm -rf $(WORKDIR)/$(APPNAME)
	@ln -s $(BIN_DIR)/$(SYSTEM)/$(GOARCH)/$(APPNAME) $(WORKDIR)
	@message=$(strip $(call INFO,Compile apps finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

apps-clean:
	@message=$(strip $(call INFO,Cleaning apps ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@-rm -rf $(BIN_DIR)/*
	@-rm -rf $(WORKDIR)/$(APPNAME)
	@message=$(strip $(call INFO,Clean apps finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

apps-finish:
	@message=$(strip $(call INFO,Make apps finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

serve: serve-stop apps
	@message=$(strip $(call INFO,Starting "$(APPNAME)" service ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@$(WORKDIR)/$(APPNAME) serve -c $(CONFIG) &
	@message=$(strip $(call INFO,Service "$(APPNAME)" started!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

serve-stop:
	@message=$(strip $(call INFO,Stopping "$(APPNAME)" service ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@svrpids=$$( \
		ps aux | \
		egrep "$(WORKDIR)/$(APPNAME) serve" | \
		egrep -v "e?grep " | \
		awk '{print $$2}' \
	) \
	&& \
	message=$(strip $(call INFO,Killing $(APPNAME) progresses ...)) \
	&& \
	if [ -n "$${message}" ]; then echo "$${message}"; fi \
	&& \
	if [ -z "$(strip $${svrpids})" ]; then \
		message=$(strip $(call INFO,No $(APPNAME) progress to kill!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	else \
		echo "$${svrpids}" | xargs kill -9; \
		message=$(strip \
			$(call \
				INFO,$(APPNAME) progresses $(subst $(SPACE),$(COMMA),$${svrpids}) have been killed! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Service "$(APPNAME)" stopped!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

watch: watch-stop serve
	@message=$(strip $(call INFO,Starting to watch "$(WORKDIR)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@fswatch $(WORKDIR) \
		--exclude=\\.bak \
		--exclude=\\.backup \
		--exclude=\\.md \
		--exclude=\\.txt \
		--exclude=\\.log \
		--exclude=\\.git \
		--exclude=\\.swp \
		--exclude=\\.swx \
		--exclude=\\.dockerignore \
		--exclude=\\.gitignore \
		--exclude=\\.pre-commit-config.yaml \
		--exclude=\\.pre-commit-hooks.yaml \
		--exclude=Makefile* \
		--exclude=Dockerfile* \
		--exclude=releases/ \
		--exclude=examples/ \
		--exclude=docs/ \
		--exclude=doc.go \
		--exclude=client/ \
		--exclude=bin/ \
		--exclude=log/ \
		--exclude=logs/ \
		--exclude=vendor/ \
		--exclude=protos/golang \
		--exclude=protos/python \
		--exclude=$(WORKDIR)/$(APPNAME) \
	| while read file; do \
		file=$$( \
			echo "$${file}" | \
			egrep -v "$(WORKDIR)/[0-9]+" | \
			egrep -v "$(WORKDIR)/.*\~" | \
			egrep -v "^$(WORKDIR)$$" \
		); \
		if [ -n "$${file}" ]; then \
			message=$(strip $(call INFO,File "$${file}" changed!)); \
			if [ -n "$${message}" ]; then echo "$${message}"; fi; \
			$(MAKE) serve; \
		fi \
	done
	@message=$(strip $(call INFO,Watch "$(WORKDIR)" exit!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

watch-stop:
	@message=$(strip $(call INFO,Stopping to watch "$(WORKDIR)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@watchpids=$$( \
		ps aux | \
		egrep "fswatch $(WORKDIR)" | \
		egrep -v "e?grep fswatch $(WORKDIR)" | \
		egrep -v "e?grep --color=auto fswatch $(WORKDIR)" | \
		awk '{print $$2}' \
	) \
	&& \
	message=$(strip $(call INFO,Killing watch "$(WORKDIR)" progresses ...)) \
	&& \
	if [ -n "$${message}" ]; then echo "$${message}"; fi \
	&& \
	if [ -z "$(strip $${watchpids})" ]; then \
		message=$(strip $(call INFO,No watch progress to kill!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	else \
		echo "$${watchpids}" | xargs kill -9; \
		message=$(strip \
			$(call \
				INFO,Watch "$(WORKDIR)" progresses $(subst $(SPACE),$(COMMA),$${watchpids}) have been killed! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Watch "$(WORKDIR)" stopped!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

monitor: monitor-stop
	@message=$(strip $(call INFO,Monitorring git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@while true; do \
		message=$(strip $(call INFO,Pulling git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
		git pull origin $(MONITOR_GIT_BRANCH); \
		message=$(strip $(call INFO,Pull git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" finished!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
		sleep $(MONITOR_INTERVAL); \
	done
	@message=$(strip $(call INFO,Monitor git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" exit!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

monitor-stop:
	@message=$(strip $(call INFO,Stopping to monitor git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@monitorpids=$$( \
		ps aux | \
		egrep "while true; do" | \
		egrep "git pull origin $(MONITOR_GIT_BRANCH)" | \
		egrep -v "e?grep while true; do" | \
		egrep -v "e?grep --color=auto while true; do" | \
		egrep -v "e?grep git pull origin $(MONITOR_GIT_BRANCH)" | \
		egrep -v "e?grep --color=auto git pull origin $(MONITOR_GIT_BRANCH)" | \
		awk '{print $$2}' \
	) \
	&& \
	message=$(strip \
		$(call \
			INFO,Killing monitor git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" progresses ... \
		) \
	) \
	&& \
	if [ -n "$${message}" ]; then echo "$${message}"; fi \
	&& \
	if [ -z "$(strip $${monitorpids})" ]; then \
		message=$(strip $(call INFO,No monitor progress to kill!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	else \
		echo "$${monitorpids}" | xargs kill -9; \
		message=$(strip \
			$(call \
				INFO,Monitor git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" progresses $(subst $(SPACE),$(COMMA),$${monitorpids}) have been killed! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Monitor git branch "$(MONITOR_GIT_BRANCH)" of repo "$(GIT_REPO)" stopped!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

commit-init:
	@message=$(strip $(call INFO,Initting commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@pre-commit install
	@pre-commit install --hook-type pre-push
	@message=$(strip $(call INFO,Init commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" exit!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

commit: commit-stop commit-init
	@message=$(strip $(call INFO,Prepare to commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@while true; do \
		message=$(strip $(call INFO,Committing git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
		if [ "$(CURRENT_GIT_BRANCH)" = "master" ]; then \
			message=$(strip $(call INFO,Branch "master" not allow to commit!)); \
			if [ -n "$${message}" ]; then echo "$${message}"; fi; \
		else \
			git add --all; \
			files=$$(git diff --name-only --cached); \
			if [ -z "$${files}" ]; then \
				message=$(strip $(call INFO,No file to commit!)); \
				if [ -n "$${message}" ]; then echo "$${message}"; fi; \
			else \
				git commit -m "[SCHEDULE] Update files: $(subst $(SPACE),$(COMMA),$${files})." && \
				git push origin $(CURRENT_GIT_BRANCH); \
				message=$(strip \
					$(call \
						INFO,Commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" finished! \
					) \
				); \
				if [ -n "$${message}" ]; then echo "$${message}"; fi; \
			fi; \
		fi; \
		sleep $(COMMIT_INTERVAL); \
	done
	@message=$(strip $(call INFO,Commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" exit!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

commit-stop:
	@message=$(strip $(call INFO,Stopping to commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@commitpids=$$( \
		ps aux | \
		egrep "while true; do" | \
		egrep "git add --all" | \
		egrep -v "e?grep while true; do" | \
		egrep -v "e?grep --color=auto while true; do" | \
		egrep -v "e?grep git add --all" | \
		egrep -v "e?grep --color=auto git add --all" | \
		awk '{print $$2}' \
	) \
	&& \
	message=$(strip \
		$(call \
			INFO,Killing commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" progresses ... \
		) \
	) \
	&& \
	if [ -n "$${message}" ]; then echo "$${message}"; fi \
	&& \
	if [ -z "$(strip $${commitpids})" ]; then \
		message=$(strip $(call INFO,No commit progress to kill!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	else \
		echo "$${commitpids}" | xargs kill -9; \
		message=$(strip \
			$(call \
				INFO,Commit git branch "$(CURRENT_GIT_BRANCH)" progresses $(subst $(SPACE),$(COMMA),$${commitpids}) have been killed! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Commit git branch "$(CURRENT_GIT_BRANCH)" of repo "$(GIT_REPO)" stopped!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

protos-all: protos

protos: protos-start protos-clean protos-init protos-build protos-finish

protos-start:
	@message=$(strip $(call INFO,Starting to make protos ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

protos-init:
	@message=$(strip $(call INFO,Initting protos ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@message=$(strip $(call INFO,Init protos finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

protos-build:
	@message=$(strip $(call INFO,Building protos ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@cd protos && $(MAKE) && $(MAKE) install && cd $(WORKDIR)
	@message=$(strip $(call INFO,Build protos finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

protos-clean:
	@message=$(strip $(call INFO,Cleaning protos ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@cd protos && $(MAKE) clean && cd $(WORKDIR)
	@message=$(strip $(call INFO,Clean protos finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

protos-finish:
	@message=$(strip $(call INFO,Make protos finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

tests-all: tests

tests: tests-start tests-clean tests-init tests-execute tests-finish

tests-start:
	@message=$(strip $(call INFO,Starting to make tests ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

tests-init:
	@message=$(strip $(call INFO,Initting tests ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@message=$(strip $(call INFO,Init tests finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

tests-execute: tests-func tests-bench tests-cover

tests-func:
	@message=$(strip $(call INFO,Executing func tests ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@go test -v ".*"
	@message=$(strip $(call INFO,Execute func tests finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

tests-bench:
	@message=$(strip $(call INFO,Executing bench tests ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@go test -test.bench=".*"
	@message=$(strip $(call INFO,Execute bench tests finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

tests-cover:
	@message=$(strip $(call INFO,Executing cover tests ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@go test -cover ".*"
	@message=$(strip $(call INFO,Execute cover tests finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

tests-clean:
	@message=$(strip $(call INFO,Cleaning tests ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@message=$(strip $(call INFO,Clean tests finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

tests-finish:
	@message=$(strip $(call INFO,Make tests finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

###############################################################################

docker-all: docker

docker: docker-dev

docker-dev-all: docker-dev-stop docker-dev-remove-containers \
	docker-dev-remove-images docker-dev-build docker-dev-start

docker-dev: docker-dev-stop docker-dev-remove-containers docker-dev-start

docker-dev-build: Dockerfile.dev
	@message=$(strip $(call INFO,Starting to build docker containers for development ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@label=$(strip $(call PARSE_DOCKERFILE,$<)) \
	&& \
	if [ -n '$$(echo "$${label}" | grep "$(ERROR_PREFIX)")' ]; then \
		$(error \
			$(strip \
				$(call \
					ERROR,Invalid label of dockerfile "$<"! Error info: $$( \
						echo "$${label}" | sed -e 's/$(ERROR_PREFIX)//g' \
					) \
				) \
			) \
		); \
	fi \
	&& \
	docker build -f $< -t "$${label}" $(WORKDIR)
	@message=$(strip $(call INFO,Build docker containers for development finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

docker-dev-start: Dockerfile.dev $(CONFIG)
	@message=$(strip $(call INFO,Starting docker containers for development ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@label=$(strip $(call PARSE_DOCKERFILE,$<)) \
	&& \
	if [ -n '$$(echo "$${label}" | grep "$(ERROR_PREFIX)")' ]; then \
		$(error \
			$(strip \
				$(call \
					ERROR,Invalid label of dockerfile "$<"! Error info: $$( \
						echo "$${label}" | sed -e 's/$(ERROR_PREFIX)//g' \
					) \
				) \
			) \
		); \
	fi \
	&& \
	port=$(strip $(call PARSE_CONFIG,$(lastword $^))) \
	&& \
	if [ -n '$$(echo "$${port}" | grep "$(ERROR_PREFIX)")' ]; then \
		$(error \
			$(strip \
				$(call \
					ERROR,Invalid port of config "$(lastword $^)"! Error info: $$( \
						echo "$${port}" | sed -e 's/$(ERROR_PREFIX)//g' \
					) \
				) \
			) \
		); \
	fi \
	&& \
	name=$(firstword $(subst :,$(SPACE),$${label})) \
	&& \
	dkrhome=$$( \
		if [ ! -e "$<" ]; then \
			$(error $(strip $(call ERROR,Dockerfile "$<" not exists!))); \
		else \
			user=$$( \
				cat $< | \
				egrep -o '^ENV[ \t]+USER[ \t]*[ \t=][ \t]*[a-zA-Z0-9_\\-]+[ \t]*$$' | \
				sed -e 's/=/ /g' | \
				awk '{print $$3}' \
			); \
			if [ -z "$${user}" ]; then \
				$(error $(strip $(call ERROR,Invalid user!))); \
			else \
				project=$$( \
					cat $< | \
					egrep -o '^ENV[ \t]+PROJECT[ \t]*[ \t=][ \t]*[a-zA-Z0-9_\\-]+[ \t]*$$' | \
					sed -e 's/=/ /g' | \
					awk '{print $$3}' \
				); \
				if [ -z "$${project}" ]; then \
					$(error $(strip $(call ERROR,Invalid project!))); \
				else \
					echo "/usr/$${user}/$${project}"; \
				fi; \
			fi; \
		fi; \
	)) \
	&& \
	if [ -z "$${dkrhome}" ]; then \
		$(error $(strip $(call ERROR,Invalid docker home of dockerfile "$<"!))); \
	fi \
	&& \
	docker run \
		--name="$${name}.$$(date '+%Y%m%d%H%M%S')" \
		-v "$(WORKDIR):$${dkrhome}" \
		-p "$${port}:$${port}" \
		-d "$${label}"
	@message=$(strip $(call INFO,Start docker containers for development finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

docker-dev-stop: Dockerfile.dev
	@message=$(strip $(call INFO,Starting to stop docker containers for development ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@label=$(strip $(call PARSE_DOCKERFILE,$<)) \
	&& \
	if [ -n '$$(echo "$${label}" | grep "$(ERROR_PREFIX)")' ]; then \
		$(error \
			$(strip \
				$(call \
					ERROR,Invalid label of dockerfile "$<"! Error info: $$( \
						echo "$${label}" | sed -e 's/$(ERROR_PREFIX)//g' \
					) \
				) \
			) \
		); \
	fi \
	&& \
	name=$(firstword $(subst :,$(SPACE),$${label})) \
	&& \
	ctnrids=$$( \
		docker ps -a | egrep "$${name}" | awk '{print $$1}' \
	) \
	&& \
	if [ -z "$(strip $${ctnrids})" ]; then \
		message=$(strip $(call INFO,No docker containers for development to stop!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	else \
		echo "$${ctnrids}" | xargs docker stop; \
		message=$(strip \
			$(call \
				INFO,Docker containers $(subst $(SPACE),$(COMMA),$${ctnrids}) for development have been stopped! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Stop docker containers for development finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

docker-dev-remove-containers: Dockerfile.dev
	@message=$(strip $(call INFO,Starting to remove docker containers for development ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@label=$(strip $(call PARSE_DOCKERFILE,$<)) \
	&& \
	if [ -n '$$(echo "$${label}" | grep "$(ERROR_PREFIX)")' ]; then \
		$(error \
			$(strip \
				$(call \
					ERROR,Invalid label of dockerfile "$<"! Error info: $$( \
						echo "$${label}" | sed -e 's/$(ERROR_PREFIX)//g' \
					) \
				) \
			) \
		); \
	fi \
	&& \
	name=$(firstword $(subst :,$(SPACE),$${label})) \
	&& \
	ctnrids=$$( \
		docker ps -a | egrep "$${name}" | awk '{print $$1}' \
	) \
	&& \
	if [ -z "$(strip $${ctnrids})" ]; then \
		message=$(strip $(call INFO,No docker containers for development to remove!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	else \
		echo "$${ctnrids}" | xargs docker rm; \
		message=$(strip \
			$(call \
				INFO,Docker containers $(subst $(SPACE),$(COMMA),$${ctnrids}) for development have been removed! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Remove docker containers for development finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

docker-dev-remove-images: Dockerfile.dev docker-dev-stop docker-dev-remove-containers
	@message=$(strip $(call INFO,Starting to remove docker images for development ...)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi
	@label=$(strip $(call PARSE_DOCKERFILE,$<)) \
	&& \
	if [ -n '$$(echo "$${label}" | grep "$(ERROR_PREFIX)")' ]; then \
		$(error \
			$(strip \
				$(call \
					ERROR,Invalid label of dockerfile "$<"! Error info: $$( \
						echo "$${label}" | sed -e 's/$(ERROR_PREFIX)//g' \
					) \
				) \
			) \
		); \
	fi \
	&& \
	imageids=$$( \
		docker images | \
		egrep -v "IMAGE ID" | \
		awk '{print $$1":"$$2,$$3}' | \
		egrep "$${label}" | \
		awk '{print $$2}' \
	) \
	&& \
	if [ -z "$(strip $${imageids})" ]; then \
		message=$(strip $(call INFO,No docker images for development to remove!)); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi
	else \
		echo "$${imageids}" | xargs docker rmi; \
		message=$(strip \
			$(call \
				INFO,Docker images $(subst $(SPACE),$(COMMA),$${imageids}) for development have been removed! \
			) \
		); \
		if [ -n "$${message}" ]; then echo "$${message}"; fi; \
	fi
	@message=$(strip $(call INFO,Remove docker images for development finished!)); \
	if [ -n "$${message}" ]; then echo "$${message}"; fi

docker-stage: Dockerfile.stage docker-dev

docker-prod: Dockerfile.prod docker-dev

###############################################################################

help:
	$(info Available Targets:)
	@cat $(MAKEFILE_LIST) | \
		egrep -v ":=" | \
		egrep -v "^(\t+| +)" | \
		egrep -o "^.+:" | \
		egrep -v "^(#|\.)" | \
		sed -e "s/://g" -e "s/^/    /g"

###############################################################################

endif
