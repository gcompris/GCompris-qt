#!/usr/bin/python3
#
# GCompris - l10n-fetch-po-files.py
#
# SPDX-FileCopyrightText: 2015 Trijita org <jktjkt@trojita.org>
#
#   SPDX-License-Identifier: GPL-3.0-or-later
import os
import re
import subprocess

# Copied from Trojita
"""Fetch the .po files from KDE's SVN for GCompris

Run me from GCompris's top-level directory.
"""


SVN_PATH = "svn://anonsvn.kde.org/home/kde/branches/stable/l10n-kf5/"
SOURCE_PO_PATH = "/messages/gcompris/gcompris_qt.po"
OUTPUT_PO_PATH = "./po/%s/"
OUTPUT_PO_FILE = "gcompris_qt.po"

fixer = re.compile(r'^#~\| ', re.MULTILINE)
re_empty_msgid = re.compile('^msgid ""$', re.MULTILINE)
re_empty_line = re.compile('^$', re.MULTILINE)
re_has_qt_contexts = re.compile('X-Qt-Contexts: true\\n')

all_languages = subprocess.check_output(['svn', 'cat', SVN_PATH + 'subdirs'],
                                       stderr=subprocess.STDOUT)

all_languages = [x.strip() for x in all_languages.decode().split("\n") if len(x)]
all_languages.remove("x-test")
for lang in all_languages:
    try:
        raw_data = subprocess.check_output(['svn', 'cat', SVN_PATH + lang + SOURCE_PO_PATH],
                                          stderr=subprocess.PIPE)
        (transformed, subs) = fixer.subn('# ~| ', raw_data.decode())
        pos1 = re_empty_msgid.search(transformed).start()
        pos2 = re_empty_line.search(transformed).start()
        if re_has_qt_contexts.search(transformed, pos1, pos2) is None:
            transformed = transformed[:pos2] + \
                    '"X-Qt-Contexts: true\\n"\n' + \
                    transformed[pos2:]
            subs = subs + 1
        if (subs > 0):
            print("Fetched %s (and performed %d cleanups)" % (lang, subs))
        else:
            print("Fetched %s" % lang)
            
        output_path = OUTPUT_PO_PATH % lang;
        if not os.path.exists(output_path):
            os.makedirs(output_path)

        out_file = open(output_path + OUTPUT_PO_FILE, "wb")
        out_file.write(transformed.encode())
    except subprocess.CalledProcessError:
        print ("No data for %s" % lang)

# Inform qmake about the updated file list
#os.utime("CMakeLists.txt", None)

