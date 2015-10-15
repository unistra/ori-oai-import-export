#!/bin/bash

# Launch this script to import dc files into ori oai
 
# Check args
if [ $# != 2 ]
then
    echo "Usage : bash go.sh config.ini records_file.iso"
    exit
fi

# Import config.ini
CONFIG_FILE=$1
RECORDS_FILE=$2
SECTION=go
eval `python3 configeval.py $CONFIG_FILE $SECTION`

# Start msg
echo "Start import "`date`

# Create the work folder 
[[ -d work ]] || mkdir work

# Create the dc file with marcmir
perl -Iunistroai/lib/ convertMarcToDc.pl \
    $RECORDS_FILE "$FILTRE" \
    > ./work/$MEMOIRES_TMP
    echo ./work/$MEMOIRES_TMP

# Test if the file is empty
if [ -s ./work/$MEMOIRES_TMP ]
then
   echo "Ajust"
# Adjust DiC
    bash adjustDc.sh ./work/$MEMOIRES_TMP
# Remove Chars SUDOC
    python3 adjustCharMarc.py ./work/$MEMOIRES_TMP
# Adjust Publisher
    wget $URL_COMPOSANTES_VOCAB -O ./work/$COMPOSANTES -o /dev/null
    python3 adjustPublisher.py ./work/$COMPOSANTES ./work/$MEMOIRES_TMP ./work/$MEMOIRES_FINAL

    # Import into workflow
    python3 importFileToWorkflow.py ./$CONFIG_FILE ./work/$MEMOIRES_FINAL
fi

# Remove work folder
rm -R work
