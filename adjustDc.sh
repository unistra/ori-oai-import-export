#!/bin/bash

# Check args
if [ $# != 1 ]
then
    echo "Usage : bash adjustDc.sh memoire.xml"
    exit
fi

# Remove & chars
sed -i "s/&/-/g" $1
# Pretty XML for sed commands
xmllint -format $1 -output $1
# Truncate all <title> fields with 255 chars (because of database limitation)
sed -i "s/<dc:title>\(.\{255\}\).*<\/dc:title>/<dc:title>\1<\/dc:title>/g" $1
# Add CDATA for html chars
sed -i "s/\(&.*;\)/<\![CDATA[\1]]>/g" $1
# Replace fre by fr in language
sed -i "s/<dc:language>fre<\/dc:language>/<dc:language>fr<\/dc:language>/g" $1
# Replace PDF by application/pdf in format
sed -i "s/<dc:format>PDF<\/dc:format>/<dc:format>application\/pdf<\/dc:format>/g" $1
# Replace year in date by yyyy-06-30
sed -i "s/<dc:date>\(.\{4\}\)<\/dc:date>/<dc:date>\1-06-30<\/dc:date>/g" $1
