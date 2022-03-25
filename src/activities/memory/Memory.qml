/* GCompris - Memory.qml
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
import "memorydataset.js" as Dataset

MemoryCommon {
    dataset: Dataset.get()
    backgroundImg: Dataset.url + "background.svg"
}
