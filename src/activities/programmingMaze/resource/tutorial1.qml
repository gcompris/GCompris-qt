/* GCompris - tutorial1.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.6
import GCompris 1.0

TutorialBase {
    //the level to fetch info from
    levelNumber: 0
    //the highlighted area
    activeAreaTuto: "instruction"
    instructionTextVisible: true
    mainVisible: false
    procedureVisible: false
}
