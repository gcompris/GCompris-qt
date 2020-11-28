#!/usr/bin/python3
#
# GCompris - datasetToPo.py
#
# SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

import sys
import json
import os
import datetime
import polib
import urllib
from urllib.parse import quote

if(len(sys.argv) < 3):
    print("Usage: dataSetToPo.py dataset.json output.po [content-fr.json]")
    print("  The optional argument is used to backport manually created json")
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
if(len(sys.argv) == 4):
    manualData = loadManualFile(sys.argv[3])

dataset = sys.argv[1]
json_data = open(dataset)
data = json.load(json_data)
json_data.close()

displayInConsole = False

# Get last modification time of data set
modtime = os.path.getmtime(dataset)
modtime_utc = datetime.datetime.utcfromtimestamp(modtime)
modtime_utc_string = modtime_utc.strftime('%Y-%m-%d %H:%M') + '+0000'

# Header
po = polib.POFile()
po.metadata = {
    'Project-Id-Version': 'gcompris_qt\\n',
    'Report-Msgid-Bugs-To': 'https://bugs.kde.org/enter_bug.cgi?product=gcompris',
    'POT-Creation-Date': modtime_utc_string,
    'PO-Revision-Date': modtime_utc_string,
    'Last-Translator': 'FULL NAME <EMAIL@ADDRESS>\n',
    'Language-Team': 'LANGUAGE <kde-i18n-doc@kde.org>\n',
    'MIME-Version': '1.0',
    'Content-Type': 'text/plain; charset=utf-8',
    'Content-Transfer-Encoding': '8bit',
}

for chapter in data:
    for lesson in chapter['content']:
        for word in lesson['content']:
            voice = word['voice'].split('/')[-1].split(".")[0] + ".ogg"
            imageLink = "https://gcompris.net/incoming/lang/words_by_section.html#" + \
                       urllib.parse.quote(word['description'].split('/')[-1].split(".")[0])
            if displayInConsole:
                print("#. " + chapter['name'] + \
                      " / " + lesson['name'] + \
                      " / " + word['description'] + \
                      ": "+ imageLink)
                print('msgctxt "'+voice+'"|"')
                print('msgid "' + word['description'] + '"')
                print('msgstr "' + getManualTranslation(manualData, voice) + '"')
                print("")

            entry = polib.POEntry(
                msgid = word['description'],
                msgstr = getManualTranslation(manualData, voice),
                msgctxt = voice,
                comment = chapter['name'] + " / " + lesson['name'] + " / " + word['description'] +
                          "\n" + imageLink
            )
            po.append(entry)

po.save(sys.argv[2])
