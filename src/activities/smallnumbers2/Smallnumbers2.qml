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

import "../gletters"

Gletters {
    id: activity
    dataSetUrl: "qrc:/gcompris/src/activities/smallnumbers2/resource/"
    activityName: "smallnumbers2"
    useDataset: true
    property string dominoMode: "dot"

    // keep names in sync with the list in ActivityConfig
    readonly property var dominoModeNames: {
        "dot": qsTr("Dots"),
        "number": qsTr("Arabic numbers"),
        "roman": qsTr("Roman numbers"),
        "image": qsTr("Images")
    }
    readonly property string currentModeName: dominoModeNames[dominoMode]

    function getMode() {
        return activity.dominoMode;
    }

    function getDominoValues(key: int) : list<int> {
        var val1 = Math.floor(Math.random() * key)
        return [val1, key - val1]
    }
}
