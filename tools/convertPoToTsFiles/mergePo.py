#!/usr/bin/python3
#
# GCompris - mergePo.py
#
# SPDX-FileCopyrightText: 2017 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

# Using polib.py from https://bitbucket.org/izi/polib/wiki/Home

# Usage : python3 mergePo.py qt.po gtk.po
# Find in the first argument po file the translated lines of the gtk po file
# (if existing) and replace the translation for the po file.
# For those not found, no translation is provided.

# something like: python3 mergePo.py gcompris_fi.po fi.po && sed '/^#|/ d' < gcompris_fi.po > qtgl.po && mv qtgl.po gcompris_fi.po

import sys
import polib

if len(sys.argv) < 3:
    print('Usage : python3 mergePo.py gcompris_qt.po gcompris_gtk.po.'
          ' Output will be in the input file!')
    sys.exit(1)

# load an existing po file
po = polib.pofile(sys.argv[1])
poGtk = polib.pofile(sys.argv[2])

print(po.percent_translated())

# First remove all fuzzy strings
for entry in po.fuzzy_entries():
    entry.msgstr = ''
    if entry.msgid_plural:
        entry.msgstr_plural['0'] = ''
    if entry.msgid_plural and '1' in entry.msgstr_plural:
        entry.msgstr_plural['1'] = ''
    if entry.msgid_plural and '2' in entry.msgstr_plural:
        entry.msgstr_plural['2'] = ''
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
        continue

    for entryGtk in poGtk:
        if entry.msgid.encode('utf-8') == entryGtk.msgid.encode('utf-8') and entryGtk.msgstr != "":
            entry.msgstr = entryGtk.msgstr

po.save()

print(po.percent_translated())
