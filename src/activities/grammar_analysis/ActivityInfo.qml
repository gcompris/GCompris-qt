/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "grammar_analysis/GrammarAnalysis.qml"
    difficulty: 3
    icon: "grammar_analysis/be.root.svg"
    author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
    //: Activity title
    title: qsTr("Grammatical analysis")
    //: Help title
    description: qsTr("Learn to classify words according to their nature (grammatical class).")
    //intro: "put here in comment the text for the intro voice"
    //: Help goal
    goal:  qsTr("Classify words according to their nature (grammatical class).") + ("<br>") +
           qsTr("Assigns to each requested word a grammatical class.") + ("<br>") +
           qsTr("Leave blank if no class matches.")
    //: Help prerequisite
    prerequisite: ""
    //: Help manual
    manual:   qsTr("Classify words according to their nature.") + ("<br>") +
              qsTr("<b>Keyboard controls:</b>") + "<ul>" +
              "<li>" +qsTr("Up/down arrows and tabulation to switch between nature and words") + "</li>" +
              "<li>" +qsTr("Left and right arrows select element in nature and words") + "</li>" +
              "<li>" +qsTr("Space drops selected nature to current word and move to next word") + "</li>" +
              "<li>" +qsTr("Backspace move to previous word") + "</li>" +
              ("</ul>")
    credit: ""
    section: "reading words"
    createdInVersion: 40000
}
