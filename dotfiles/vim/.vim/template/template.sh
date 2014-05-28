:% s/DATE/\=strftime('%Y.%m.%d')/ge
:% s/YEAR/\=strftime('%Y')/ge
:if search('<+CURSOR+>')
:  normal! "_da>
:endif
:finish
#!/bin/bash -e
#
# Created: DATE
# Copyright: Steven E. Pav, YEAR
# Author: Steven E. Pav
# Comments: Steven E. Pav

<+CURSOR+>

COMPRESS_LEVEL=0
VERBOSE=""

HELP_STRING="$0 [-v] [-Z zlev]";
while getopts "Z:vh" flag
do
	case "$flag" in
		(h) echo "$HELP_STRING foo";
			  exit 0;;
		(Z) COMPRESS_LEVEL=$OPTARG;;
		(v) VERBOSE='--verbose';;
	esac
done

shift $((OPTIND-1))

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=sh:ft=sh:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
