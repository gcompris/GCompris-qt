#!/usr/bin/python
#
# GCompris - download-assets.py
#
# Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
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
#import os
import urllib2
import sys

# code from http://stackoverflow.com/questions/22676/how-do-i-download-a-file-over-http-using-python
def download_file(file, output_dir):
    u = urllib2.urlopen(file)
    file_name = output_dir + "/" + file.split('/')[-1]
    f = open(file_name, 'wb')
    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])
    print "Downloading: %s in %s Bytes: %s" % (file, file_name, file_size)
    file_size_dl = 0
    block_sz = 8192
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break
        file_size_dl += len(buffer)
        f.write(buffer)
        status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
        status = status + chr(8)*(len(status)+1)
        print status,
    f.close()

# argv[0]: program name
# argv[1]: assets to download (words, full for full rccs, locale to get correpsonding locale voices)
# argv[2]: audio format (ogg, mp3, aac)
# argv[3]: output directory (rcc directory)
if len(sys.argv) != 4:
    print "Usage: download-assets.py \"words,full,en,fr,pt_BR\""
    sys.exit(0)

"""Download the voices and words assets depending on the wanted audio format
"""

DOWNLOAD_PATH = "http://gcompris.net/data2/"
AUDIO_FORMAT = sys.argv[2]
OUTPUT_FOLDER = sys.argv[3]+"/data2/"

all_languages = [x.strip() for x in sys.argv[1].split(",") if len(x)]
downloadWords = "words" in all_languages
downloadFull = "full" in all_languages
if downloadWords:
    all_languages.remove("words")
    download_file(DOWNLOAD_PATH+"words/words.rcc", OUTPUT_FOLDER+"words/")

if downloadFull:
    all_languages.remove("full")
    download_file(DOWNLOAD_PATH+"full-"+AUDIO_FORMAT+".rcc", OUTPUT_FOLDER)

for lang in all_languages:
    download_file(DOWNLOAD_PATH+"voices-"+AUDIO_FORMAT+"/voices-"+lang+".rcc", OUTPUT_FOLDER+"voices-"+AUDIO_FORMAT+"/")
# Inform qmake about the updated file list
#os.utime("CMakeLists.txt", None)
