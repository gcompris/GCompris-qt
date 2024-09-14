#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# user_manual_generator.py
#
# Copyright (C) 2018-2024 Johnny Jazeix <jazeix@gmail.com>
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

from pylatex import Document, Section, Subsection, Tabular, MultiColumn, \
 Figure, Package, NewLine, NewPage, Command, escape_latex
from pylatex.utils import NoEscape

from PyQt6.QtCore import QCoreApplication, QUrl, QTranslator
from PyQt6.QtQml import qmlRegisterType, qmlRegisterSingletonType, QQmlComponent, QQmlEngine

from ActivityInfo import ActivityInfo
from ApplicationInfo import ApplicationInfo
from Dataset import Dataset

import subprocess
import sys
import os
import re
import polib

if len(sys.argv) != 2:
    print("Usage: user_manual_generator.py <locale>")
    sys.exit(1)
locale = sys.argv[1]

def getEnvVar(varName):
    if not os.environ.get(varName):
        print("Missing environment variable", varName)
        sys.exit(1)
    return os.environ[varName]

def getTranslatedText(original_text, po_file):
    text = [e.msgstr for e in po_file if original_text == e.msgid]
    return text[0] if text else original_text

#todo add all languages here
language_list= {'be': 'belarusian',
                'ca': 'catalan',
                'de': 'german',
                'el': 'greek',
                'en': 'english',
                'es': 'spanish',
                'fr': 'french',
                'nl': 'dutch',
                'uk': 'ukrainian'}

web_source = getEnvVar('GCOMPRIS_WEB_SRC')
#gcompris_web_po = web_source + "/locale/" + locale + ".po"
gcompris_web_screenshots = web_source + "/screenshots_qt/middle/"

# todo check existence of po and screenshots files
gcompris_source = getEnvVar('GCOMPRIS_SRC')
gcompris_src_po = gcompris_source + "/poqm/" + locale + "/gcompris_qt.po"
activity_dir = gcompris_source + "/src/activities/"
# todo check existence of po and activity files

out_dir = "userManual"
if os.path.exists(out_dir):
    if not os.path.isdir(out_dir):
        print(out_dir + " is not a directory")
        sys.exit(-1);
else:
    os.mkdir(out_dir)

filename = out_dir + "/user_manual_" + locale

#web_po_file = polib.pofile(gcompris_web_po, encoding="utf-8")
gcompris_po_file = polib.pofile(gcompris_src_po, encoding="utf-8")

#web_po_translated_entries = web_po_file.translated_entries()
gcompris_po_translated_entries = gcompris_po_file.translated_entries()

doc = Document(document_options=language_list[locale])
doc.packages.append(Package('geometry', options=['tmargin=1cm',
                                                 'lmargin=1cm']))
doc.packages.append(Package('float'))
doc.packages.append(Package('babel', options=language_list[locale]))
doc.packages.append(Package('hyperref', options='hidelinks'))

doc.preamble.append(Command('title', 'GCompris user manual'))
doc.preamble.append(Command('author', 'GCompris developers\' team'))
doc.preamble.append(Command('date', NoEscape(r'\today')))
doc.append(NoEscape(r'\hypersetup{linktoc=all, citecolor=black, filecolor=black, linkcolor=black, urlcolor=black}'))
doc.append(NoEscape(r'\maketitle'))
doc.append(NoEscape(r'\tableofcontents'))
doc.append(NoEscape(r'\newpage'))

if os.path.exists(gcompris_source + "/docs/manual-general"):
    with open(gcompris_source + "/docs/manual-general") as f:
        content = f.readlines()
        for line in content:
            if "***" in line:
                with doc.create(Subsection(line.replace("***", ""), numbering=False)):
                    print(line.replace("***", ""))
            elif "**" in line:
                with doc.create(Section(line.replace("**", ""), numbering=False)):
                    print(line.replace("**", ""))
            else:
                doc.append(line)
    doc.append(NoEscape(r'\newpage'))


# Create Qt application to load the activities information from ActivityInfo.qml
app = QCoreApplication(sys.argv)
translator = QTranslator()
translator.load(os.path.join(web_source, "locale", locale,"LC_MESSAGES/gcompris_qt.qm"))
# TODO Need to fix this to ensure it is on an existing build folder!
translator.load(os.path.join(gcompris_source, "build/share/gcompris-qt/translations/gcompris_" + locale + ".qm"))
app.installTranslator(translator)

# create qml engine to read the files
engine = QQmlEngine()
activityInfoComponent = QQmlComponent(engine)
qmlRegisterSingletonType(ApplicationInfo, "GCompris", 1, 0, ApplicationInfo.createSingleton, "ApplicationInfo");
qmlRegisterType(ActivityInfo, "GCompris", 1, 0, "ActivityInfo");
qmlRegisterType(Dataset, "GCompris", 1, 0, "Data");

