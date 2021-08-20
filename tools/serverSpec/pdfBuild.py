# Python code to create control panel specification documentation in latex format 
from pylatex import Document, Section, Subsection, Subsubsection, Tabular, MultiColumn, \
 Figure, Package, NewLine, Command, escape_latex, LineBreak
from pylatex.utils import NoEscape
from pylatex.utils import italic
import re
import requests
import subprocess
#import sys
import os
from os import path
import shutil
import argparse


import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--wikiurl", help = "Wiki defining the specification structure", default="https://invent.kde.org/education/gcompris.wiki.git")
parser.add_argument("--outputFilename", required=None, help = "Output filename, if not provided use default name GCControlPanelSpec.pdf", default="GCControlPanelSpec.pdf")
parser.add_argument("--doNotDownloadWiki", action='store_true', help = "Use this option to use the wiki file already downloaded locally.")
parser.add_argument("--doNotDownloadIssuesImages", action='store_true', help = "Use this option to use the issues images files already downloaded locally.")

args = parser.parse_args()

print('wikiUrl:', args.wikiurl)
specificationWikiUrlSource = args.wikiurl

outputFilename = args.outputFilename
print('Outputfile set to :', outputFilename)

#if Wiki specification file does not exists and if it is not downloaded: exit
wikiSourceDir = re.search('.*/(.*).git$', specificationWikiUrlSource)
wikiSourceDir = wikiSourceDir.group(1)
fullPathWikiSourceDir = "./" + wikiSourceDir
specificationWikiSourceFilemame = fullPathWikiSourceDir + "/GComprisCPSpec/GCompris-control-panel-specification.md"    
if args.doNotDownloadWiki:
    if not path.exists(fullPathWikiSourceDir):
        print("Wiki specification structure file", specificationWikiSourceFilemame, "missing, you need to remove the --doNotDownloadWiki option to download it.")
        exit()

#download issues image from gitlab website
def downloadIssueImage(filename, image):
    response = requests.get(image)
    file = open(filename, "wb")
    file.write(response.content)
    file.close()

# import specification structure written in project wiki "https://invent.kde.org/xxxxx/gcompris.wiki.git"
# uses git to clone the whole wiki report then read the specification structure source file 
if args.doNotDownloadWiki:
    print("Skip downloading wiki specification structure", specificationWikiSourceFilemame)
else:
    if path.exists(fullPathWikiSourceDir):
        print ("wiki source", wikiSourceDir, "delete it.")
        shutil.rmtree(fullPathWikiSourceDir)
    else:
        print("Download wiki specification structure", specificationWikiSourceFilemame)
    proc = subprocess.run(["git", "clone", specificationWikiUrlSource], stdout=subprocess.PIPE)

# Extract issues description and assign them to their url using graphQl
tableOfContentSectionsDicts = dict()
graphQlheaders = {
    'Authorization': 'Bearer xxxxxxxxxxxxxxxxxxxx',
}
graphQlDataQuery = { 
    'query': 'query { project(fullPath: "education/gcompris") { name issues { nodes { description webUrl designCollection { designs { nodes { filename image } } } } } } }' 
}
issuesContent = requests.post('https://invent.kde.org/api/graphql', headers=graphQlheaders, data=graphQlDataQuery)
issuesContent = issuesContent.json();
for issueContent in issuesContent["data"]["project"]["issues"]["nodes"]:
    tableOfContentSectionsDicts[issueContent["webUrl"]] = issueContent["description"]   #prepare no content yet message if link in wiki does not point to an existing issue    

#import issues designs pictures using graphql
designImagesDir = "designImages"
if args.doNotDownloadIssuesImages:
    print("Skip downloading issues designs images files")
else:
    if not os.path.exists(designImagesDir):
        os.makedirs(designImagesDir)
    for designImageFiles in issuesContent["data"]["project"]["issues"]["nodes"]:
        if designImageFiles["designCollection"]["designs"]["nodes"]:
            for designImageFile in designImageFiles["designCollection"]["designs"]["nodes"]:
                print(designImageFile["filename"])
                print(designImageFile["image"])    
                downloadIssueImage(designImagesDir + "/" + designImageFile["filename"],designImageFile["image"])
 
# Extract manual sections names using wiki markdown internal links
tableOfContentSectionsStruct = []
file1 = open(specificationWikiSourceFilemame, 'r') 
Lines = file1.readlines() 
file1.close() 
for line in Lines: 
    print(line)
    #Searching markdown link pattern such as - [Deleting a single pupil](https://invent.kde.org/education/gcompris/-/issues/25)
    tableOfContentSection = re.search('\[(.+)\]\(([^ ]+?)( "(.+)")?\)', line)

    if tableOfContentSection is not None:
        tableOfContentSectionStructDict = {
            "sectionTitle": "",
            "issueUrl": "",
            "subsubsection": ""
        }

        tableOfContentSectionStructDict["sectionTitle"] = tableOfContentSection.group(1)
        tableOfContentSectionStructDict["issueUrl"] = tableOfContentSection.group(2)
        if "   -" in line:
            tableOfContentSectionStructDict["subsubsection"] = "true"
        tableOfContentSectionsStruct.append(tableOfContentSectionStructDict)

