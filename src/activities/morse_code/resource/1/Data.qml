/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Letters.")
    difficulty: 3
    data: [
    		{
                values: ["_random_",["A", "R", "N", "E", "H", "S", "I"]],
                question: qsTr("Send the message %1 in Morse code."),
                toAlpha: false
            },
            {
                values: ["_random_",[".-", "-.", ".-.", ".", "..", "...", "...."]],
                question: qsTr("Convert the message %1 to letters."),
                toAlpha: true
            },
            {
                values: ["_random_",[".-", "-.", ".-.", ".", "..", "...", "...."]],
                question: qsTr("Find the corresponding letter."),
                audioMode: true,
                toAlpha: true
            },
            {
                values: ["_random_",["O","T","M","W","G","K"]],
                question: qsTr("Send the message %1 in Morse code."),
                toAlpha: false
            },
            {
                values: ["_random_",["-","--","---",".--","--.","-.-"]],
                question: qsTr("Convert the message %1 to letters."),
                toAlpha: true
            },
            {
                values: ["_random_",["-","--","---",".--","--.","-.-"]],
                question: qsTr("Find the corresponding letter."),
                audioMode: true,
                toAlpha: true
            },
            {
                values: ["_random_",["C","P","B","V","D","U"]],
                question: qsTr("Send the message %1 in Morse code."),
                toAlpha: false
            },
            {
                values: ["_random_",["-...","...-","-.-.","-..","..-",".--."]],
                question: qsTr("Convert the message %1 to letters."),
                toAlpha: true
            },
            {
                values: ["_random_",["-...","...-","-.-.","-..","..-",".--."]],
                question: qsTr("Find the corresponding letter."),
                audioMode: true,
                toAlpha: true
            },
            {
                values: ["_random_",["J","F","L","Q","X","Y","Z"]],
                question: qsTr("Send the message %1 in Morse code."),
                toAlpha: false
            },
            {
                values: ["_random_",[".---","..-.",".-..","--.-","-..-","-.--","--.."]],
                question: qsTr("Convert the message %1 to letters."),
                toAlpha: true
            },
            {
                values: ["_random_",[".---","..-.",".-..","--.-","-..-","-.--","--.."]],
                question: qsTr("Find the corresponding letter."),
                audioMode: true,
                toAlpha: true
            }
    ]
}
