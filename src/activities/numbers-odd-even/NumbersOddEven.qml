/* gcompris - NumberOddEven.qml

 SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import "../planegame"

Planegame {

    showTutorial: true

    dataset: [
        {
            data: "0 2 4 6 8 10 12 14 16 18 20".split(" "),
            showNext: true
        },
        {
            data: "1 3 5 7 9 11 13 15 17 19 21".split(" "),
            showNext: true
        },
        {
            data: "0 2 4 6 8 10 12 14 16 18 20".split(" "),
            showNext: false
        },
        {
            data: "1 3 5 7 9 11 13 15 17 19 21".split(" "),
            showNext: false
        }
    ]

    tutorialInstructions: [
                {
                    "instruction": qsTr("This activity teaches about even and odd numbers."),
                    "instructionQml": ""
                },
                {
                    "instruction": qsTr("Even numbers are numbers which leave a remainder of 0 when divided by 2."),
                    "instructionQml": ""
                },

                {
                    "instruction": qsTr("What is meant by remainder?"),
                    "instructionQml" : "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial1.qml"
                },

                {
                    "instruction": qsTr("Even numbers are numbers which leave a remainder of 0 when divided by 2."),
                    "instructionQml" : "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial2.qml"
                },
                {
                    "instruction": qsTr("Odd numbers are numbers which do not leave a remainder of 0 when divided by 2."),
                    "instructionQml": "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial3.qml"
                },
                {
                    "instruction": qsTr("Exercise to test your understanding."),
                    "instructionQml": "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial4.qml"
                },
                {
                    "instruction": qsTr("Exercise to test your understanding."),
                    "instructionQml": "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial5.qml"
                },
                {
                    "instruction":  qsTr("Exercise to test your understanding."),
                    "instructionQml": "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial6.qml"
                }

            ]
}
