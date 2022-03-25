/* GCompris - AlgebraDiv.qml
 * 
 * SPDX-FileCopyrightText: 2015 Sayan Biswas <techsayan01@gmail.com>
 *
 * Authors:
 *   Sayan Biswas (Qt version)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "../algebra_by/"
import "../algebra_by/algebra.js" as Activity

Algebra {
    onStart: {
        Activity.operandText = Activity.OperandsEnum.DIVIDE_SIGN
    }
}