# Load sections from menu, should be done with Qt but seems difficult to load GCompris
menuPath = os.path.join(activity_dir,"menu","Menu.qml")
sections = list(re.findall(r'"(.*)"', line)[0] for line in open(menuPath) if 'tag:' in line and not 'favorite' in line and not 'search' in line)
print(sections) # TODO Needs to be translated somewhere

activitiesPerSection = {}

for activity in os.listdir(activity_dir):
    if activity in ["CMakeLists.txt", "template", "createit.sh", "README", "activities.txt", "activities_out.txt", "activities.qrc", "menu"]:
        continue
    activityInfoComponent.loadUrl(QUrl(os.path.join(activity_dir,activity,"ActivityInfo.qml")))
    activityInfo = activityInfoComponent.create()

    if activityInfo is None:
        # Print all errors that occurred.
        for error in activityInfoComponent.errors():
            print(error.toString())
            exit(-1)
    # ignore disabled activities
    if not activityInfo.property('enabled'):
        print("Disabling", activityInfo.property('name'))
        continue
    activityDict = {}
    activityDict['description'] = activityInfo.property('description').replace('\n', '<br/>')
    activityDict['name'] = activityInfo.property('name').split('/')[0]
    activityDict['title'] = activityInfo.property('title')
    activityDict['credit'] = activityInfo.property('credit').replace('\n', '<br/>')
    activityDict['goal'] = activityInfo.property('goal').replace('\n', '<br/>')
    activityDict['section'] = activityInfo.property('section').split(' ')
    activityDict['author'] = activityInfo.property('author')
    activityDict['manual'] = activityInfo.property('manual').replace('\n', '<br/>')
    activityDict['difficulty'] = activityInfo.property('difficulty')
    activityDict['category'] = activityInfo.property('category')
    activityDict['prerequisite'] = activityInfo.property('prerequisite').replace('\n', '<br/>')
    activityDict['icon'] = activityInfo.property('icon').split('/')[0]
    if len(activityInfo.property('levels')) != 0:
        activityDict['levels'] = activityInfo.property('levels').split(',')
    else:
        activityDict['levels'] = None
    hasError = False

    activityDict['translated_title'] = escape_latex(activityDict['title'])
    # remove quotes if there are
    activityDict['translated_title'] = activityDict['translated_title'].replace("\"", "")

    for section in activityDict['section']:
        if section in sections:
            currentList = activitiesPerSection[section] if section in activitiesPerSection else []
            currentList.append(activityDict)
            activitiesPerSection[section] = currentList

for section in activitiesPerSection:
    doc.append(NewPage())
    with doc.create(Section(section, numbering=False)):
        doc.append(NoEscape(r'\addcontentsline{toc}{section}{'+section+'}'));

    for activityDict in activitiesPerSection[section]:
        print(activityDict);
        description = activityDict['description'];
        goal = activityDict['goal'];
        levels = activityDict['levels'];
        translated_title = activityDict['translated_title'];
        activityName = activityDict['name'];
        with doc.create(Subsection(translated_title, numbering=False)):
            doc.append(NoEscape(r'\addcontentsline{toc}{subsection}{'+translated_title+'}'));
            doc.append(escape_latex(description))
            doc.append(NewLine())
            doc.append(app.translate(None, "Goal:") + " " + goal)

            with doc.create(Figure(position='H')) as activity_picture:
                activity_image = gcompris_web_screenshots + activityName + ".png"
                activity_picture.add_image(activity_image, width='250px')
                activity_picture.add_caption(translated_title)

            if levels != None:
                with doc.create(Tabular("|p{5cm}|p{9cm}|p{3cm}|")) as objective_tabular:
                    objective_tabular.add_hline()
                    # needs translation
                    objective_tabular.add_row(('Levels', 'Objectives', 'Difficulty'))
                    objective_tabular.add_hline()
                    for level in levels:
                        # needs to be opened via qml to get the full string
                        # (in case of line break)
                        dataComponent = QQmlComponent(engine)
                        dataComponent.loadUrl(QUrl(os.path.join(activity_dir, activityName, "resource", level, "Data.qml")))
                        data = dataComponent.create()
                        for error in dataComponent.errors():
                            print("JJ", error.toString())
                            hasError = True
                        if hasError:
                            break
                        objective = data.property('objective')
                        difficulty = data.property('difficulty')
                        objective_tabular.add_row((level, objective, difficulty))
                        objective_tabular.add_hline()

# would be great to use but do not work with Greek or Ukrainian for example as 
#doc.generate_pdf(filename, clean_tex=False)

doc.generate_tex(filename)
dest_dir = os.path.dirname(filename)
basename = os.path.basename(filename)
os.chdir(dest_dir)
subprocess.run(["pdflatex", "--interaction=nonstopmode", basename + ".tex"], stderr=subprocess.STDOUT)
subprocess.run(["pdflatex", "--interaction=nonstopmode", basename + ".tex"], stderr=subprocess.STDOUT)
