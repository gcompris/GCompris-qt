/* GCompris - Explore_monuments.qml
*
* SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

import "../explore_farm_animals"

ExploreLevels {
        id: activity

        numberOfLevels: 6
        url: "qrc:/gcompris/src/activities/explore_monuments/resource/"
        hasAudioQuestions: false
}
