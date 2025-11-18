/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
BinaryBulbEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('If "Random numbers" is not selected, "Numbers to find" must contain a list of integer numbers. Each number must be between 0 and the maximum number which can be represented with the given "Bulb count".') + ("</li></ul>")
}

