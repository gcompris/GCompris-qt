#!/usr/bin/python2
#
# GCompris - mergePo.py
#
# Copyright (C) 2017 Johnny Jazeix <jazeix@gmail.com>
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
#   along with this program; if not, see <http://www.gnu.org/licenses/>.

# Using polib.py from https://bitbucket.org/izi/polib/wiki/Home

# Usage : python2 mergePo.py qt.po gtk.po
# Find in the first argument po file the translated lines of the gtk po file
# (if existing) and replace the translation for the po file.
# For those not found, no translation is provided.

# something like: python2 mergePo.py gcompris_fi.po fi.po && sed '/^#|/ d' < gcompris_fi.po > qtgl.po && mv qtgl.po gcompris_fi.po

import polib
import re
import sys

if len(sys.argv) < 3:
    print('Usage : python mergePo.py gcompris_qt.po gcompris_gtk.po.'
          ' Output will be in the input file!')
    sys.exit(1)

# load an existing po file
po = polib.pofile(sys.argv[1])
poGtk = polib.pofile(sys.argv[2])

print(po.percent_translated())

# First remove all fuzzy strings
for entry in po.fuzzy_entries():
    entry.msgstr = ''
    if entry.msgid_plural: entry.msgstr_plural['0'] = ''
    if entry.msgid_plural and '1' in entry.msgstr_plural: entry.msgstr_plural['1'] = ''
    if entry.msgid_plural and '2' in entry.msgstr_plural: entry.msgstr_plural['2'] = ''
    entry.flags.remove('fuzzy')
    po.save()

# uncomment to create a new po
#for entry in po:
#    if entry.msgstr != "":
#        entry.msgstr = "";

#print(po.percent_translated())

# Then replace in the output all the good strings
for entry in po:
    if entry.msgstr != "":
        continue;

    for entryGtk in poGtk:
        if entry.msgid.encode('utf-8') == entryGtk.msgid.encode('utf-8') and entryGtk.msgstr != "":
            entry.msgstr = entryGtk.msgstr

po.save()

print(po.percent_translated())

