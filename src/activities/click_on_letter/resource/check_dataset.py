# -* coding: utf-8 -*-
#!/usr/bin/python3
#
# GCompris - check_dataset.py
# Simple usage on all the files: for f in levels*.json; do python check_dataset.py $f; done
#
# SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later
import json
import sys

if len(sys.argv) < 2:
    print("Usage: check_dataset.py dataset.json")
    sys.exit(1)

dataset = sys.argv[1]
with open(dataset, encoding='utf-8') as json_data:
    data = json.load(json_data)

for level in data:
    questions = level["questions"].split('|')
    answers = level["answers"]
    for question in questions:
        if question not in answers:
            print(f"Missing {question} in level {level['level']} of file {dataset}")
