#!/usr/bin/python
#
# GCompris - download-assets.py
#
# Copyright (C) 2016-2018 Johnny Jazeix <jazeix@gmail.com>
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
import urllib.request
import shutil
import sys

# see https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3/7244263#7244263
def download_file(from_url, output_dir):
    file_name = output_dir + "/" + from_url.split('/')[-1]
    with urllib.request.urlopen(from_url) as response, open(file_name, 'wb') as out_file:
        shutil.copyfileobj(response, out_file)

# argv[0]: program name
# argv[1]: assets to download (words, full for full rccs, locale to get correpsonding locale voices)
# argv[2]: audio format (ogg, mp3, aac)
# argv[3]: output directory (rcc directory)
if len(sys.argv) != 4:
    print("Usage: download-assets.py \"words,full,en,fr,pt_BR\" ogg/mp3/aac outputFolder")
    sys.exit(0)

"""Download the voices and words assets depending on the wanted audio format
"""

DOWNLOAD_PATH = "https://cdn.kde.org/gcompris/data2/"
AUDIO_FORMAT = sys.argv[2]
OUTPUT_FOLDER = sys.argv[3]+"/data2/"

ALL_LANGUAGES = [x.strip() for x in sys.argv[1].split(",") if len(x)]
DOWNLOAD_WORDS = "words" in ALL_LANGUAGES
DOWNLOAD_FULL = "full" in ALL_LANGUAGES
if DOWNLOAD_WORDS:
    ALL_LANGUAGES.remove("words")
    download_file(DOWNLOAD_PATH+"words/words.rcc", OUTPUT_FOLDER+"words/")

if DOWNLOAD_FULL:
    ALL_LANGUAGES.remove("full")
    download_file(DOWNLOAD_PATH+"full-"+AUDIO_FORMAT+".rcc", OUTPUT_FOLDER)

for lang in ALL_LANGUAGES:
    lang_url = DOWNLOAD_PATH+"voices-"+AUDIO_FORMAT+"/voices-"+lang+".rcc"
    download_file(lang_url, OUTPUT_FOLDER+"voices-"+AUDIO_FORMAT+"/")
