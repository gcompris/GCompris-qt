/* gcompris
 *
 * SPDX-FileCopyrightText: 2014 JB BUTET <ashashiwa@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../memory"
import "../memory/memorydataset.js" as Dataset

MemoryCommon {
    dataset: Dataset.get()
    backgroundImg: "qrc:/gcompris/src/activities/memory/resource/background.svg"
    withTux: true
}
