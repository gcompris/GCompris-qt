import QtQuick 2.2
import GCompris 1.0

Item {
    property Component delegate: cellDelegate

    Component {
        id: cellDelegate
        Rectangle {
            id: cellRectangle

            property string num1: number1
            property string num2: number2
            property string operator: activity.operator

            function setText() {
                numberText.font.pointSize = height/3
                if (height*2 > width) {
                    numberText.font.pointSize = width/4
                }
                if (activity.type == "equality" || activity.type == "inequality") {

                } else if (activity.type == "primes" || activity.type == "factors"|| activity.type == "multiples") {
                    num2 = ""
                    operator = ""
                }
            }

            width: grid.cellWidth
            height: grid.cellHeight
            border.color: "black"
            border.width: 2
            radius: 5
            color: "transparent"
            focus: false
            Component.onCompleted: setText()
            onWidthChanged: {
                if (height > 0) {
                    numberText.font.pointSize = height/3
                    if (height*2 > width) {
                        numberText.font.pointSize = width/4
                    }
                }
            }

            Text {
                id: numberText

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                style: Text.Sunken
                styleColor: "green"
                visible: show

                text: num1 + operator + num2
            }
        }
    }
}
