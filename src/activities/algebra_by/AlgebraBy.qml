/* GCompris - AlgebraBy.qml
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan <aruna.evam@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (GTK+ version)
 *   Aruna Sankaranarayanan <aruna.evam@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "../algebra_by"
import "algebra.js" as Activity

Algebra {
    onStart: {
        Activity.operandText = Activity.OperandsEnum.TIMES_SIGN
    }
}
