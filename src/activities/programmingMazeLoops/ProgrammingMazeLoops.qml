/* GCompris - programmingMazeLoops.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

import "../../core"
import "../programmingMaze/"
import "../programmingMaze/programmingMaze.js" as Activity

ProgrammingMaze {
    id: activity
    mode: "loops"
    datasetUrl: "qrc:/gcompris/src/activities/programmingMazeLoops/Dataset.qml"
}
