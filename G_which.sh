#!/bin/sh
#
############################################################################
#
# MODULE:     G_which (GRASS-Shell-script)
# AUTHOR(S):  Original author unknown - probably CERL
#             Reinhard Brunzema - r.brunzema@web.de
# PURPUSE:    Replacement for which / Search $PATH for a certain command
#             Prints the command-path to stdout an returns 0 on success and
#             1 if the command could not be found.             	
# COPYRIGHT:  (C) 2001 by the GRASS Development Team
#
#             This program is free software under the GNU General Public
#             License (>=v2). Read the file COPYING that comes with GRASS
#             for details.
#
#############################################################################

# Search $PATH for a COMMAND
COMMAND=$1

	for i in `echo $PATH | sed 's/^:/.:/
    	    	    		    s/::/:.:/g
				    s/:$/:./
				    s/:/ /g'`
	do
	    if [ -f $i/$COMMAND ] ; then
   	 G_COMMAND="$i"/"$COMMAND"
		break
	    fi
	done

	# Check if wish was found
	if [ "$G_COMMAND" ] ; then
	SUCCESS=0
	else
	SUCCESS=1
	fi

# Return the result:
echo $G_COMMAND
exit $SUCCESS
	