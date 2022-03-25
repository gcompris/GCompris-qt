/* GCompris - learn_quantities.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "../learn_decimals/"
import "../learn_decimals/learn_decimals.js" as Activity

Learn_decimals {
    id: activity
    isQuantityMode: true
}
