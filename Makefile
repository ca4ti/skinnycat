#
# Makefile
#
# PROJECT:      skinnycat
# DESCRIPTION:  Small shell utility providing basic Skinny Cisco
#               protocol messages exchange
#
# Copyright (C) 2016 Stas Kobzat <stas@modulis.ca>
#
# TARGETS:
#   all			-- build project
#   test		-- run unit tests with cmocka and functional tests with dejagnu
#   ctags		-- generate ctags for vim
#   doc			-- generate documentation with doxygen
#   cov			-- generate tests coverage report
#   clean		-- clean up

PROJECT   :=  skinnycat
PKG_CFG   :=  $(shell which pkg-config)
TARGET    := bin/$(PROJECT)
BUILDDIR  := build
SRCDIR    := src
DOCS      := doc

ifndef PKG_CFG
  $(error Not found pkg-config utility.\
          Install pkg-config package before continue)
endif

include src/Makefile

include tests/Makefile

.PHONY: doc
doc:
	@doxygen $(DOCS)/Doxygen
	@echo "Documentation generated."

.PHONY: ctags
# generate ctags for vim
# requires apr-1 source in root
ctags:
	@echo "Building tags"
	@test ! -d apr-1.5.2 && \
		wget http://apache.mirror.iweb.ca//apr/apr-1.5.2.tar.gz && \
		tar xfz apr-1.5.2.tar.gz && rm apr-1.5.2.tar.gz; :
	@ctags -R src apr-1.5.2 2> /dev/null

.PHONY: clean
clean: test_clean
	@echo Clean built objects
	@rm -f $(BUILDDIR)/*.o $(TARGET)
	@echo Clean documentation
	@rm -rf $(DOCS)/html
	@echo Clean test coverage reports
	@rm -rf cov/*

