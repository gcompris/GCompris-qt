import QtQuick 2.2
import GCompris 1.0

import "gnumch-equality.js" as Activity

Rectangle {
    function hideWarning() {
        if (opacity > 0) {
            opacity = 0
            if (Activity._currentLevel % 6 != 0) {
                spawningMonsters.start()
                timerActivateWarn.start()
            }
            muncher.movable = true
            monsters.setMovable(true)
        }
    }

    property string warningText: warning.text
    property string fault
    property var mArea: area

    function setFault(index) {
        if (index == -1) {
            fault = qsTr("You were eaten by a Troggle.") + "<br>"
            return
        }

        fault = qsTr("You ate a wrong number.") +"<br>"
        var num1 = modelCells.get(index).number1
        var num2 = modelCells.get(index).number2
        if (activity.type == "equality" || activity.type == "inequality") {
            if (activity.operator == " + ") {
                fault +=  num1 + " + " + num2 + " = " + (num1 + num2)
            } else {
                fault +=  num1 + " - " + num2 + " = " + (num1 - num2)
            }
        } else if (activity.type == "primes") {
            if (num1 == 1) {
                fault += 1 + " " + qsTr("is not a prime number") + "."
                return
            }

            var divisors = []
            for (var div = 2; div < num1; ++div) {
                if ((num1 / div) % 1 == 0)
                    divisors.push(div)
            }

            fault += num1 + " " + qsTr("is divisible by") + " " + divisors[0]

            if (divisors.length > 2) {
                for (var div = 1; div < divisors.length - 1; ++div) {
                    fault += ", " + divisors[div]
                }
            }

            fault += " " + qsTr("and") + " " + divisors[divisors.length - 1] + "."

        } else if (activity.type == "factors") {
            // First we find the multiples of the wrong number.
            var multiples = []
            for (var mul = 1; mul < Activity.getGoal() * 3; ++mul) {
                if ((mul / num1) % 1 == 0)
                    multiples.push(mul)
            }

            fault += multiples[0]

            if (multiples.length > 2) {
                for (var mul = 1; mul < multiples.length - 1; ++mul) {
                    fault += ", " + multiples[mul]
                }
            }

            fault += " " + qsTr("and") + " " + multiples[multiples.length - 1] + " " + qsTr("are the multiples of") + " " + num1 + ","
            fault += "<br>"
            fault += qsTr("but") + " " + num1 + " " + qsTr("is not a multiple of") + " " + Activity.getGoal() + "."
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

            fault += " " + qsTr("and") + " " + divisors[divisors.length - 1]  + qsTr(" are the divisors of ") + num1 + "."
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
    color: "#00d635"

    onOpacityChanged: {
        if (opacity == 0) {
            muncher.opacity = 1
            area.enabled = false
        } else {
            area.enabled = true
        }

    }

    Text {
        id: warning
        width: parent.width - 5
        height: parent.height - 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: fault + "<br>" + qsTr("Press <Return> or click on me to continue.") + "</p>"
        font.pointSize: ApplicationInfo.ratio * 20
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
