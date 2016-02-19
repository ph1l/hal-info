## Process this file with automake to produce Makefile.in

SUBDIRS = fdi tools

MAINTAINERCLEANFILES = ChangeLog

# Creating ChangeLog from git log (taken from cairo/Makefile.am):

ChangeLog: $(srcdir)/ChangeLog

$(srcdir)/ChangeLog:
	@if test -d "$(srcdir)/.git"; then \
	  (cd "$(srcdir)" && \
	  ./missing --run git-log --stat) | fmt --split-only > $@.tmp \
	  && mv -f $@.tmp $@ \
	  || ($(RM) $@.tmp; \
	      echo Failed to generate ChangeLog, your ChangeLog may be outdated >&2; \
	      (test -f $@ || echo git-log is required to generate this file >> $@)); \
	else \
	  test -f $@ || \
	  (echo A git checkout and git-log is required to generate ChangeLog >&2 && \
	  echo A git checkout and git-log is required to generate this file >> $@); \
	fi

.PHONY: ChangeLog $(srcdir)/ChangeLog

DISTCLEANFILES =

EXTRA_DIST = HACKING ChangeLog

clean-local :
	rm -f *~

release:
	@echo "-----------------------------------------------------------------"
	@echo "First check that all your changes are committed and pushed to"
	@echo "the remote master repository."
	@echo ""
	@echo "Then run 'make release-real' for instructions on how to make a release."
	@echo "-----------------------------------------------------------------"

release-real:
	@echo "-----------------------------------------------------------------"
	@echo "Run the commands below, one by one"
	@echo "-----------------------------------------------------------------"
	@echo "-----------------------------------------------------------------"
	@echo "export HAL_INFO_VERSION=`date +%Y%m%d`"
	@echo "make check"
	@echo "echo \$$HAL_INFO_VERSION > VERSION"
	@echo "rm -rf autom4te.cache"
	@echo "autoreconf"
	@echo "make dist"
	@echo "scp hal-info-\$$HAL_INFO_VERSION.tar.gz hal.freedesktop.org:/srv/hal.freedesktop.org/www/releases"
	@echo "git commit -a -m \"Released hal-info \$$HAL_INFO_VERSION\""
	@echo "git push"
	@echo "git tag -m \"Released hal-info \$$HAL_INFO_VERSION\" -s HAL_INFO_\$$HAL_INFO_VERSION"
	@echo "git push --tags"
	@echo "-----------------------------------------------------------------"
	@echo "-----------------------------------------------------------------"
	@echo ""
	@echo "Please send a note to hal@lists.freedesktop.org about this release."
	@echo "-----------------------------------------------------------------"




