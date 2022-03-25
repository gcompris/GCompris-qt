/* GCompris - ExploreFarmAnimals.qml
*
* SPDX-FileCopyrightText: 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

ExploreLevels {
    id: activity

    numberOfLevels: 1
    url: "qrc:/gcompris/src/activities/explore_farm_animals/resource/"
    hasAudioQuestions: true
    needsVoices: true
}
