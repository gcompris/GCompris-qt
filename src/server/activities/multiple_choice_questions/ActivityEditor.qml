/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

MultipleChoiceEditor {
    textActivityData: textActivityData_
    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('In "Single answer" mode, users can select only one answer. In "Multiple answers" mode, they can select multiple answers.') + ("</li></ul><ul><li>") +

    qsTr('All entries in the "Correct answers" list must also be present in the "Answers" list.') + ("</li></ul><ul><li>") +

    qsTr('"Correct answer text" and "Wrong answer text" are optional messages displayed after users validate their answer. You can leave those empty if you want.') + ("</li></ul>")
}
