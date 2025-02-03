/* GCompris - MathNumber.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: mathNumber
    property string numberValue: "0"
    property string operator: ""
    property int lineIndex: 0
    property bool droppable: false
    property int digitCount: 0
    property alias digitRepeater: digitRepeater
    property bool digitsVisible: true

    signal clickedIn(var item)

    width: items.digitWidth * (digitCount + 1)
    height: items.digitHeight

    function buildDigits(aNumber, tens, carry) {
        digitsModel.clear()
        var nCount = digitCount
        var idx = 0
        while (nCount) {
            var remainder = aNumber % 10
            aNumber = Math.floor(aNumber / 10)
            digitsModel.append({     "expected_": ((aNumber === 0) && (remainder === 0) && (idx !== 0)) ? -1 : remainder
                                   , "hasTens_": tens
                                   , "hasCarry_": (idx === 0) ? false : (items.method === VerticalSubtraction.OperationMethod.Regrouping) ? tens : carry
                                   , "droppable_": droppable
                               })
            nCount--
            idx++
        }
    }

    function checkDroppedValues() {
        var ok = true
        for (var i = 0; i < digitRepeater.count; i++) {
            var item = digitRepeater.itemAt(i)
            ok = ok && ((item.expected > 0) ? (item.expected === item.value) : true)
        }

        return ok
    }

    function copyDroppedValues() {
        for (var i = 0; i < digitRepeater.count; i++) {
            var value = digitRepeater.itemAt(i).value
            digitsModel.get(i).expected_ = value
        }
    }

    function checkEmptyDigit() {                // Check if a number has no empty digit in the middle
        var ok = true
        var finished = false
        for (var i = 0; i < digitRepeater.count; i++) {
            if (digitRepeater.itemAt(i).value === -1)
              finished = true
            else
                ok = ok && !finished && (digitRepeater.itemAt(i).value !== -1)
        }
        return ok
    }

    function clearEmptyDigit() {                // Clear unrequired zeros on the left
        var finished = false
        for (var i = 0; i < digitsModel.count; i++) {
            digitRepeater.itemAt(i).value = digitsModel.get(i).expected_
        }
    }

    function flipDroppable(drop) {  // bool
        for (var i = 0; i < digitsModel.count; i++) {
            digitsModel.get(i).droppable_ = drop
        }
    }

    function toNumberValue() {
        var str = ""
        for (var i = 0; i < digitsModel.count; i++) {
            if (digitsModel.get(i).expected_ !== -1) {
                str = String(digitsModel.get(i).expected_) + str
            }
        }
        if ((str !== "")) numberValue = str
    }

    ListModel { id: digitsModel }

    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        visible: mathNumber.digitsVisible

        Item {
            width: items.digitWidth
            height: items.digitHeight
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
            width: items.digitWidth * digitCount + 1
            height: items.digitHeight
            anchors.verticalCenter: parent.verticalCenter
            layoutDirection: Qt.RightToLeft

            Repeater {
                id: digitRepeater
                model: digitsModel
                delegate: MathDigit {
                    droppable: droppable_
                    value: droppable_ ? -1 : expected_
                    expected: expected_
                    hasTens: hasTens_
                    hasCarry: hasCarry_
                }
            }
            Component.onCompleted: {
                buildDigits(numberValue, lineIndex === 0, lineIndex === (items.nbLines - 1))
            }
        }
    }

    onNumberValueChanged: buildDigits(numberValue, lineIndex === 0, lineIndex === (items.nbLines - 1))
}
