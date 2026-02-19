/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

TensComplementUseEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('All numbers must be positive integers') + ("</li></ul><ul><li>") +

    qsTr('Do not add too many "Extra cards"! Each sublevel must not have more than 6 cards, and there are already 2 cards per addition.') + ("</li></ul><ul><li>") +

    qsTr('In "Additions", each entry must be an addition which first number is between 1 and 9, and which result is between 11 and 99.') + ("</li></ul>")
}

