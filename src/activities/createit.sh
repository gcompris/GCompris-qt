#!/bin/bash
#set -x
#=============================================================================
# SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#=============================================================================
if [ $# != 3 ]; then
  echo "Usage: createit.sh [new GCompris activity] \"username\" email"
  echo "   e.g.: createit.sh myactivity \"Your Name\" xx@yy.org"
  exit 1
fi

activity=$1
username=$2
email=$3
# Make it camel case
Activity=$(echo ${activity^} | sed 's/-\(.\)/\u\1/g')
activitydir=$1

template=template
Template=${template^}
templatedir=template

path=`dirname $0`

if [ -d $activitydir ]
then
  echo "ERROR: Activity $activitydir already present"
  exit 1
fi

cp -r $templatedir $activitydir


#retrieve version code
major=`awk '/set\(GCOMPRIS_MAJOR_VERSION / {print substr ($NF, 0, length($NF)-1); exit}' <  ../../CMakeLists.txt`
minor=`awk '/set\(GCOMPRIS_MINOR_VERSION / {print substr ($NF, 0, length($NF)-1); exit}' <  ../../CMakeLists.txt`
patch=`awk '/set\(GCOMPRIS_PATCH_VERSION / {print substr ($NF, 0, length($NF)-1); exit}' <  ../../CMakeLists.txt`
versioncode=$(($major*10000+$minor*100+$patch))

currentYear=`date +%Y`

cd $activitydir
mv $template.js $activity.js
mv $template.svg $activity.svg
mv $Template.qml $Activity.qml
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' s/$template/$activity/g *
  sed -i '' s/$Template/$Activity/g *
  sed -i '' s/"creationversion"/$versioncode/g *
  sed -i '' s/"YEAR"/$currentYear/g *
  sed -i '' s/"NAME"/"$username"/g *
  sed -i '' s/"EMAIL"/$email/g *
else
  sed -i s/$template/$activity/g *
  sed -i s/$Template/$Activity/g *
  sed -i s/"creationversion"/$versioncode/g *
  sed -i s/"YEAR"/$currentYear/g *
  sed -i s/"NAME"/"$username"/g *
  sed -i s/"EMAIL"/$email/g *
fi
cd ..

#
# The list of activities (keeping it sorted)
#

# Create the list without comments
grep -v "^#" activities.txt > activities.txt.tmp
echo $activity >> activities.txt.tmp

# Save the comments
grep "^#" activities.txt > activities.txt.tmp.comment

# The output of sort depends on the locale so we set C by default
LC_ALL=C

# Concat both to form the new list
mv activities.txt.tmp.comment activities.txt
sort -u activities.txt.tmp >> activities.txt

# Remove temp files
rm activities.txt.tmp