# Create pdf/latex document using extracted data
doc = Document(document_options="english")
doc.packages.append(Package('geometry', options=['tmargin=1cm',
                                                 'lmargin=1cm']))
doc.packages.append(Package('float'))
doc.packages.append(Package('babel', "english"))
doc.packages.append(Package('hyperref', options='hidelinks'))

doc.preamble.append(Command('title', 'GCompris Control Panel Specification'))
doc.preamble.append(Command('author', 'GCompris developers\' team'))
doc.preamble.append(Command('date', NoEscape(r'\today')))
doc.append(NoEscape(r'\hypersetup{linktoc=all, citecolor=black, filecolor=black, linkcolor=black, urlcolor=black}'))
doc.append(NoEscape(r'\maketitle'))
doc.append(NoEscape(r'\tableofcontents'))
doc.append(NoEscape(r'\newpage'))

for tableOfContentSection in tableOfContentSectionsStruct:
    print("")
    print("")
    print("**************//////////////////***********************")
    print(tableOfContentSectionsDicts[tableOfContentSection["issueUrl"]])
    print("**************//////////////////***********************")
    print("")
    print("")

    if tableOfContentSection["subsubsection"] == "true":
        with doc.create(Subsection(tableOfContentSection["sectionTitle"], numbering=True, label=False)):
            lines = tableOfContentSectionsDicts[tableOfContentSection["issueUrl"]].splitlines()
            for line in lines: 
                print("----------: " + line)
                if "'#" in line:     #' is created by gitlab csv export
                    with doc.create(Subsubsection(line.replace("'#", ""), numbering=True, label=False)):
                        print(line.replace("'#", ""))
                elif "#" in line:
                    with doc.create(Subsubsection(line.replace("#", ""), numbering=True, label=False)):
                        print(line.replace("#", ""))
                #remove link line used to provide files in issues, so that they do not end up in the final specification
                elif re.search('\[.*\].*', line) is not None:   
                    print (line)
                else:
                    designfilename = re.search('See https.*/([A-Za-z0-9-_,\s]+[.]{1}[A-Za-z]{3})', line)
                    print(line)
                    if designfilename is not None:
                        designfilenameWithPath = designImagesDir + "/" + designfilename.group(1)
                        print(designfilenameWithPath)
                        with doc.create(Figure(position='H')) as activity_picture:
                            activity_picture.add_image(designfilenameWithPath, width='250px')
                            activity_picture.add_caption(designfilename.group(1))
                    else:
                        doc.append(line)
                        doc.append(NewLine())
    else: 
        with doc.create(Section(tableOfContentSection["sectionTitle"], numbering=True, label=False)):
            lines = tableOfContentSectionsDicts[tableOfContentSection["issueUrl"]].splitlines()
            for line in lines: 
                if "'#" in line:     #' is created by gitlab csv export
                    if tableOfContentSection["subsubsection"] == "true":
                        with doc.create(Subsubsection(line.replace("'#", ""), numbering=True, label=False)):
                            print(line.replace("'#", ""))
                    else:
                        with doc.create(Subsection(line.replace("'#", ""), numbering=True, label=False)):
                            print(line.replace("'#", ""))
                elif "#" in line:
                    if tableOfContentSection["subsubsection"] == "true":
                        with doc.create(Subsubsection(line.replace("#", ""), numbering=True, label=False)):
                            print(line.replace("#", ""))
                    else:
                        with doc.create(Subsection(line.replace("#", ""), numbering=True, label=False)):
                            print(line.replace("#", ""))
                elif re.search('\[.*\].*', line) is not None:   
                    print (line)
                else:
                    designfilename = re.search('See https.*/([A-Za-z0-9-_,\s]+[.]{1}[A-Za-z]{3})', line)
                    print(line)
                    if designfilename is not None:
                        designfilenameWithPath = designImagesDir + "/" + designfilename.group(1)
                        print(designfilenameWithPath)
                        with doc.create(Figure(position='H')) as activity_picture:
                            activity_picture.add_image(designfilenameWithPath, width='250px')
                            activity_picture.add_caption(designfilename.group(1))
                    else:
                        doc.append(line)
                        doc.append(NewLine())

doc.generate_tex(outputFilename)
subprocess.run(["pdflatex", "--interaction=nonstopmode", outputFilename], stderr=subprocess.STDOUT)
subprocess.run(["pdflatex", "--interaction=nonstopmode", outputFilename], stderr=subprocess.STDOUT)
