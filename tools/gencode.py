#!/usr/bin/python
# Generate code for today
import random
from datetime import datetime

user = int(random.random() * 0xFFFF)
date = (datetime.now().year << 4) | datetime.now().month
crc = user ^ date ^ 0xCECA
print "%04X-%04X-%04X" %(user, date, crc)

