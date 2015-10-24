#!/bin/bash
#set -x
if [ -z $1 ]; then
  echo "Usage: createit.sh [new GCompris activity]"
  echo "   e.g.: createit.sh myactivity"
  exit 1
fi

activity=$1
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

cd $activitydir
mv $template.js $activity.js
mv $template.svg $activity.svg
mv $Template.qml $Activity.qml
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' s/$template/$activity/g *
  sed -i '' s/$Template/$Activity/g *
else
  sed -i s/$template/$activity/g *
  sed -i s/$Template/$Activity/g *
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

# Concat both to form the new list
mv activities.txt.tmp.comment activities.txt
sort -u activities.txt.tmp >> activities.txt

# Remove temp files
rm activities.txt.tmp
