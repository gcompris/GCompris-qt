#!/usr/bin/python

import sys
import json
import os
import datetime

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
        return ""
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

# Get last modification time of data set
modtime = os.path.getmtime(dataset)
modtime_utc = datetime.datetime.utcfromtimestamp(modtime)
modtime_utc_string = modtime_utc.strftime('%Y-%m-%d %H:%M') + '+0000'

# Header
print 'msgid ""'
print 'msgstr ""'
print '"Project-Id-Version: gcompris_qt\\n"'
print '"POT-Creation-Date: ' + modtime_utc_string + '\\n"'
print '"MIME-Version: 1.0\\n"'
print '"Content-Type: text/plain; charset=UTF-8\\n"'
print '"Content-Transfer-Encoding: 8bit\\n"'
print ''

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
            print 'msgctxt "LangWords|"'
            print 'msgid "' + word['description'] + '"'
            print 'msgstr "' + getManualTranslation(manualData, word['voice']).encode('utf-8') + '"'
            print ""
