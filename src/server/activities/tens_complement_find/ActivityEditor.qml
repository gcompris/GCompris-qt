/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

TensComplementFindEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('All numbers must be positive integers') + ("</li></ul><ul><li>") +

    qsTr('Do not add too many "Extra cards"! Each sublevel must not have more than 6 cards, and there is already 1 card per addition, or 2 cards per addition if "Find both numbers" is selected.') + ("</li></ul><ul><li>") +

    qsTr('If "Random questions" is not selected, "First operands" of each sublevel must contain 1, 2 or 3 numbers between 1 and 9. There is one addition for each "First operand" number.') + ("</li></ul>")
}
