#!/usr/bin/env bash
#=============================================================================
# SPDX-FileCopyrightText: 2019 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#=============================================================================
# Copied from https://cgit.kde.org/plasma-browser-integration.git/tree/StaticMessages.sh

# We fill in the en "translations" manually. We extract this to the KDE system as pot as normal, then populate the other json files

# The name of catalog we create (without the.pot extension), sourced from the scripty scripts
FILENAME="gcompris_lang"

function export_pot_file # First parameter will be the path of the pot file we have to create, includes $FILENAME
{
    potfile=$1
    python3 ./activities/lang/resource/datasetToPo.py ./activities/lang/resource/words.json $potfile
}

function import_po_files # First parameter will be a path that will contain several .po files with the format LANG.po
{
    podir=$1
    for file in `ls $podir`
    do
        lang=${file%.po} #remove .po from end of file
        python3 ./activities/lang/resource/poToDataset.py $podir/$file ./activities/lang/resource/content-$lang.json
    done
}
