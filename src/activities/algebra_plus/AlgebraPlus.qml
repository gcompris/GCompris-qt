/* GCompris - AlgebraPlus.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "../algebra_by/"
import "../algebra_by/algebra.js" as Activity

Algebra {
    onStart: {
        Activity.operandText = Activity.OperandsEnum.PLUS_SIGN
    }
}
