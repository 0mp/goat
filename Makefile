# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright 2018, 2019 Mateusz Piotrowski <0mp@FreeBSD.org>
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

DESTDIR?=
PREFIX?=	${HOME}/.local
VERSION!=	if [ -z "$$VERSION" ]; then \
			git describe --tags; \
		fi

BASHCOMPDIR=		${PREFIX}/share/bash-completion
BINDIR=			${PREFIX}/bin
SHAREDIR=		${PREFIX}/share/goat
MANDIR=			${PREFIX}/share/man/man1
DESTBASHCOMPDIR=	${DESTDIR}${BASHCOMPDIR}
DESTBINDIR=		${DESTDIR}${BINDIR}
DESTSHAREDIR=		${DESTDIR}${SHAREDIR}
DESTMANDIR=		${DESTDIR}${MANDIR}

GOAT_MANPAGE_SOURCE=	src/${GOAT_MANPAGE}.in
GOAT_SCRIPT_SOURCE=	src/${GOAT_SCRIPT}.in

GOAT_BASH_COMPLETION=	src/goat-completion.bash
GOAT_LIB=		src/libgoat.sh
GOAT_MANPAGE=		goat.1
GOAT_SCRIPT=		goat
GOAT_MAKEFILE=		Makefile

.PHONY: all
all: ${GOAT_MANPAGE} ${GOAT_SCRIPT}

${GOAT_MANPAGE}: ${GOAT_MANPAGE_SOURCE} ${GOAT_MAKEFILE}
	@sed "s,%%SHAREDIR%%,${SHAREDIR}," ${GOAT_MANPAGE_SOURCE} > ${GOAT_MANPAGE}

${GOAT_SCRIPT}: ${GOAT_SCRIPT_SOURCE} ${GOAT_MAKEFILE}
	@sed    -e "s,%%VERSION%%,${VERSION}," \
		-e "s,%%SHAREDIR%%,${SHAREDIR}," \
		${GOAT_SCRIPT_SOURCE} > ${GOAT_SCRIPT}

.PHONY: install
install: ${GOAT_MANPAGE} ${GOAT_SCRIPT}
	@mkdir -p ${DESTBINDIR}
	install -m 0555 ${GOAT_SCRIPT} ${DESTBINDIR}

	@mkdir -p ${DESTSHAREDIR}
	install -m 0444 ${GOAT_LIB} ${DESTSHAREDIR}

	@mkdir -p ${DESTMANDIR}
	install -m 0444 ${GOAT_MANPAGE} ${DESTMANDIR}

	@mkdir -p ${DESTBASHCOMPDIR}
	install -m 0444 ${GOAT_BASH_COMPLETION} ${DESTBASHCOMPDIR}

	@echo "========================================================"
	@echo "Now in order to finish setting up goat add:"
	@echo ""
	@echo "    . \"\$$(goat libexec)\""
	@echo ""
	@echo "to your shell initialization file (e.g., \"~/.bashrc\")."
	@echo ""
	@echo "Goat is going to be available the next time you start your shell."

.PHONY: lint
lint: ${GOAT_MANPAGE} ${GOAT_SCRIPT}
	shellcheck --shell=bash ${GOAT_BASH_COMPLETION}

	shellcheck --shell=sh ${GOAT_LIB}
	checkbashisms -npfx ${GOAT_LIB}

	shellcheck --shell=sh ${GOAT_SCRIPT}
	checkbashisms -npfx ${GOAT_SCRIPT}

.PHONY: test
test: Kyuafile test.sh
	env -i kyua test || env -i kyua report --verbose

.PHONY: clean
clean:
	@-rm -f -- goat goat.1
