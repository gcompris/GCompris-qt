/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../algebra_by"
import QtQuick

AlgebraEditor {
    textActivityData: textActivityData_
    teacherInstructions: baseTeacherInstructions + ("<ul><li>") +
    qsTr('If "Random operands" is not selected, for each sublevel you must make sure that the "First operand" is greater than the "Second operand".') + ("</li></ul>")
}
