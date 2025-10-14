/* GCompris - MathNumber.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com> (simplification from the one in activities)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import core 1.0

import "../../../core/"

Item {
    id: mathNumber
    required property var numberValue
    property string operator: ""
    property int lineIndex: 0
    property int digitCount: 0
    property alias digitRepeater: digitRepeater
    property bool digitsVisible: true

    signal clickedIn(var item)

    width: digitWidth * (digitCount + 1)
    height: digitHeight

    property int digitWidth: 50
    property int digitHeight: 50

    function buildDigits(aNumber) {
        digitsModel.clear()
        var idx = 0
        for (idx; idx < aNumber.length; ++idx) {
            var currentDigit = aNumber[idx];
            digitsModel.append({     "expected_": currentDigit.expected,
                                     "tensValue_": currentDigit.tensValue,
                                     "carryValue_": currentDigit.carryValue,
                                     "value_": currentDigit.value
                               })
        }
    }

    ListModel { id: digitsModel }

    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        visible: mathNumber.digitsVisible

        Item {
            width: mathNumber.digitWidth
            height: mathNumber.digitHeight
            visible: (lineIndex !== 0) && (lineIndex !== -1)
            GCText {
                id: operatorValue
                text: (lineIndex === 0) ? "" : operator
                anchors.centerIn: parent
                width: parent.width * 0.5
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: largeSize
                fontSizeMode: Text.Fit
            }
        }

        Flow {
            id: number
            width: mathNumber.digitWidth * digitCount + 1
            height: mathNumber.digitHeight
            anchors.verticalCenter: parent.verticalCenter
            layoutDirection: Qt.RightToLeft

            Repeater {
                id: digitRepeater
                model: digitsModel
                delegate: MathDigit {
                    required property int expected_
                    required property int value_
                    required property int tensValue_
                    required property int carryValue_
                    value: value_
                    expected: expected_
                    tensValue: tensValue_
                    carryValue: carryValue_
                    digitWidth: mathNumber.digitWidth
                    digitHeight: mathNumber.digitHeight
                }
            }
            Component.onCompleted: {
                buildDigits(numberValue)
            }
        }
    }

    onNumberValueChanged: {
        buildDigits(numberValue)
    }
}
