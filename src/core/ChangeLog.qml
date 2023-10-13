/* GCompris - ChangeLog.qml
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
/**
 * Container object with a list of all the changes by version.
 * @ingroup infrastructure
 *
 */
QtObject {
    /**
     * type: list
     * List of changelog objects.
     *
     * A changelog object consists of the properties @c versionCode
     * and an optional @c content (which changes have been added in this version).
     * The activities added in this version are retrieved from the ActivityInfoTree and directly displayed.
     *
     */
    property var changelog: [
            { "versionCode": 40000, "content": [
                qsTr("Many usability improvements"),
                qsTr("Many new images"),
                qsTr("Many bug fixes")
                ],
              "newDatasets": ["algebra_by", "algebra_plus", "algebra_minus", "algebra_div"]
            },
            { "versionCode": 30300, "content": [
                qsTr("Translations added for Arabic and Esperanto"),
                qsTr("Many translation updates"),
                qsTr("Many new images"),
                qsTr("Many bug fixes")
                ]
            },
            { "versionCode": 30200, "content": [
                qsTr("New command-line option (--difficulty {value|min-max}) to start GCompris at specific difficulty"),
                qsTr("Many translation updates"),
                qsTr("Many new images"),
                qsTr("Many bug fixes")
                ]
            },
            { "versionCode": 30100, "content": [
                qsTr("Fix issue in comparator activity")
                ]
            },
            { "versionCode": 30000, "content": [
                qsTr("Map of Spain added for geography activity"),
                qsTr("Voices added for Ukrainian"),
                qsTr("New command-line option to list all the activities and start on a specific one"),
                qsTr("Many usability improvements"),
                qsTr("Many new images"),
                qsTr("Many bug fixes")
                ]
            },
            { "versionCode": 20400, "content": [
                qsTr("Reduce the size of the packages for all platforms and of the external word images set"),
                qsTr("Improve images quality in several activities"),
                qsTr("Fix some transitions in renewable_energy/watercycle on some platforms"),
                qsTr("Fix dead keys ignored on Linux for typing activities"),
                qsTr("Fix level reset when changing level manually in Logical associations")
                ]
            },
            { "versionCode": 20300, "content": [
                qsTr("Fix Alphabet sequence, Even and odd numbers and Numbers in order activities")
                ]
            },
            { "versionCode": 20200, "content": [
                qsTr("Several bug fixes"),
                qsTr("Many new images"),
                qsTr("Translation updated for Russian"),
                qsTr("New voices for Norwegian Nynorsk")
                ]
            },
            { "versionCode": 20100, "content": [
                qsTr("Translations added for Breton, Czech and Macedonian"),
                qsTr("Several bug fixes")
                ]
            },
            { "versionCode": 20000, "content": [
                qsTr("Translation added for Azerbaijani"),
                qsTr("New maps and update of the maps for geography activities"),
                qsTr("New dataset containing loops operations for programming maze, and make tutorial images translated"),
                qsTr("Addition of a level to teach voltage source loop in analog electricity activity"),
                qsTr("Many new images"),
                qsTr("Many usability improvements")
                ]
            },
            { "versionCode": 10100, "content": [qsTr("Many usability improvements"),
                qsTr("Many new images"),
                qsTr("Many bug fixes")
                ]
            },
            { "versionCode": 10000, "content": [qsTr("New Activity Settings menu, with dataset selection"),
                qsTr("Many usability improvements"),
                qsTr("Many new images"),
                qsTr("Many bug fixes")
                ]
            },
            { "versionCode": 9700, "content": [qsTr("New sub-categories to organize activities"),
                qsTr("Translation added for Macedonian."),
                qsTr("New activities Programming Maze and Baby Tangram"),
                qsTr("New background music and volume settings."),
                qsTr("New speed setting in several activities."),
                qsTr("New option in chess to display captured pieces."),
                qsTr("New images in Colors, Advanced colors and Target game."),
                qsTr("New voices for US English."),
                qsTr("Many little fixes and improvements.")] },
            { "versionCode": 9600, "content": [qsTr("Translation updated for multiple languages (Breton, Brazilian Portuguese, Finnish...)."),
                qsTr("Add Russian dataset for Click on letter activity."),
                qsTr("Lang activity now available in Dutch.")] },
            { "versionCode": 9500, "content": [qsTr("Merge Norwegian counties Nord-Trøndelag and Sør-Trøndelag into Trøndelag in geo-country activity."),
                qsTr("Fix in braille activities where the cells start at 1, not 0."),
                qsTr("Translation added for Basque, Hungarian and Malayalam."),
                qsTr("Loading/saving of creations (Baby Wordprocessor, Balance Box and Piano Composition).")] },
            { "versionCode": 9100, "content": [qsTr("Many little fixes and improvements."), qsTr("Translations added for Scottish Gaelic.")] },
            { "versionCode": 9000, "content": [qsTr("License page added in configuration."), qsTr("Multiple changes on layouts to improve the ergonomy.")] },
            { "versionCode": 8000, "content": [qsTr("Lang activity now available in Polish, Swedish and Ukrainian.")] },
            { "versionCode": 7000, "content": [qsTr("Search feature.")] },
            { "versionCode": 6000, "content": [qsTr("A Changelog.")] },
            { "versionCode": 5200, "content": [qsTr("Many little fixes."), qsTr("Lang activity now available in French.")] },
            { "versionCode": 5000, "content": [qsTr("Adding a loading overlay to let the user know that some actions are taking place (loading an activity for example) and can take some seconds."), qsTr("Translations added for: Catalan (Valencian), Chinese Traditional, Finnish (92% translated), Russian (98% translated), Slovak (92% translated), Turkish.")] },
            { "versionCode": 4000, "content": [qsTr("Translations added for: Slovenian, German, Galician.")] }
        ]

    function isNewerVersion(previousVersion, newVersion) {
        return newVersion > previousVersion
    }

    function getNewDatasetsBetween(previousVersion, newVersion) {
        const filtered = changelog.filter(function filter(obj) {
            return isNewerVersion(previousVersion, obj['versionCode'])
        });
        const allDatasetChanges = new Array();
        const allActivities = ActivityInfoTree.menuTreeFull
        for(const change of filtered) {
            if(change["newDatasets"]) {
                change["newDatasets"].forEach(function(value) {
                    for(var j in allActivities) {
                        var activity = allActivities[j];
                        // get the title of the activities that have new datasets
                        if(activity.name.startsWith(value + '/')) {
                            if(allDatasetChanges.find(function(newDatasetsActivity) { return newDatasetsActivity.activity == value; }) == undefined) {
                                allDatasetChanges.push({
                                    "activityName": activity.name,
                                    "activityTitle": activity.title,
                                    "overrideExistingLevels": true
                                });
                            }
                            break;
                        }
                    }
                })
            }
        }
        return allDatasetChanges;
    }

    function getLogBetween(previousVersion, newVersion) {
        var filtered = changelog.filter(function filter(obj) {
            return isNewerVersion(previousVersion, obj['versionCode'])
        });
        var output = "";
        // Retrieve all the activities created between the two versions
        ActivityInfoTree.filterCreatedWithinVersions(previousVersion, newVersion);
        var activities = ActivityInfoTree.menuTree;
        // display for each version an optional text ("content") then the new activities
        filtered.map(function filter(obj) {
            var major = Math.floor((obj['versionCode'] / 10000));
            var minor = (obj['versionCode'] % 10000 / 100);
            var patch = (obj['versionCode'] % 100);

            var version = major + "." + minor;
            if(patch !== 0) {
                version += "."+patch;
            }
            output += "<b>" + qsTr("Version %1:").arg(version) + "</b>";
            output += "<ul>";
            // display free text if exist
            for(const text of obj['content'])
                output += "<li>" + text + "</li>";
            // display the activity titles
            for(var j in activities) {
                var activity = activities[j];
                if(activity.createdInVersion === obj['versionCode'] && activity.enabled) {
                    output += "<li>" + activity.title + "</li>";
                }
            }
            output += "</ul>";
        });

        // restore menu context
        ActivityInfoTree.filterByTag("favorite")
        ActivityInfoTree.filterEnabledActivities()

        return output
    }
}
