GOAT_PATH="${GOAT_PATH:-"$HOME/.goat"}"

cd()
{
	if [ $# -eq 0 ]
	then
		command cd
	elif [ $# -gt 1 ]
	then
		command cd "$@"
	elif [ x"$(printf '%s' "$1" | tr -d '.')" = x ]
	then
		if [ x"$1" = x. ] || [ x"$1" = x.. ]
		then
			command cd "$1"
		else
			set -- "${1##\.\.\.}" "../../"
			while [ x"$1" != x ]
			do
				set -- "${1##\.}" "$2../"
			done
			command cd "$2"
		fi
	else
		CDPATH="${CDPATH:-.}:$GOAT_PATH" \
		    command cd -P -- "$1" 1>/dev/null
	fi
}

# vim: filetype=sh softtabstop=8 shiftwidth=8 tabstop=8 noexpandtab
