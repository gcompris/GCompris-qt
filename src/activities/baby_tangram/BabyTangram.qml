/* GCompris - BabyTangram.qml
 *
 * SPDX-FileCopyrightText: 2019 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Yves Combe /  Philippe Banwarth (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> / Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "dataset.js" as Dataset
import "../tangram"
import "."

Tangram {
    id: activity
    dataset: Dataset
    resourceUrl: "qrc:/gcompris/src/activities/baby_tangram/resource/"
}
