/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

OrderingNumbersEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('Always supply numbers in ascending order (e.g., 1, 2, 3); the sorting direction parameter handles reversing to descending (3, 2, 1).') + ("</li></ul><ul><li>") +

    qsTr('At least two numbers must be entered.') + ("</li></ul><ul><li>") +

    qsTr('All numbers must be integers.')

}