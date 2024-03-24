/* GCompris - Wordsgame.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

import "../gletters"

Gletters {
    id: activity
    
    mode: "word"
    dataSetUrl: "qrc:/gcompris/src/activities/wordsgame/resource/"

}
