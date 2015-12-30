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

import QtQuick 2.2

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
     * A changelog object consists of the properties @c version (10000*major+100*minor+patch)
     * and @c content (which changes have been added in this version).
     *
     */
    property var changelog: [
            { "version": "0.60", "versionCode": 6000, "content": qsTr("New activities: baby_word_processor, ") },
            { "version": "0.50", "versionCode": 5000, "content": qsTr("New activities: Chess activity, Sound sequence memory, Vocabulary training, Famous paintings puzzle, Reading practice activity, Scientific electrical grid power supply simulation, Scientific water system simulation, A fine motor skill practice activity based on the accelerometer, The classical hangman.") },
            { "version": "0.40", "versionCode": 4000, "content": qsTr("New activities: algebra_div, babymatch, babyshapes, braille_fun, chronos, details, geo-country, geography, hanoi, hanoi_real, imagename, intro_gravity, louis-braille, simplepaint, superbrain, tic_tac_toe and tic_tac_toe_2players") }
        ]

    function isNewerVersion(previousVersion, newVersion) {
        return newVersion > previousVersion
    }
    function getLogBetween(previousVersion, newVersion) {
        var filtered = changelog.filter(function filter(obj) {
            return isNewerVersion(previousVersion, obj['versionCode'])
        });
        var output = "";
        filtered.map(function filter(obj) {
            var content = obj['content'].split(',').join('<br>');
            output += "Version %1: %2<br/>".arg(obj['version']).arg(content);
        });

        return output
    }
}
