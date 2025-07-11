/* GCompris - smallnumbers.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../gletters"

Gletters {
    id: activity

    mode: "letter"
    activityName: "smallnumbers"
    useDataset: true
    dataSetUrl: "qrc:/gcompris/src/activities/smallnumbers/resource/"

    function getImage(key: string) : string {
        return dataSetUrl + "dice" + key + ".svg"
    }
}
