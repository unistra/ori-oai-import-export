#!/usr/bin/python
import sys, os
docDC = sys.argv[1]

with open (docDC,'r') as entree:
    chaine = entree.read()
    for ch in ['\x9c','\x91','\x92','\x93','\x94','\x95','\x98','\x9a','\x85','\x9c']:
        if ch in chaine:
            chaine=chaine.replace(ch,'')
    print (chaine)

with open (docDC,'w') as entree:
    entree.write(chaine)  
