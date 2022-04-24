export site_loc=op

if [ -z $DOFETCH ]; then export DOFETCH=1; fi
if [ -z $DOBUILD ]; then export DOBUILD=1; fi
if [ -z $DOSERVE ]; then export DOSERVE=1; fi
