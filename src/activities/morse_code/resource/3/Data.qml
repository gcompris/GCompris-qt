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
    objective: qsTr("Words.")
    difficulty: 4
    data: [
        {
            values: ["_random_",["CAT", "SING", "BEE", "RED", "WHAT"]],
            question: qsTr("Send the message %1 in Morse code."),
            audioMode: false,
            toAlpha: false
        },
        {
            values: ["_random_",["CAT", "SING", "BEE", "RED", "WHAT"]],
            question: qsTr("Write the Morse code you hear."),
            audioMode: true,
            toAlpha: false
        },
        {
            values: ["_random_",["-.-. .- -", // CAT
                                 "... .. -. --.", // SING
                                 "-... . .", // BEE
                                 ".-. . -..", // RED
                                 ".-- .... .- -"]], // WHAT
            question: qsTr("Convert the message in a word."),
            audioMode: true,
            toAlpha: true
        }
    ]
}
