#!/usr/bin/python3
#
# GCompris - download-assets.py
#
# SPDX-FileCopyrightText: 2016-2018 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later
import urllib.request
import shutil
import sys

# see https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3/7244263#7244263
def download_file(from_url, output_dir):
    file_name = output_dir + "/" + from_url.split('/')[-1]
    with urllib.request.urlopen(from_url) as response, open(file_name, 'wb') as out_file:
        shutil.copyfileobj(response, out_file)

# argv[0]: program name
# argv[1]: assets to download (words, full for full rccs, music, locale to get corresponding locale voices)
# argv[2]: audio format (ogg, mp3, aac)
# argv[3]: output directory (rcc directory)
if len(sys.argv) != 4:
    print("Usage: download-assets.py \"words,full,music,en,fr,pt_BR\" ogg/mp3/aac outputFolder")
    sys.exit(0)

"""Download the voices and words assets depending on the wanted audio format
"""

DOWNLOAD_PATH = "https://cdn.kde.org/gcompris/data2/"
AUDIO_FORMAT = sys.argv[2]
OUTPUT_FOLDER = sys.argv[3]+"/data2/"

ALL_LANGUAGES = [x.strip() for x in sys.argv[1].split(",") if len(x)]
DOWNLOAD_WORDS = "words" in ALL_LANGUAGES
DOWNLOAD_FULL = "full" in ALL_LANGUAGES
DOWNLOAD_MUSIC = "music" in ALL_LANGUAGES
if DOWNLOAD_WORDS:
    ALL_LANGUAGES.remove("words")
    download_file(DOWNLOAD_PATH+"words/words.rcc", OUTPUT_FOLDER+"words/")

if DOWNLOAD_FULL:
    ALL_LANGUAGES.remove("full")
    download_file(DOWNLOAD_PATH+"full-"+AUDIO_FORMAT+".rcc", OUTPUT_FOLDER)

if DOWNLOAD_MUSIC:
    ALL_LANGUAGES.remove("music")
    download_file(DOWNLOAD_PATH+"backgroundMusic/backgroundMusic-"+AUDIO_FORMAT+".rcc", OUTPUT_FOLDER+"backgroundMusic/")

for lang in ALL_LANGUAGES:
    lang_url = DOWNLOAD_PATH+"voices-"+AUDIO_FORMAT+"/voices-"+lang+".rcc"
    download_file(lang_url, OUTPUT_FOLDER+"voices-"+AUDIO_FORMAT+"/")
