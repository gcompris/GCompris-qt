# -* coding: utf-8 -*-
#!/usr/bin/python3
#
# GCompris - po2Dataset.py
#
# Copyright (C) 2019 Johnny Jazeix <jazeix@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, see <https://www.gnu.org/licenses/>.

import json
import polib
import sys
import urllib

from urllib.parse import unquote

if len(sys.argv) != 3:
    print("Usage: po2Dataset.py po_file json_file")
    sys.exit(1)

poFile = polib.pofile(sys.argv[1], encoding='utf-8')
jsonFile = sys.argv[2]
data = {}

if poFile.percent_translated() < 40:
    print("Need at least 40% of the words translated to create the json data file")
    sys.exit(0)
    
for entry in poFile.translated_entries():
    word = entry.msgctxt
    data[word] = entry.msgstr

with open(jsonFile, "w", encoding='utf-8') as data_file:
    json.dump(data, data_file, indent=4, sort_keys=True, ensure_ascii=False)
    data_file.write("\n") # Add missing new line at end of file
