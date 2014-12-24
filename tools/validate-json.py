#!/usr/bin/python
import json
import sys

if len(sys.argv) != 2:
    print "Usage: validate-json.py json_file"
    sys.exit(1)

inf=sys.argv[1]

with open(inf) as data_file:
    try:
        data = json.load(data_file)
        print "Processing OK " + inf
    except ValueError as e:
        print dir(e)
        print "Processing KO " + inf
        print "Parser error: {0}".format(e.message)

