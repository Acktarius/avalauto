#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  launcher
##################################################################

wdir="/opt/avalauto"

cd $wdir
source avalauto.sh || zenity --error --timeout=12 --text="an error was encountered";
