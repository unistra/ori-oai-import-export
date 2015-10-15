#!/bin/bash

# Script for the crontab

SCRIPT_FOLDER=/home/expapogee/import_sudoc
ORI_FILE=ORI-`date +"%Y%m%d"`.ISO
SUDOC_FILES_FOLDER=/home/expapogee/SUDOC_FILES

# Go in the script folder
cd $SCRIPT_FOLDER
# Copy daily file
scp sgc@ex-libris.u-strasbg.fr:/home1/user/sgc/ORI/$ORI_FILE $SUDOC_FILES_FOLDER
# If daily file exist
if [ -f "$SUDOC_FILES_FOLDER/$ORI_FILE" ]
then
	# Import memoires
	bash go.sh config_memoires.ini $SUDOC_FILES_FOLDER/$ORI_FILE
	# Import Hdr
	bash go.sh config_hdr.ini $SUDOC_FILES_FOLDER/$ORI_FILE
	# Import texercice
	bash go.sh config_texercice.ini $SUDOC_FILES_FOLDER/$ORI_FILE
fi


