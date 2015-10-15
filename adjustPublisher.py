# -*- coding: utf8 -*-
from xml.dom.minidom import parse
import sys
import codecs

"""
Script to adjust pusblisher for ori oai

"""

# Check and get args
if len(sys.argv) != 4:
    sys.exit("Usage: python adjustPublisher.py composantes.xml memoires_tmp.xml memoire_final.xml")

filexml = str(sys.argv[1])
filememtmp = str(sys.argv[2])
filememfin = str(sys.argv[3])

# Open files
stream = codecs.open(filememtmp,'r','utf-8')
output = codecs.open(filememfin, 'w', 'utf-8')    

try:
    # Get composantes
    dom = parse(filexml)
    composantes  = {}
    if dom.getElementsByTagName('vdex:vdex'):
        for node in dom.getElementsByTagName('vdex:term'):
            code = node.getElementsByTagName('vdex:termIdentifier')[0].childNodes[0].nodeValue
            langstring = node.getElementsByTagName('vdex:caption')[0].getElementsByTagName('vdex:langstring')[0].childNodes[0].nodeValue
            composantes[code] = langstring

    # Write final memoires file    
    for line in stream:
        # For publisher
        if "<dc:publisher>" in line:
            for key in composantes:
                # Write line with new composante
                if "<dc:publisher>%s</dc:publisher>" % (composantes[key],) in line:
                    line = line.replace(composantes[key],key)
        
        # Write line
        output.write(line)

except Exception as e:
    print (e)
finally:
    stream.close()
    output.close()



