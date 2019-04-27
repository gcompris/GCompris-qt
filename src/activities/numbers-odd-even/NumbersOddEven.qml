/* gcompris - NumberOddEven.qml

 Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.6
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
                    "instruction": qsTr("Even numbers are numbers which leave remainder 0 when divided by 2."),
                    "instructionQml": ""
                },

                {
                    "instruction": qsTr("What is meant by remainder of a number?"),
                    "instructionQml" : "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial1.qml"
                },

                {
                    "instruction": qsTr("Even numbers are numbers which leave remainder 0 when divided by 2."),
                    "instructionQml" : "qrc:/gcompris/src/activities/numbers-odd-even/resource/Tutorial2.qml"
                },
                {
                    "instruction": qsTr("Odd numbers are numbers which do not leave remainder 0 when divided by 2."),
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
