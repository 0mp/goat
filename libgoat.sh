# libgoat.sh - A library to source to enable goat links when using cd.
#
# ---
#
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright 2017-2019 Mateusz Piotrowski <0mp@FreeBSD.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

: "${GOAT_PATH:="${XDG_CONFIG_HOME:-"$HOME/.config"}/goat"}"

cd()
{

	if [ $# -ne 1 ]
	then
		command cd "$@"
	elif expr "$1" : "^[.][.]*$" 1>/dev/null
	then
		if [ "$1" = "." ] || [ "$1" = ".." ]
		then
			command cd "$1"
		else
			set -- "${1##...}" "../../"
			while [ x"$1" != x ]
			do
				set -- "${1##.}" "$2../"
			done
			command cd "$2"
		fi
	else
		CDPATH="${CDPATH:-.}:$GOAT_PATH" \
		    command cd -P -- "$1" 1>/dev/null
	fi
}

# vim: filetype=sh softtabstop=8 shiftwidth=8 tabstop=8 noexpandtab
