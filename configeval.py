import sys
from configparser import ConfigParser

conf = ConfigParser()
conf.read(sys.argv[1])

for s in conf.sections():
    if s == sys.argv[2]:
        for k, v in conf.items(s):
            if int(sys.version[2]) < 3:
                import pipes
                print("{}={}".format(k.upper(), pipes.quote(v)))
            else:
                import shlex
                print("{}={}".format(k.upper(), shlex.quote(v)))
