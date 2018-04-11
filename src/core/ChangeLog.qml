/* GCompris - ChangeLog.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
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
            { "versionCode": 9100, "content": qsTr("Many little fixes and improvements. Translations added for Scottish Gaelic.") },
            { "versionCode": 9000, "content": qsTr("License page added in configuration. Multiple changes on layouts to improve the ergonomy.") },
            { "versionCode": 8000, "content": qsTr("Lang activity now available in Polish, Swedish and Ukrainian.") },
            { "versionCode": 7000, "content": qsTr("Search feature.") },
            { "versionCode": 6000, "content": qsTr("A Changelog.") },
            { "versionCode": 5200, "content": qsTr("Many little fixes. Lang activity now available in French.") },
            { "versionCode": 5000, "content": qsTr("Adding a loading overlay to let the user know that some actions are taking place (loading an activity for example) and can take some seconds. Translations added for: Catalan (Valencian), Chinese Traditional, Finnish (92% translated), Russian (98% translated), Slovak (92% translated), Turkish.") },
            { "versionCode": 4000, "content": qsTr("Translations added for: Slovenian, German, Galician.") }
        ]

    function isNewerVersion(previousVersion, newVersion) {
        return newVersion > previousVersion
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
            obj['versionCode'];
            var version = (obj['versionCode'] / 10000).toFixed(2);
            output += "<b>" + qsTr("Version %1:").arg(version) + "</b>";
            output += "<ul>";
            // display free text if exist
            if(obj['content']) {
                output += "<li>" + obj['content'] + "</li>";
            }
            // display the activity titles
            for(var i in activities) {
                var activity = activities[i];
                if(activity.createdInVersion == obj['versionCode'] && activity.enabled) {
                    output += "<li>" + activity.title + "</li>";
                }
            }
            output += "</ul>";
        });

        // restore menu context
        ActivityInfoTree.filterByTag("favorite")
        ActivityInfoTree.filterLockedActivities()
        ActivityInfoTree.filterEnabledActivities()

        return output
    }
}
