#!/bin/bash
########################################################################################
#
# This will restore the last saved gnome(3) session
#
# Copyright: 	Thomas Fischer, www.se-di.de
# License: 	CC BY-ND 4.0 (http://creativecommons.org/licenses/by-nd/4.0/)
#
# INSTALL:
#
# 1) Download DEX (https://github.com/jceb/dex) and change the DEX var in this script
# 2) Use "dconf write /org/gnome/gnome-session/auto-save-session-one-shot true"
#    (or "auto-save-session true" if you want to save EVERY session)
# 3) Open the apps you like
# 4) Open startup programs settings tool of Gnome and add the full path to this script
# 5) logout and enjoy your next login
#
# Force to re-read a saved gnome session or if you use the one-shot and want to change it:
# a) do step 2 + 3
# b) do: "rm -R ~/.config/gnome-session/dex/"
# c) do step 5
########################################################################################

# REPLACE THE FOLLOWING TO YOUR COPY OF DEX:
DEX=~/install/scripts/dex.py

######### C O D E ##################################################

ME="${0##*/}"
GNOMEDIR=~/.config/gnome-session/saved-session
EXECDIR=~/.config/gnome-session/dex

logger -t "$ME" "Gnome session restored started."
# check if we have a valid session dir
[ ! -d $GNOMEDIR ]&& logger -t "$0" "ABORTED execution because $GNOMEDIR does not exist. Do you have saved a Gnome session?" && exit

RESAVE=$(dconf read /org/gnome/gnome-session/auto-save-session)

# when the one-shot is true or when the DEX dir does not exists enforce the session copy
if [ ! -d $EXECDIR ]||[ ! "$(ls -A $EXECDIR)" ]||[ x$RESAVE == "xtrue" ];then
        logger -t "$ME" "Copy and prepare previous session.."
	# setup env
	[ -d $EXECDIR ] && rm -rf $EXECDIR
	mkdir -p $EXECDIR
	# take gnome saved session and copy it to working dir
	find "$GNOMEDIR" -type f -name "*.desktop" -exec cp {} "$EXECDIR" \;
	# made them executable so remove gnome junk
	find "$EXECDIR" -type f -name "*.desktop" -exec sed -i 's/--sm-c.*//g' {} \; 
	find "$EXECDIR" -type f -name "*.desktop" -exec sed -i 's/--session.*//g' {} \; 
else
	logger -t "$ME" "Using already prepared previous session.."
fi

# restore the session
logger -t "$ME" "$(find "$EXECDIR" -type f -name "*.desktop" -exec $DEX -v {} \;)"
#$DEX -a -s "$EXECDIR"

logger -t "$ME" "Gnome session restored ended."
