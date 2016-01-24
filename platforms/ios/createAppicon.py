#!/usr/bin/python
#
# GCompris - validate-json.py
#
# Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
    sizestr = str(image[0]) + 'x' + str(image[0])
    idiom = image[1]
    scale = image[2]
    scalestr = str(scale) + 'x'
    filename = "appicon-" + idiom + sizestr + '_' + scalestr + ".png"
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
                     "-w", str(size * scale),
                     "-h", str(size * scale)])

with open(outdir + '/Contents.json', 'w') as f:
    f.write(json.dumps(content, sort_keys=True,
                       indent=4, separators=(',', ': ')))
