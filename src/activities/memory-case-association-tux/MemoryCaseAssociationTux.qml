/* GCompris - MemoryCaseAssociationTux.qml
 *
 * SPDX-FileCopyrightText: 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../memory"
import "../memory-case-association/dataset.js" as Dataset

MemoryCommon {
    dataset: Dataset.get()
    backgroundImg: "qrc:/gcompris/src/activities/memory/resource/background.svg"
    withTux: true
}
