#!/usr/bin/python

import sys
import json

if(len(sys.argv) < 2):
    print "Usage: dataSetToPo.py dataset.json [content-fr.json]"
    print "  The optional argument is used to backport manually created json"
    sys.exit(1)

def loadManualFile(manual):
    json_data = open(manual)
    manualData = json.load(json_data)
    json_data.close()
    return manualData
    
def getManualTranslation(manualData, key):
    if not manualData:
        return
    key = key.split("/")[-1]
    try:
        return manualData[key]
    except:
        return ""

manualData = None
if(len(sys.argv) == 3):
    manualData = loadManualFile(sys.argv[2])


dataset = sys.argv[1]
json_data = open(dataset)
data = json.load(json_data)
json_data.close()

for chapter in data:
    for lesson in chapter['content']:
        for word in lesson['content']:
            print "#. " + chapter['name'] + \
                " / " + lesson['name'] + \
                " / " + word['description'] + \
                ": http://gcompris.net/incoming/lang/words.html#" + \
                word['image'].split('/')[-1].split(".")[0]
            print "#: " + "http://gcompris.net/incoming/lang/words.html#" + \
                word['image'].split('/')[-1].split(".")[0]
            print 'msgid "' + word['description'] + '"'
            print 'msgstr "' + getManualTranslation(manualData, word['voice']).encode('utf-8') + '"'
            print ""
