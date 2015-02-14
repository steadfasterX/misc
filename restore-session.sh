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
########################################################################################

# REPLACE THE FOLLOWING TO YOUR COPY OF DEX:
DEX=~/install/scripts/dex.py

######### C O D E ##################################################

GNOMEDIR=~/.config/gnome-session/saved-session
EXECDIR=~/.config/gnome-session/dex

logger -t "$0" "Gnome session restored started."
# check if we have a valid session dir
[ ! -d $GNOMEDIR ]&& logger -t "$0" "ABORTED execution because $GNOMEDIR does not exist. Do you have saved a Gnome session?" && exit

# setup env
rm -rf $EXECDIR
mkdir -p $EXECDIR

# take gnome saved session and copy it to working dir
find "$GNOMEDIR" -type f -name "*.desktop" -exec cp {} "$EXECDIR" \;
# made them executable so remove gnome junk
find "$EXECDIR" -type f -name "*.desktop" -exec sed -i 's/--sm-c.*//g' {} \; 

# restore the session
$DEX -a -s "$EXECDIR"

logger -t "$0" "Gnome session restored ended."
