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
import QtQuick 2.9
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
            if (Activity._operator == " + ") {
                fault +=  num1 + " + " + num2 + " = " + (num1 + num2)
            } else if (Activity._operator == " - ") {
                fault +=  num1 + " - " + num2 + " = " + (num1 - num2)
            } else if (Activity._operator == " * ") {
                fault +=  num1 + " * " + num2 + " = " + (num1 * num2)
            } else if (Activity._operator == " / ") {
                fault +=  num1 + " / " + num2 + " = " + (num1 / num2)
            }
        } else if (activity.type == "primes") {
            if (num1 === 1) {
                fault += qsTr("1 is not a prime number.")
                return
            }

            var divisors = []
            for (var div = 2; div < num1; ++div) {
                if ((num1 / div) % 1 == 0)
                    divisors.push(div)
            }

            fault += qsTr("%1 is divisible by %2").arg(num1).arg(divisors[0])

            if (divisors.length > 2) {
                for (var div = 1; div < divisors.length - 1; ++div) {
                    fault += ", " + divisors[div]
                }
            }

            fault += " " + qsTr("and") + " " + divisors[divisors.length - 1] + "."

        } else if (activity.type == "factors") {
            // First we find the multiples of the wrong number.
            var multiples = "" + num1*2 + ", " + num1*3 + ", " + num1*4

            fault += qsTr("Multiples of %1 include %2, ").arg(num1).arg(multiples)
            fault += qsTr("but %1 is not a multiple of %2.").arg(Activity.getGoal()).arg(num1)
        } else if (activity.type == "multiples") {
            // First we find divisors of the wrong number.
            var divisors = []
            for (var div = 1; div < Activity.getGoal() * 6; ++div) {
                if ((num1 / div) % 1 == 0)
                    divisors.push(div)
            }

            fault += divisors[0]

            if (divisors.length > 2) {
                for (var div = 1; div < divisors.length - 1; ++div) {
                    fault += ", " + divisors[div]
                }
            }

            fault += " " + qsTr("and %1 are the divisors of %2.").arg(divisors[divisors.length - 1]).arg(num1)
        }
    }

    width: 400 * ApplicationInfo.ratio
    height: 150 * ApplicationInfo.ratio
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
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: fault + "<br>" + qsTr("Press \"Return\" or click on me to continue.")
        fontSizeMode: Text.Fit
        minimumPointSize: 10
        fontSize: 28
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
