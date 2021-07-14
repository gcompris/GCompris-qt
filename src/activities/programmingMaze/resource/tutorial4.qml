/* GCompris - tutorial1.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0

TutorialBase {
    //the level to fetch info from
    levelNumber: items.bar.level + 1
    //the highlighted area
    activeAreaTuto: "loop"
    instructionTextVisible: false
    mainVisible: true
    procedureVisible: false
    loopVisible: true
}
