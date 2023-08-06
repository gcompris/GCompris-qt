#!/bin/sh
# Bump the version in multiple files such as CMakeLists.txt
# If option "-r <date>" is set, it will also update the publiccode.yml, org.kde.gcompris.appdata.xml and docs/docbook/index.docbook files.
# There is no check at all if the release already exists or if the values are correct.
#
# SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

function usage() {
    echo "Usage: ./tools/bump_version.sh -v <version> [-r <date>] [-h]"
    echo "  -v, --version <version>   contains the new version <major>.<minor>"
    echo "  -r, --release <date>      contains the date of the release YYYY-MM-DD (optional)"
    echo "  -h, --help                displays this help"
}

if [ ! -f org.kde.gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--version)
      VERSION="$2"
      shift # past argument
      shift # past value
      ;;
    -r|--release)
      DATE="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
        usage;
        exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

if [[ ! "${VERSION}" ]]
then
    echo "Mission version"
    usage
    exit 1
fi

major=`echo $VERSION | cut -d. -f1`
minor=`echo $VERSION | cut -d. -f2`

echo "Version  = ${major}.${minor}"
echo "Date     = ${DATE}"

# Update CMakeLists GCOMPRIS_MAJOR_VERSION and GCOMPRIS_MINOR_VERSION variables
sed -i "s/set(GCOMPRIS_MAJOR_VERSION [0-9]\+)$/set\(GCOMPRIS_MAJOR_VERSION $major\)/" CMakeLists.txt
sed -i "s/set(GCOMPRIS_MINOR_VERSION [0-9]\+)$/set\(GCOMPRIS_MINOR_VERSION $minor\)/" CMakeLists.txt

git add CMakeLists.txt && git commit -m "core, bump version to ${major}.${minor}"

if [[ "${DATE}" ]]
then
    # Update publiccode.yml with the new date and release
    sed -i "s/releaseDate: '[0-9\-]\+'/releaseDate: '$DATE'/" publiccode.yml
    sed -i "s/softwareVersion: '[0-9\.]\+'/softwareVersion: '${major}.${minor}'/" publiccode.yml
    git add publiccode.yml && git commit -m "publiccode, add ${major}.${minor} release"
    # Add a new release in org.kde.gcompris.appdata.xml with the new date and release
    sed -i -e "/<releases>/a\ \ \ \ <release version=\"${major}.${minor}\" date=\"$DATE\"/>" org.kde.gcompris.appdata.xml
    git add org.kde.gcompris.appdata.xml && git commit -m "appdata, add ${major}.${minor} release"

    # Update docs/docbook/index.docbook
    sed -i "s=<date>[0-9\-]\+</date>=<date>$DATE</date>=" docs/docbook/index.docbook
    sed -i "s=<releaseinfo>[0-9\.]\+</releaseinfo>=<releaseinfo>${major}.${minor}</releaseinfo>=" docs/docbook/index.docbook
    git add docs/docbook/index.docbook && git commit -m "docs, bump version to ${major}.${minor}"
fi
