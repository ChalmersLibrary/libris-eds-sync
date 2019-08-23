#!/bin/bash

DATE=$(date "+%Y%m%d")
OUTFILE="update.mrc"

# Load Variables
source settings

notify () {
    DATA='{"username":"eds-synk","channel":"#bibliotekssystem","text":"'
    DATA+=$1
    DATA+='"}'
    RESPONSE=$(curl -s -X POST -H 'Content-type: application/json' --data "$DATA" $SLACKURL)
    if [ "$RESPONSE" != "ok" ]; then
        echo "Slack notification failed"
    fi
}

# Start of script
echo "$DATE - Starting EDS update from Libris"

# Fetching update file from Libris
curl -s -o $OUTFILE $LIBRISURL$INFILE

if [ $? -eq 0 ]
then
    echo "Fetched $INFILE from LIBRIS"
else
    echo "Something went wrong with fetching file from LIBRIS"
    notify "$INFILE kunde inte hämtas från LIBRIS"
    exit
fi

# Send file to EDS
if [ -f $OUTFILE ]; then
  curl -s -n -T $OUTFILE $EDSURL
  if [ $? -eq 0 ]; then
    echo "$OUTFILE transfered to EDS"
  else
    echo "Something went wrong with file upload"
    notify "Misslyckades med att överföra $OUTFILE till EDS."
    exit
  fi
else 
  echo "No file found, probably empty at LIBRIS"
  notify "Hittade inte $OUTFILE vid överföring till EDS så förmodligen tom hos LIBRIS"
  exit
fi

# Everything went ok removing transfered file
echo "Update finished"
notify "$INFILE överförd till EDS."
rm $OUTFILE
