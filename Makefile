# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright 2018 Mateusz Piotrowski <0mp@FreeBSD.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

PREFIX = /usr/local
BASHCOMPLETIONDIR = ${DESTDIR}${PREFIX}/etc/bash_completion.d
BINDIR = ${DESTDIR}${PREFIX}/bin
LIBDIR = ${DESTDIR}${PREFIX}/share/goat
MANDIR = ${DESTDIR}${PREFIX}/man
MAN1DIR = ${MANDIR}/man1

GOAT_BASH_COMPLETION = ./goat-completion.bash
GOAT_MANPAGE = ./goat.1
GOAT_MANPAGE_SOURCE = ./goat.1.in
GOAT_MINGW_LN = ./mingw_ln.bat
GOAT_LIB = ./libgoat.sh
GOAT_SCRIPT = ./goat
GOAT_SCRIPT_SOURCE = ./goat.in

.PHONY: build
build: ${GOAT_MANPAGE} ${GOAT_SCRIPT}

${GOAT_MANPAGE}: ${GOAT_MANPAGE_SOURCE}
	awk -v libdir="${LIBDIR}" \
	    '{sub("%%LIBDIR%%", libdir); print $0}' \
	    ${GOAT_MANPAGE_SOURCE} > ${GOAT_MANPAGE}

${GOAT_SCRIPT}: ${GOAT_SCRIPT_SOURCE}
	awk -v libdir="${LIBDIR}" \
	    '{sub("%%LIBDIR%%", libdir); print $0}' \
	    ${GOAT_SCRIPT_SOURCE} > ${GOAT_SCRIPT}

.PHONY: install
install: build
	mkdir -p ${BINDIR}
	install -m 0555 ${GOAT_SCRIPT} ${BINDIR}/

	mkdir -p ${LIBDIR}
	install -m 0444 ${GOAT_LIB} ${LIBDIR}/

	mkdir -p ${MAN1DIR}
	install -m 0444 ${GOAT_MANPAGE} ${MAN1DIR}/

	mkdir -p ${BASHCOMPLETIONDIR}
	install -m 0444 ${GOAT_BASH_COMPLETION} ${BASHCOMPLETIONDIR}/

	@echo "========================================================"
	@echo "Now in order to finish setting up goat add:"
	@echo ""
	@echo "    . \"${LIBDIR}/libgoat.sh\""
	@echo ""
	@echo "to your shell initialization file (e.g. \"~/.bashrc\")."
	@echo ""
	@echo "Goat is going to be available the next time you start your shell."

.PHONY: install-mingw
install-mingw: install
	mkdir -p ${LIBDIR}
	install -m 0555 ${GOAT_LIB} ${LIBDIR}/

.PHONY: clean
clean:
	@-rm -f -- goat goat.1
