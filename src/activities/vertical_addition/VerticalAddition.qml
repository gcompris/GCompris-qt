/* GCompris - VerticalAddition.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
import "../vertical_subtraction"

VerticalSubtraction {
    operation: VerticalSubtraction.OperationType.Addition
    method: VerticalSubtraction.OperationMethod.Regrouping
}
