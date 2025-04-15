/* GCompris - GrammarAnalysis.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../grammar_analysis"

GrammarAnalysis {
    grammarMode: "_classes"

    activityInstruction: "<b>" + qsTr("Grammatical classes") + "</b><br><br>" +
        qsTr("Learn to identify grammatical classes.") + "<br>" +
        qsTr("Find all the words corresponding to the requested grammatical class.") + ("<br>") +
        qsTr("Select the grammatical class from the list, then select the box under a word and assign it the class.") + ("<br>") +
        qsTr("Leave the box blank if the class doesn't match.")
}
