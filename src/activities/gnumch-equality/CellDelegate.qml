import QtQuick 2.2
import QtQuick.Controls 1.1
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
                if (activity.type == "equality" || activity.type == "inequality") {

                } else if (activity.type == "primes" ||
                           activity.type == "factors"||
                           activity.type == "multiples") {
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

            Text {
                id: numberText

                anchors.fill: parent
                anchors.margins: ApplicationInfo.ratio * 5

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                style: Text.Outline
                styleColor: "white"
                visible: show

                fontSizeMode: Text.Fit
                minimumPointSize: 7
                font.pointSize: 28
                maximumLineCount: 1

                text: num1 + operator + num2
            }
        }
    }
}
