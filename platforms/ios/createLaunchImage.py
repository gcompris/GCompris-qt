#!/usr/bin/python3
#
# GCompris - createLaunchImage.py
#
# SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

import json
import subprocess
import sys
import os
from shutil import copyfile


if len(sys.argv) < 3:
    print('Usage: createLaunchImage.py Images.xcassets/LaunchImage.launchimage ../../src/activities/menu/resource/background.svg')
    sys.exit(1)

outdir = sys.argv[1]
image_source = sys.argv[2]

# Should be extracted from the source image
source_width = 1052
source_height = 610

try:
    os.makedirs(outdir)
except:
    pass

images = [
    {
      "extent" : "full-screen",
      "idiom" : "iphone",
      "subtype" : "736h",
      "width": 1242, "height": 2208,
      "minimum-system-version" : "8.0",
      "orientation" : "portrait",
      "scale" : "3x"
    },
    {
      "extent" : "full-screen",
      "idiom" : "iphone",
      "subtype" : "736h",
      "width": 2208, "height": 1242,
      "minimum-system-version" : "8.0",
      "orientation" : "landscape",
      "scale" : "3x"
    },
    {
      "extent" : "full-screen",
      "idiom" : "iphone",
      "subtype" : "667h",
      "width": 750, "height": 1334,
      "minimum-system-version" : "8.0",
      "orientation" : "portrait",
      "scale" : "2x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "iphone",
      "width": 640, "height": 960,
      "extent" : "full-screen",
      "minimum-system-version" : "7.0",
      "scale" : "2x"
    },
    {
      "extent" : "full-screen",
      "idiom" : "iphone",
      "subtype" : "retina4",
      "width": 640, "height": 1136,
      "minimum-system-version" : "7.0",
      "orientation" : "portrait",
      "scale" : "2x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "ipad",
      "width": 768, "height": 1024,
      "extent" : "full-screen",
      "minimum-system-version" : "7.0",
      "scale" : "1x"
    },
    {
      "orientation" : "landscape",
      "idiom" : "ipad",
      "width": 1024, "height": 768,
      "extent" : "full-screen",
      "minimum-system-version" : "7.0",
      "scale" : "1x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "ipad",
      "width": 1536, "height": 2048,
      "extent" : "full-screen",
      "minimum-system-version" : "7.0",
      "scale" : "2x"
    },
    {
      "orientation" : "landscape",
      "idiom" : "ipad",
      "width": 2048, "height": 1536,
      "extent" : "full-screen",
      "minimum-system-version" : "7.0",
      "scale" : "2x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "iphone",
      "width": 320, "height": 480,
      "extent" : "full-screen",
      "scale" : "1x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "iphone",
      "width": 640, "height": 960,
      "extent" : "full-screen",
      "scale" : "2x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "iphone",
      "width": 640, "height": 1136,
      "extent" : "full-screen",
      "subtype" : "retina4",
      "scale" : "2x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "ipad",
      "width": 768, "height": 1004,
      "extent" : "to-status-bar",
      "scale" : "1x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "ipad",
      "width": 768, "height": 1024,
      "extent" : "full-screen",
      "scale" : "1x"
    },
    {
      "orientation" : "landscape",
      "idiom" : "ipad",
      "width": 1024, "height": 748,
      "extent" : "to-status-bar",
      "scale" : "1x"
    },
    {
      "orientation" : "landscape",
      "idiom" : "ipad",
      "width": 1024, "height": 768,
      "extent" : "full-screen",
      "scale" : "1x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "ipad",
      "width": 1536, "height": 2008,
      "extent" : "to-status-bar",
      "scale" : "2x"
    },
    {
      "orientation" : "portrait",
      "idiom" : "ipad",
      "width": 1536, "height": 2048,
      "extent" : "full-screen",
      "scale" : "2x"
    },
    {
      "orientation" : "landscape",
      "idiom" : "ipad",
      "width": 2048, "height": 1496,
      "extent" : "to-status-bar",
      "scale" : "2x"
    },
    {
      "orientation" : "landscape",
      "idiom" : "ipad",
      "width": 2048, "height": 1536,
      "extent" : "full-screen",
      "scale" : "2x"
    }
]

content = {
    "images": [],
    "info": {
        "version": 1,
        "author": "GCompris"
    }
}

for image in images:
    print(image)
    width = int(image['width'])
    height = int(image['height'])
    sizestr = str(width) + 'x' + str(height)
    image['filename'] = "appicon-" + sizestr + ".png"
    content['images'].append(image)

    # Calc the cropping area
    rw = source_width / width
    rh = source_height / height
    r = min(rw, rh)
    width_final = int(width * r)
    height_final = int(height * r)

    area_x = int((source_width - width_final) / 2)
    area_y = int((source_height - height_final) / 2)
    area = str(area_x) + ':' + \
           str(area_y) + ':' + \
           str(area_x + width_final) + ':' + \
           str(area_y + height_final)

    subprocess.call(["inkscape", image_source,
                      "-e", outdir + '/' + image['filename'],
                      "-a", area,
                      "-w", str(width),
                      "-h", str(height)])

with open(outdir + '/Contents.json', 'w') as f:
    f.write(json.dumps(content, sort_keys=True,
                       indent=4, separators=(',', ': ')))


# Create the Default-658h.png
copyfile(outdir + '/appicon-640x1136.png', outdir + '/../Default-568h@2x.png')
