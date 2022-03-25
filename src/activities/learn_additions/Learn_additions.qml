/* GCompris - learn_additions.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "../learn_digits/"
import "../learn_digits/learn_digits.js" as Activity

Learn_digits {
    id: activity
    operationMode: true
}
