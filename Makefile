PREFIX ?= /usr/local/share
DESTDIR ?= $(PREFIX)/scripts
DIST_FILE_NAME = bash-common.sh
BINS = $(wildcard bin/*.sh)
CODE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DIST_DIR = dist
DIST_FILE = $(DIST_DIR)/$(DIST_FILE_NAME)
SHEBANG = '\#!/usr/bin/env bash'
INQUIRER = vendor/inquirer/dist/inquirer.sh
DISTS = $(wildcard dist/*.sh) 

default: install

build:
	$(eval TEMPFILE := $(shell mktemp -q $${TMPDIR:-/tmp}/inquirer.XXXXXX 2>/dev/null || mktemp -q))
	@# chmod from rw-------(default) to rwxrwxr-x, so that users can exec the scripts
	@chmod 775 $(TEMPFILE)
	@echo $(SHEBANG) >> $(TEMPFILE)
	@$(foreach BIN, $(BINS), \
		tail -n +2 $(BIN) >> $(TEMPFILE); \
	)
	@cp -f $(TEMPFILE) $(DIST_FILE)
	@git submodule update --remote
	@cp -f $(INQUIRER) $(DIST_DIR)/
install: 
	@mkdir -p $(DESTDIR)
	@echo "... installing $(DISTS) to $(DESTDIR)"
	@cp -f $(DISTS) $(DESTDIR)/
	@echo "For usage, you need to include 'source $(DESTDIR)/$(DIST_FILE_NAME)' in your shellscript."