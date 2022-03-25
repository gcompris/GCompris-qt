/* GCompris - smallnumbers2.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "../gletters"

Gletters {
    id: activity
    dataSetUrl: "qrc:/gcompris/src/activities/smallnumbers2/resource/"
    activityName: "smallnumbers2"
    useDataset: true
    property string dominoMode: "dot"

    function getMode() {
        return activity.dominoMode;
    }

    function getDominoValues(key) {
        var val1 = Math.floor(Math.random() * key)
        return [val1, key - val1]
    }
}
