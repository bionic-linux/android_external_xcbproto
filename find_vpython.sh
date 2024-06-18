#!/bin/sh
# Find a python instance matching the version requirement, if any.
#
# Env: PYTHON is taken if defined, but verified against requested
# version.
#
usage="$0 [ {'<' | '<=' | '==' | '>=' | '>'} major [minor [micro]]"

# Success: exits with 0 and returns on stdout pathname and subdir for
# third parties modules separated by a semi-colon ';', with a trailing
# ';' and whatever newline combination is returned; the instance
# retained is the highest matching version (if not desired,
# set env PYTHON with path of wanted # instance).
#
# If PYTHONVER is set, PYTHONVER is used to # generate the subdir
# returned and PYTHON is not tested for (this does mean that the
# definition of env PYTHON variable is returned as is).
#
# Failure: returns nothing on stdout (may print error message on
# stderr) and set exit status to 1 for syntax error, 2 for no
# matching version found in PATH.
#
# Copyright 2024 Thierry LARONDE <tlaronde@kergis.com>
# SPDX-License-Identifier: MIT
#
# Note: the utility is written in order to protect from setting -eu.
#

: ${PYTHON:=}
: ${PYTHONVER:=}

# Subr
cknum()
{
	test -z "$(echo $1 | sed 's/[0-9]*//')" || {
		echo "'$1' is an incorrect number" >&2
		exit 1
	}
}

ckver()
{
	_major=$($1 -c "import sys; print(sys.version_info[0])")
	test "$_major" || {
		echo "'$1' is incorrect python interpreter" >&2
		return
	}
	_version=$(($_major * 1000 * 1000))
	_minor=$($1 -c "import sys; print(sys.version_info[1])")
	_micro=$($1 -c "import sys; print(sys.version_info[2])")
	if test $nfig -ge 2; then
		_version=$(($_version + $_minor * 1000))
	fi
	if test $nfig -eq 3; then
		_version=$(($_version + $_micro))
	fi

	if test $nfig -gt 0; then
		eval test "$_version" "-$test_op" "$sversion" || return
	fi

	# Here, this instance is tentatively retained. Greatest?
	if test "$_version" -gt "$bversion"; then
		PYTHON="$1"
		bversion=$_version
		dversion=$_major.$_minor
	fi
}

test $# -eq 0 || { test $# -ge 2 && test $# -le 4; } \
	|| { echo "$usage" >&2; exit 1; }

nfig=0	# maybe no version asked for
if test $# -ge 2; then
	case $1 in
		"<") test_op="lt";;
		"<=") test_op="le";;
		"==") test_op="eq";;
		">=") test_op="ge";;
		">") test_op="gt";;
		*) echo "Incorrect condop '$condop'" >&2
		  echo "$usage" >&2
		  exit 1;;
	esac
	shift
	cknum $1
	sversion=$(($1 * 1000 * 1000))
	nfig=$#
	shift
	if test $# -ge 1; then
		cknum $1
		sversion=$(($sversion + $1 * 1000))
		shift
		if test $# -eq 1; then
			cknum $1
			sversion=$(($sversion + $1))
		fi
	fi
fi

# The bversion is for the current "best" version i.e. greatest matching
# version.
#
bversion=0

candidates=
if test "${PYTHONVER:-}"; then
	dversion="$PYTHONVER"
elif test -z "${PYTHON:-}"; then
	# search PATH for all possible python interpreters
	#
	# !!! We are expecting Unix like syntax including under
	# MSWIN/cygwin or msys*.
	#
	for p in $(echo $PATH | sed 'y/:/ /'); do
		these=$({ cd $p 2>/dev/null && { ls | grep '^python[0-9.]*$'; } 2>/dev/null; } || true)
		if test "$these"; then
			for c in $these; do
				candidates="$candidates $p/$c"
			done
		fi
	done
else #
	candidates="$PYTHON"
fi

if test "${candidates:-}"; then
	for candidate in $candidates; do
		ckver $candidate
	done
fi

if test "${PYTHON:-}" || test "${PYTHONVER:-}"; then
	echo "$PYTHON;lib/python$dversion/site-packages;"
	exit 0
else
	exit 2
fi
