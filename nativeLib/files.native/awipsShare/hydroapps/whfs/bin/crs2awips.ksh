#!/bin/ksh
#
# crs2awips.ksh
#
# given CRS id, find best-fit awips 
# the input file contains 3 fields:
# 1) afos cccnnnxxx 2) wmo ttaaoo  3) awips cccc
# 
# Last Modified: 01/31/2002
#
export FILENAME=/awips2/edex/data/utility/common_static/base/afos2awips/afos2awips.txt

if [[ $1 = "" ]]
then
  echo NO_ID_GIVEN
  exit
fi

export CRS_ID=$1

CCCNNN=`echo $CRS_ID | cut -c1-6`
LINE=`grep "$CCCNNN" $FILENAME`


if [ -n "$LINE" ]
then
  CCCC=`echo $LINE | cut -f3 -d" " `
  NNNXXX=`echo $LINE | cut -c4-9 `
  AWIPSID=$CCCC$NNNXXX
  echo $AWIPSID
else
  echo NO_MATCH
fi
#