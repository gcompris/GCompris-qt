#!/usr/bin/python3
#
# GCompris - fdroid_update_fastlane_metadata.py
#
# SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

import sys
import os
import re
import glob
import subprocess
import xml.etree.ElementTree as ET

from PyQt5.QtCore import QCoreApplication, QUrl
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine
import polib

from python.ActivityInfo import ActivityInfo

if len(sys.argv) < 2:
    print("Usage: fdroid_update_fastlane_metadata.py <version> [-v]")
    sys.exit(1)

version = sys.argv[1]
verbose = len(sys.argv) >= 3 and sys.argv[2] == "-v"

def generate_files_for_locale(changelog_qml, locale):
    # Generate in fastlane/metadata/android/$locale/
    # short_description.txt
    # full_description.txt
    # title.txt
    # changelogs for the version in parameter
    gcompris_locale = locale.replace("-", "_")

    locale_root_dir = f"fastlane/metadata/android/{locale}"
    if not os.path.isdir(locale_root_dir):
        os.mkdir(locale_root_dir)

    suffix = '[@{http://www.w3.org/XML/1998/namespace}lang="%s"]' % locale if locale != "en-US" else ""

    # Open org.kde.gcompris.appdata.xml to retrieve information
    tree = ET.parse("org.kde.gcompris.appdata.xml")
    appdata = tree.getroot()
    children = appdata.findall(f'name{suffix}')
    if not children:
        suffix = '[@{http://www.w3.org/XML/1998/namespace}lang="%s"]' % locale[0:2]
        children = appdata.findall(f'name{suffix}')

    if not children:
        if verbose:
            print(f"Language {locale} not translated")
        return False

    child = children[0]
    with open(f'{locale_root_dir}/title.txt', 'w', encoding="utf8") as title_file:
        title_file.write(child.text)

    children = appdata.findall(f'summary{suffix}')
    if not children:
        print(f"Language {locale} not translated")
        return False

    child = children[0]
    with open(f'{locale_root_dir}/short_description.txt', 'w', encoding="utf8") as short_description_file:
        short_description_file.write(child.text)

    # Get full description from summary elements
    children = appdata.findall(f'description//*{suffix}')
    with open(f'{locale_root_dir}/full_description.txt', 'w', encoding="utf8") as full_description_file:
        for c in children:
            if locale == "en-US" and c.attrib:
                continue
            if c.tag == 'ul':
                continue
            if c.tag == 'li':
                full_description_file.write("- ")
            full_description_file.write(c.text + '\n')

    # We use polib to translate as QTranslator only handles .qm files and we don't need to have GCompris compiled to generate this file
    translation_file_path = 'poqm/'+gcompris_locale+'/gcompris_qt.po'
    if not os.path.isfile(translation_file_path):
        # Short locale
        gcompris_locale = gcompris_locale[0:gcompris_locale.find("_")]
        translation_file_path = 'poqm/'+gcompris_locale+'/gcompris_qt.po'
        if not os.path.isfile(translation_file_path):
            if verbose:
                print(f"Locale {locale} [{gcompris_locale}] not handled, skip it")
            return False
    if verbose:
        print(f"Generate for locale {locale} [{gcompris_locale}]")
    po = polib.pofile(translation_file_path)

    output = ""

    # Get new activities for this version
    # With regex for each ActivityInfo.qml, no need to use Qt there
    for activityInfo in glob.glob('src/activities/*/ActivityInfo.qml'):
        try:
            if activityInfo.find("template") != -1:
                continue
            with open(activityInfo, encoding="utf8") as f:
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
                            po_title = po.find(title)
                            if locale == "en-US":
                                translated_title = title
                            elif po_title and po_title.translated():
                                translated_title = po_title.msgstr
                            else: # The translation is not complete, we skip the language
                                if verbose:
                                    print(f"Skip {locale} because {title} is not translated")
                                return False
                            output += "- " + translated_title + '\n'
        except IOError as e:
            if verbose:
                print(f"ERROR: Failed to parse {activityInfo}: {e.strerror}")

    # Get changelog information
    versions_data = changelog_qml.property('changelog')
    for version_data in versions_data.toVariant():
        if version == str(version_data['versionCode']):
            content = version_data['content']
            for feature in content:
                po_feature = po.find(feature)
                if locale == "en-US":
                    translated_feature = feature
                elif po_feature and po_feature.translated():
                    translated_feature = po.find(feature).msgstr
                else: # The translation is not complete, we skip the language
                    if verbose:
                        print("Skip %s because %s is not translated" % (locale, feature))
                    return False, ""

                output += "- " + translated_feature + '\n'
    changelog_dir = "%s/changelogs" % locale_root_dir
    if not os.path.isdir(changelog_dir):
        os.mkdir(changelog_dir)
    with open(changelog_dir+'/%s.txt' % version, 'w', encoding="utf8") as changelog_file:
        changelog_file.write(output)

    return True

def main(argv):
    if sys.argv[0] != "./tools/fdroid_update_fastlane_metadata.py":
        print("Needs to be run from top level of GCompris")
        sys.exit(1)
    app = QCoreApplication(sys.argv)

    engine = QQmlEngine()
    # We need to register at least one file for GCompris package else it is not found
    qmlRegisterType(ActivityInfo, "GCompris", 1, 0, "ActivityInfo")
    component = QQmlComponent(engine)
    component.loadUrl(QUrl("src/core/ChangeLog.qml"))
    changelog_qml = component.create()

    # List taken from the android list
    for locale in ["en-US", "ar-AR", "az-AZ", "be", "ca", "cs-CZ", "de-DE", "el-GR", "en-GB", "es-ES", "eu-ES", "fi-FI", "fr-FR", "gl-ES", "he", "hr", "hu-HU", "id", "it-IT", "lt", "mk-MK", "ml-IN", "nl-NL", "no-NO", "pl-PL", "pt-BR", "pt-PT", "ro", "ru-RU", "sk", "sl", "sq", "sv-SE", "tr-TR", "uk", "zh-CN", "zh-TW"]:
        is_translation_ok = generate_files_for_locale(changelog_qml, locale)
        if not is_translation_ok and verbose:
            print(f"Error when generating files for {locale}")

    PIPE = subprocess.PIPE
    process = subprocess.Popen(["git", "ls-files", "-o", "-m", "fastlane"], stdout = PIPE, stderr = PIPE)
    stdoutput, _ = process.communicate()
    if stdoutput:
        if verbose:
            print("git ls-files output:\n", stdoutput.decode("utf-8"))
        process = subprocess.Popen(["git", "add", "fastlane"], stdout = PIPE, stderr = PIPE)
        stdoutput, _ = process.communicate()
        process = subprocess.Popen(["git", "commit", "-m", 'fastlane, update metadata'], stdout = PIPE, stderr = PIPE)
        stdoutput, _ = process.communicate()

if __name__ == '__main__':
    main(sys.argv)
