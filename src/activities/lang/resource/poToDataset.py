# -* coding: utf-8 -*-
#!/usr/bin/python3
#
# GCompris - po2Dataset.py
#
# SPDX-FileCopyrightText: 2019 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

import json
import polib
import sys

if len(sys.argv) != 3:
    print("Usage: po2Dataset.py po_file json_file")
    sys.exit(1)

poFile = polib.pofile(sys.argv[1], encoding='utf-8')
jsonFile = sys.argv[2]
data = {}

if poFile.percent_translated() < 40:
    print("Need at least 40% of the words translated to create the json data file for", jsonFile)
    sys.exit(0)
    
for entry in poFile.translated_entries():
    word = entry.msgctxt
    data[word] = entry.msgstr
for entry in poFile.untranslated_entries():
    word = entry.msgctxt
    data[word] = entry.msgstr
for entry in poFile.fuzzy_entries():
    word = entry.msgctxt
    data[word] = ""

with open(jsonFile, "w", encoding='utf-8') as data_file:
    json.dump(data, data_file, indent=4, sort_keys=True, ensure_ascii=False)
    data_file.write("\n") # Add missing new line at end of file
