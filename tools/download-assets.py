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
import os

# see https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3/7244263#7244263
def download_file(from_url, output_dir):
    file_name = output_dir + "/" + from_url.split('/')[-1]
    print(f"Start to download {file_name}")
    with urllib.request.urlopen(from_url) as response, open(file_name, 'wb') as out_file:
        shutil.copyfileobj(response, out_file)
    print(f"Downloaded {file_name}")

def download_contents_and_file(subfolder, key, downloadContents=True):
    out = OUTPUT_FOLDER + subfolder
    os.makedirs(out, exist_ok=True)
    CONTENTS_FILE = out+"Contents"
    if downloadContents:
        download_file(DOWNLOAD_PATH+subfolder+"Contents", out)
    rcc_line = ""
    with open(CONTENTS_FILE) as f:
        lines = f.readlines()
        for line in lines:
            if key in line:
                rcc_line = line.split()[1]
                break
    download_file(DOWNLOAD_PATH+subfolder+rcc_line, out)


# argv[0]: program name
# argv[1]: assets to download (words, full for full rccs, music, locale to get corresponding locale voices)
# argv[2]: audio format (ogg, mp3, aac)
# argv[3]: output directory (rcc directory)
if len(sys.argv) != 4:
    print("Usage: download-assets.py \"words,full,music,en,fr,pt_BR\" ogg/mp3/aac outputFolder")
    sys.exit(0)

"""Download the voices and words assets depending on the wanted audio format
"""

DOWNLOAD_PATH = "https://cdn.kde.org/gcompris/data3/"
AUDIO_FORMAT = sys.argv[2]
OUTPUT_FOLDER = sys.argv[3]+"/data3/"

ALL_ASSETS = [x.strip() for x in sys.argv[1].split(",") if len(x)]
DOWNLOAD_WORDS = "words" in ALL_ASSETS
DOWNLOAD_FULL = "full" in ALL_ASSETS
DOWNLOAD_MUSIC = "music" in ALL_ASSETS

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

if DOWNLOAD_WORDS:
    ALL_ASSETS.remove("words")
    download_contents_and_file("words/", "words-webp")

if DOWNLOAD_FULL:
    ALL_ASSETS.remove("full")
    download_contents_and_file("", AUDIO_FORMAT)

if DOWNLOAD_MUSIC:
    ALL_ASSETS.remove("music")
    download_contents_and_file("backgroundMusic/", AUDIO_FORMAT)

if ALL_ASSETS:
    downloadContents = True
    for lang in ALL_ASSETS: # We open, read n times the Contents file, could be optimisable but should not take too much time
        download_contents_and_file("voices-"+AUDIO_FORMAT+"/", "-"+lang+"-", downloadContents)
        downloadContents = False

