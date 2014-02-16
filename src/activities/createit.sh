#!/bin/bash
#set -x
if [ -z $1 ]; then
  echo "Usage: createit.sh [new GCompris activity]"
  echo "   e.g.: createit.sh myactivity"
  exit 1
fi

activity=$1
Activity=${activity^}
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
mv $template.pri $activity.pri
mv $template.svg $activity.svg
mv $Template.qml $Activity.qml
sed -i s/$template/$activity/g *
sed -i s/$Template/$Activity/g *
cd ..

# The list of activities
echo $activity >> activities.txt

# The main makefile
include_marker="# Activity Includes"
include="include(src/activities/$activity/$activity.pri)"
sed -i "s:${include_marker}:${include_marker}\n${include}:g" ../../GCompris.pro
