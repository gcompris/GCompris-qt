/* GCompris - Warning.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "gnumch-equality.js" as Activity

Rectangle {
    function hideWarning() {
        if (opacity > 0) {
            opacity = 0;
            monsters.destroyAll();
            if(topPanel.life.opacity == 1) {
                topPanel.life.opacity = 0
                if(background.withMonsters) {
                    spawningMonsters.restart()
                }
            }
            else
                background.initLevel()
        }
    }

    property string warningText: warning.text
    property string fault
    property var mArea: area

    function setFault(index) {
        if (index === -1) {
            fault = qsTr("You were eaten by a Troggle.") + "<br>"
            return
        }

        fault = qsTr("You ate a wrong number.") +"<br>"
        var num1 = modelCells.get(index).number1
        var num2 = modelCells.get(index).number2
        if (activity.type == "equality" || activity.type == "inequality") {
            if (Activity.operator == " + ") {
                fault +=  num1 + " + " + num2 + " = " + (num1 + num2)
            } else if (Activity.operator == " - ") {
                fault +=  num1 + " - " + num2 + " = " + (num1 - num2)
            } else if (Activity.operator == " * ") {
                fault +=  num1 + " * " + num2 + " = " + (num1 * num2)
            } else if (Activity.operator == " / ") {
                fault +=  num1 + " / " + num2 + " = " + (num1 / num2)
            }
            fault += "<br>"

        } else if (activity.type == "primes") {
            if (num1 === 1) {
                fault += qsTr("1 is not a prime number.") + "<br>"
                return
            }

            var divisors = []
            for (var div = 2; div < num1; ++div) {
                if ((num1 / div) % 1 == 0)
                    divisors.push(div)
            }
            var divisorString = "<ul>"
            for (var div = 0; div < divisors.length; ++div) {
                divisorString += "<li>" + divisors[div] + "</li>"
            }
            divisorString += "</ul>"
            //: the first argument corresponds to a number and the second argument corresponds to its divisors formatted as an unordered html format (<ul><li>number 1</li>...</ul>)
            fault += qsTr("%1 is a non-prime number, its divisors are: %2").arg(num1).arg(divisorString)

        } else if (activity.type == "factors") {
            //: %1 is the number to find, %2 and %3 are two multiples of the number, %4 is a wrong number and %5 is the number to find.
            fault += qsTr("Multiples of %1 include %2 or %3 but %4 is not a multiple of %5.").arg(num1).arg(num1*2).arg(num1*3).arg(Activity.getGoal()).arg(num1) + "<br>"

        } else if (activity.type == "multiples") {
            // First we find divisors of the wrong number.
            var divisors = []
            for (var div = 1; div < Activity.getGoal() * 6; ++div) {
                if ((num1 / div) % 1 == 0)
                    divisors.push(div)
            }
            var divisorString = "<ul>"
            for (var div = 0; div < divisors.length; ++div) {
                divisorString += "<li>" + divisors[div] + "</li>"
            }
            divisorString += "</ul>"
            //: the first argument corresponds to a number and the second argument corresponds to its divisors formatted as an unordered html format (<ul><li>number 1</li>...</ul>
            fault += qsTr("Divisors of %1 are: %2").arg(num1).arg(divisorString)

        }
    }

    width: warning.paintedWidth + 10 * ApplicationInfo.ratio
    height: warning.paintedHeight + 10 * ApplicationInfo.ratio
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    z: 3
    border.width: 2
    radius: 5
    opacity: 0
    color: "#82E599"

    onOpacityChanged: {
        if (opacity == 0) {
            muncher.opacity = 1
            area.enabled = false
        } else {
            area.enabled = true
        }

    }

    GCText {
        id: warning
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: fault + qsTr("Press \"Return\" or click on me to continue.")

        textFormat: Text.RichText
        width: Math.min(400 * ApplicationInfo.ratio, background.width * 0.7)
        height: background.height * 0.8
        fontSize: smallSize
        wrapMode: Text.WordWrap
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent

        enabled: false
    }
}
