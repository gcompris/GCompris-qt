/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

AdjacentNumbersEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

        qsTr('If "Random start number" is selected, the number of sublevels will be the minimum between the "Sublevels" value and the result of: ("Maximum start number" - "Minimum start number") / "Step between numbers" + 1.') + ("</li></ul><ul><li>") +

        qsTr('If "Random start number" is not selected, the "Start numbers" list must contain only numbers, and each of them will be used as start number for a sublevel.') + ("</li></ul><ul><li>") +

        qsTr('"Position of missing numbers" must contain a list of numbers corresponding to the index of numbers to find. Index numbers start from 0 (the first number of the sequence), and must not be greater than "Sequence length" - 1. Also, the length of the list can not be greater than "Sequence length" - 2, to always have at least 2 visible numbers in the sequence.') + ("</li></ul>")
}
