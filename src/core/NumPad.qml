import QtQuick 2.1
import QtQuick.Controls 1.0
import GCompris 1.0

Item {

    id: containerPanel
    anchors.fill: parent

    property variant colours: ["#ea7025", "#67c111", "#00bde3", "#bde300","#e3004c"]
    property variant numbers: [0,1,2,3,4]
    property string answer: ""
    property bool answerFlag: true

    signal answer

    Column {

        id: leftPanel
        height: parent.height - 70
        width: 70 * ApplicationInfo.ratio
        opacity: 0.8

        Repeater {
            model:5

            Rectangle{
                width: parent.width
                height: parent.height/5
                color: colours[index]
                border.color: Qt.darker(color)

                Text{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: numbers[index]
                    font.pointSize: 28
                    font.bold: true
                }

                MouseArea{
                    anchors.fill:parent

                    onClicked :{
                        if(answer.length < 2)
                            answer += numbers[index]
                    }
                }

            }
        }
    }

    Column {

        id: rightPanel
        height: parent.height - 70 * ApplicationInfo.ratio
        width: 70 * ApplicationInfo.ratio
        x: parent.width - 70 * ApplicationInfo.ratio
        opacity: 0.8

        Repeater {
            model: 5

            Rectangle {
                width: parent.width
                height: parent.height/5
                color: colours[index]
                border.color: Qt.darker(color)

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: numbers[index] + 5
                    font.pointSize: 28
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if(answer.length < 2)
                            answer += numbers[index] + 5
                    }
                }
            }
        }
        Rectangle {
            id: backspaceButton
            width: parent.width
            height: containerPanel.height - rightPanel.height
            color: "white"
            border.color: "black"
            border.width: 3

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: "←"
                font.pointSize: 28
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    answer = answer.substring(0,answer.length - 1)
                }
            }

        }
    }

    function resetText()
    {
        answer = ""
    }
}
