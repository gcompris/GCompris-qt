/* GCompris - Warning.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"
import "gnumch-equality.js" as Activity

Rectangle {
    id: warning
    property alias warningText: textItem.text
    property string fault
    property int firstNumber
    property int secondNumber
    property string type

    function setFault(index: int) {
        if (index === -1) {
            fault = qsTr("You were eaten by a Troggle.") + "<br>"
            return
        }

        fault = qsTr("You ate a wrong number.") +"<br>"
        if (type == "equality" || type == "inequality") {
            if (Activity.operator === " + ") {
                fault +=  firstNumber + " + " + secondNumber + " = " + (firstNumber + secondNumber)
            } else if (Activity.operator === " - ") {
                fault +=  firstNumber + " - " + secondNumber + " = " + (firstNumber - secondNumber)
            } else if (Activity.operator === " * ") {
                fault +=  firstNumber + " * " + secondNumber + " = " + (firstNumber * secondNumber)
            } else if (Activity.operator === " / ") {
                fault +=  firstNumber + " / " + secondNumber + " = " + (firstNumber / secondNumber)
            }
            fault += "<br>"

        } else if (type === "primes") {
            if (firstNumber === 1) {
                fault += qsTr("1 is not a prime number.") + "<br>"
                return
            }

            var divisors = []
            for (var div = 2; div < firstNumber; ++div) {
                if ((firstNumber / div) % 1 == 0)
                    divisors.push(div)
            }
            var divisorString = "<ul>"
            for (var div = 0; div < divisors.length; ++div) {
                divisorString += "<li>" + divisors[div] + "</li>"
            }
            divisorString += "</ul>"
            //: the first argument corresponds to a number and the second argument corresponds to its divisors formatted as an unordered html format (<ul><li>number 1</li>...</ul>)
            fault += qsTr("%1 is a non-prime number, its divisors are: %2").arg(firstNumber).arg(divisorString)

        } else if (type == "factors") {
            //: %1 is the number to find, %2 and %3 are two multiples of the number, %4 is a wrong number and %5 is the number to find.
            fault += qsTr("Multiples of %1 include %2 or %3 but %4 is not a multiple of %5.").arg(firstNumber).arg(firstNumber*2).arg(firstNumber*3).arg(Activity.getGoal()).arg(firstNumber) + "<br>"

        } else if (type == "multiples") {
            // First we find divisors of the wrong number.
            var divisors = []
            for (var div = 1; div < Activity.getGoal() * 6; ++div) {
                if ((firstNumber / div) % 1 == 0)
                    divisors.push(div)
            }
            var divisorString = "<ul>"
            for (var div = 0; div < divisors.length; ++div) {
                divisorString += "<li>" + divisors[div] + "</li>"
            }
            divisorString += "</ul>"
            //: the first argument corresponds to a number and the second argument corresponds to its divisors formatted as an unordered html format (<ul><li>number 1</li>...</ul>
            fault += qsTr("Divisors of %1 are: %2").arg(firstNumber).arg(divisorString)

        }
    }

    width: textItem.contentWidth + 2 * GCStyle.baseMargins
    height: textItem.contentHeight + GCStyle.baseMargins
    z: 3
    border.width: GCStyle.midBorder
    border.color: GCStyle.blueBorder
    radius: GCStyle.halfMargins
    opacity: 0
    color: GCStyle.paperWhite

    GCText {
        id: textItem
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: warning.fault + qsTr("Press \"Return\" or click on me to continue.")
        textFormat: Text.RichText
        width: Math.min(400 * ApplicationInfo.ratio, warning.parent.width * 0.7)
        height: warning.parent.height * 0.8
        fontSize: smallSize
        wrapMode: Text.WordWrap
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: warning.opacity == 1
        onClicked: Activity.hideWarning();
    }
}
