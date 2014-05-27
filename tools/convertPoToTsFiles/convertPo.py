#!/usr/bin/python
# Using polib.py from https://bitbucket.org/izi/polib/wiki/Home

# Usage : python convertPo.py input1.po input2.ts output.ts
# Find in the first argument po file the translated lines of the ts file
# (if existing) and replace the translation for the ts file.
# For those not found, no translation is provided.

import polib
import re
import sys
import xml.etree.ElementTree as ET

if len(sys.argv) < 4:
    print('Usage : python convertPo.py gcompris_gtk.po gcompris_qt_template.ts $LOCALE.'
          ' Output will be gcompris_$LOCALE.ts ($LOCALE is fr_FR for example).')
    sys.exit(1)

# load an existing po file
po = polib.pofile(sys.argv[1])
tree = ET.parse(sys.argv[2])
root = tree.getroot()

# Change the language in the xml file
root.set('language', sys.argv[3])

for messages in root.iter('message'):
    original = messages.find('source').text
    if original != None:
        for entry in po:
            if entry.msgid.encode('utf-8') == original.encode('utf-8') and \
                    'type' in messages.find('translation').attrib and \
                    messages.find('translation').attrib['type'] == 'unfinished':
                messages.find('translation').text = entry.msgstr
                try:
                    messages.find('translation').attrib.pop('type')
                except:
                    pass
                break

with open('gcompris_' + sys.argv[3] + '.ts', 'wb') as f:
    f.write('<?xml version="1.0" encoding="utf-8" ?>\n<!DOCTYPE TS>\n'.encode('utf-8'))
    tree.write(f, 'utf-8')
# tree.write('gcompris_' + sys.argv[3] + '.ts', 'utf-8');

