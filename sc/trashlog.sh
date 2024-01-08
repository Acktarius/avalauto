#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  launch log trasher
##################################################################

wdir="/opt/avalauto"

cd $wdir
source avalauto.sh --clearlog || zenity --error --timeout=12 --text="an error was encountered";

exit
