#!/bin/sh
# Compile with the python interpreter whose pathname is given, the
# python module in the directory (no recursion) given. An option
# third parameter is the level of optimization: 0, 1 or 2.
#
# DESTDIR is in the environment; the directory is given absolulety
# except for the DESTDIR prefix.
#
# SOURCE_DATE_EPOCH is set in the environment and is used internally by
# Python compilation module in order to _not_ test datetime for
# compiled vs. source checking---using hash instead.
#
# Copyright 2024 Thierry LARONDE <tlaronde@kergis.com>
# SPDX-License-Identifier: MIT
#
usage="$0 python_interpreter_pathname python_module_dir [0|1|2 [0|1|2 [0|1-2]]]
	env:
		- DESTDIR 
		- SOURCE_DATE_EPOCH is used by Python if set
"

{ test $# -ge 2 && test $# -le 5; } || { echo "$usage" >&2; exit 1; }

test "${2#/}" != "$2" || {
	echo "The python_module_dir shall be an absolute path" >&2
	echo "$usage" >&2
	exit 1;
}


test -z "${DESTDIR:-}" || DESTDIR="${DESTDIR%/}"

python="$1"
shift
pythondir="$1"
shift

do0=NO
do1=NO
do2=NO
while test $# -ne 0; do
	case $1 in
		0|1|2) eval do$1=YES;;
		*) echo "Incorrect optimization level '$1'" >&2
		  exit 1;;
	esac
	shift
done

{
	echo "import py_compile"
	for file in `find "${DESTDIR}$pythondir" -type f -maxdepth 1 -name "*.py"`; do
		if test "$do0" = YES; then
			echo "py_compile.compile('$file', None, '${file#$DESTDIR}', False, 0)"
		fi
		if test "$do1" = YES; then
			echo "py_compile.compile('$file', None, '${file#$DESTDIR}', False, 1)"
		fi
		if test "$do2" = YES; then
			echo "py_compile.compile('$file', None, '${file#$DESTDIR}', False, 2)"
		fi
	done
}\
	| "$python"

