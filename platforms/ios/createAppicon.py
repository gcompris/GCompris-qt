#!/usr/bin/python
#
# GCompris - createAppicon.py
#
# SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

import json
import subprocess
import sys
import os

if len(sys.argv) < 3:
    print 'Usage: createAppicon.py Images.xcassets/AppIcon.appiconset icon_no_corner.svg'
    sys.exit(1)

outdir = sys.argv[1]
image_source = sys.argv[2]

try:
    os.makedirs(outdir)
except:
    pass

images = [
    [ 29, "iphone", 1 ],
    [ 29, "iphone", 2 ],
    [ 29, "iphone", 3 ],
    [ 40, "iphone", 2 ],
    [ 40, "iphone", 3 ],
    [ 57, "iphone", 1 ],
    [ 57, "iphone", 2 ],
    [ 60, "iphone", 2 ],
    [ 60, "iphone", 3 ],
    [ 29, "ipad", 1 ],
    [ 29, "ipad", 2 ],
    [ 40, "ipad", 1 ],
    [ 40, "ipad", 2 ],
    [ 50, "ipad", 1 ],
    [ 50, "ipad", 2 ],
    [ 72, "ipad", 1 ],
    [ 72, "ipad", 2 ],
    [ 76, "ipad", 1 ],
    [ 76, "ipad", 2 ],
    [ 83.5, "ipad", 2 ]
]

content = {
    "images": [],
    "info": {
        "version": 1,
        "author": "GCompris"
    }
}

for image in images:
    size = image[0]
    idiom = image[1]
    scale = image[2]
    scalestr = str(scale) + 'x'
    filesizestr = str(int(size * scale)) + 'x' + str(int(size * scale))
    sizestr = str(size) + 'x' + str(size)
    filename = "appicon-" + filesizestr + ".png"
    content['images'].append(
        {
            "size": sizestr,
            "idiom": idiom,
            "filename": filename,
            "scale": scalestr
        }
    )

    subprocess.call(["inkscape", image_source,
                     "-e", outdir + '/' + filename,
                     "-w", str(int(size * scale)),
                     "-h", str(int(size * scale))])

with open(outdir + '/Contents.json', 'w') as f:
    f.write(json.dumps(content, sort_keys=True,
                       indent=4, separators=(',', ': ')))
