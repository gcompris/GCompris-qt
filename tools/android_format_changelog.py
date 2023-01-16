#!/usr/bin/python3
#
# GCompris - android_format_changelog.py
#
# SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

import sys

from PyQt5.QtCore import QCoreApplication, QUrl
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine
import polib
import os
import re
import glob

from python.ActivityInfo import ActivityInfo

if len(sys.argv) < 2:
  print("Usage: check_voices.py <version> [-v]")
  sys.exit(1)

version = sys.argv[1]
verbose = True if len(sys.argv) >= 3 and sys.argv[2] == "-v" else False;

def generate_for_locale(changelog_qml, locale):
  gcomprisLocale = locale.replace("-", "_");

  if gcomprisLocale == "iw_IL": # android still uses the old iw iso code for Hebrew in their file
    gcomprisLocale = "he_IL";
  # We use polib to translate as QTranslator only handles .qm files and we don't need to have GCompris compiled to generate this file
  translationFilePath = 'poqm/'+gcomprisLocale+'/gcompris_qt.po';
  if not os.path.isfile(translationFilePath):
    # Short locale
    gcomprisLocale = gcomprisLocale[0:gcomprisLocale.find("_")];
    translationFilePath = 'poqm/'+gcomprisLocale+'/gcompris_qt.po';
    if not os.path.isfile(translationFilePath):
      if verbose:
        print("Locale %s [%s] not handled, skip it" % (locale, gcomprisLocale));
      return False, "";
  if verbose:
    print("Generate for locale %s [%s]" % (locale, gcomprisLocale));
  po = polib.pofile(translationFilePath)

  output = "<%s>\n" % locale;

  # Get new activities for this version
  # With regex for each ActivityInfo.qml, no need to use Qt there
  for activityInfo in glob.glob('src/activities/*/ActivityInfo.qml'):
    try:
      if activityInfo.find("template") != -1:
        continue;
      with open(activityInfo) as f:
        content = f.readlines()
        title = ""
        for line in content:
          titleMatch = re.match('.*title:.*\"(.*)\"', line)
          if titleMatch:
            title = titleMatch.group(1)

          m = re.match('.*createdInVersion:(.*)', line)
          if m:
            activityVersion = m.group(1)
            if int(activityVersion) == int(version):
              po_title = po.find(title);
              if locale == "en-US":
                translated_title = title;
              elif po_title and po_title.translated():
                translated_title = po_title.msgstr;
              else: # The translation is not complete, we skip the language
                if verbose:
                  print("Skip %s because %s is not translated" % (locale, title));
                return False, "";
              output += "- " + translated_title + '\n';
    except IOError as e:
      if verbose:
        print("ERROR: Failed to parse %s: %s" %(source, e.strerror))

  # Get changelog information
  versions_data = changelog_qml.property('changelog')
  for version_data in versions_data.toVariant():
    if version == str(version_data['versionCode']):
      content = version_data['content'];
      for feature in content:
        po_feature = po.find(feature);
        if locale == "en-US":
          translated_feature = feature;
        elif po_feature and po_feature.translated():
          translated_feature = po.find(feature).msgstr;
        else: # The translation is not complete, we skip the language
          if verbose:
            print("Skip %s because %s is not translated" % (locale, feature));
          return False, "";

        output += "- " + translated_feature + '\n';

  output += "</%s>\n" % locale;
  return True, output;

def main(argv):
  if sys.argv[0] != "./tools/android_format_changelog.py":
    print("Needs to be run from top level of GCompris")
    sys.exit(1);
  app = QCoreApplication(sys.argv)

  engine = QQmlEngine()
  # We need to register at least one file for GCompris package else it is not found
  qmlRegisterType(ActivityInfo, "GCompris", 1, 0, "ActivityInfo");

  # TODO Need to check if we hardcode the list from the xml file or if we get it in GCompris...

  component = QQmlComponent(engine)
  component.loadUrl(QUrl("src/core/ChangeLog.qml"))
  changelog_qml = component.create()

  output="";
  # List taken from the android list
  for locale in ["en-US", "be", "ca", "de-DE", "el-GR", "en-GB", "es-ES", "eu-ES", "fi-FI", "fr-FR", "gl-ES", "hu-HU", "id", "it-IT", "iw-IL", "mk-MK", "ml-IN", "nl-NL", "no-NO", "pl-PL", "pt-BR", "pt-PT", "ro", "ru-RU", "sk", "sl", "sq", "sv-SE", "tr-TR", "uk", "zh-CN", "zh-TW"]:
    isTranslationOk, locale_changes = generate_for_locale(changelog_qml, locale);
    if isTranslationOk:
      output += locale_changes;

  print(output);

if __name__ == '__main__':
  main(sys.argv)
  
