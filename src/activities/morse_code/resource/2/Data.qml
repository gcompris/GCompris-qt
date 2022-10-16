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
    objective: qsTr("Digits.")
    difficulty: 3
    data: [
        {
            values: ["_random_",["1", "2", "3", "4", "5"]],
            question: qsTr("Send the message %1 in Morse code."),
            toAlpha: false
        },
        {
            values: ["_random_",[".----","..---","...--","....-","....."]],
            question: qsTr("Convert the message %1 to digits."),
            toAlpha: true
        },
        {
            values: ["_random_",[".----","..---","...--","....-","....."]],
            question: qsTr("Find the corresponding digit."),
            audioMode: true,
            toAlpha: true
        },
        {
            values: ["_random_",["6", "7", "8", "9", "0"]],
            question: qsTr("Send the message %1 in Morse code."),
            toAlpha: false
        },
        {
            values: ["_random_",["-....","--...","---..","----.","-----"]],
            question: qsTr("Convert the message %1 to digits."),
            toAlpha: true
        },
        {
            values: ["_random_",["-....","--...","---..","----.","-----"]],
            question: qsTr("Find the corresponding digit."),
            audioMode: true,
            toAlpha: true
        }
    ]
}
