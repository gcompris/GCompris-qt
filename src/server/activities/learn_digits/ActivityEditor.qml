/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

LearnDigitsEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('"Numbers" must contain a list of numbers between 0 and 9.') + ("</li></ul><ul><li>") +

    qsTr('"Number of circles" can not be smaller than the largest number to find.') + ("</li></ul>")

    isOperation: false
    isAddition: false
}
