/* GCompris - MathNumber.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "subtraction.js" as Activity

Rectangle {
    property string numberValue: "0"
    property string operator: ""
    property int lineIndex: 0
    property bool droppable: false
    property int digitCount: 0
    property alias digitRepeater: digitRepeater

    signal clickedIn(var item)

    width:(Activity.digitHeight * Activity.ratioWH + number.spacing) * (digitCount + 1)
    height: Activity.digitHeight + 5
    color: "transparent"

    function buildDigits(aNumber, tens, carry) {
        digitsModel.clear()
        var nCount = digitCount
        var idx = 0
        while (nCount) {
            var remainder = aNumber % 10
            aNumber = Math.floor(aNumber / 10)
            digitsModel.append({     "expected_": ((aNumber === 0) && (remainder === 0) && (idx !== 0)) ? -1 : remainder
                                   , "hasTens_": tens
                                   , "hasCarry_": (idx === 0) ? false : (items.method) ? tens : carry
                                   , "droppable_": droppable
                               })
            nCount--
            idx++
        }
    }

    function checkDroppedValues() {
        var ok = true
        for (var i = 0; i < digitRepeater.count; i++) {
            ok &= (digitRepeater.itemAt(i).expected === digitRepeater.itemAt(i).value)
        }
        return ok
    }

    function copyDroppedValues() {
        for (var i = 0; i < digitRepeater.count; i++) {
            var value = digitRepeater.itemAt(i).value
            digitsModel.get(i).expected_ = value
        }
    }

    function checkSelfValues() {
        var ok = true
        var finished = false
        for (var i = 0; i < digitRepeater.count; i++) {
            if (digitRepeater.itemAt(i).value === -1)
              finished = true
            else
                ok &= (!finished && (digitRepeater.itemAt(i).value !== -1))
        }
        return ok
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
        x: 20
        y: 20
        anchors.right: parent.right

        Rectangle {
            width: Activity.digitHeight * Activity.ratioWH
            height: Activity.digitHeight
            color: "moccasin"
            radius: 5
            visible: (lineIndex !== 0) && (lineIndex !== -1)
            GCText {
                id: operatorValue
                text: (lineIndex === 0) ? "" : operator
                width: parent.width / 2
                height: Activity.digitHeight
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                fontSize: mediumSize
            }
        }

        Flow {
            id: number
            width: (Activity.digitHeight * Activity.ratioWH + spacing) * digitCount
            height: Activity.digitHeight
            anchors.margins: 5
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
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

    Text {
        anchors.left: parent.right
        anchors.bottom: parent.bottom
        visible: items.debug
        text: numberValue
    }

    onNumberValueChanged: buildDigits(numberValue, lineIndex === 0, lineIndex === (items.nbLines - 1))
}
