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
import sys

if len(sys.argv) != 2:
    print "Usage: validate-json.py json_file"
    sys.exit(1)

inf=sys.argv[1]

with open(inf) as data_file:
    try:
        data = json.load(data_file)
        print "Processing OK " + inf
    except ValueError as e:
        print dir(e)
        print "Processing KO " + inf
        print "Parser error: {0}".format(e.message)

