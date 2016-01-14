#!/usr/bin/python
#
# GCompris - gencode.py
#
# Copyright (C) 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
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

# Generate code for today
import random
from datetime import datetime

user = int(random.random() * 0xFFFF)
date = (datetime.now().year << 4) | datetime.now().month
crc = user ^ date ^ 0xCECA
print "%04X-%04X-%04X" %(user, date, crc)

