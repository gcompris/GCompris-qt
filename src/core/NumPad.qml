import QtQuick 2.1
import QtQml.Models 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.1
import QtMultimedia 5.0
import GCompris 1.0

Column{

    id:panel
    height:parent.height - 70
    width:70
    opacity: 0.8

    property variant colours : ["#ea7025", "#67c111", "#00bde3", "#bde300","#e3004c"]
    property variant numbers: [0,1,2,3,4]
    property string productValue: ""

    Repeater {

        model:5
        Rectangle{
            width:parent.width
            height: parent.height/5
            color: colours[index]
            border.color: Qt.darker(color)

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: panel.x > (panel.parent.width - 80) ? numbers[index] + 5 :numbers[index]
                font.pixelSize: parent.height/2
            }

            MouseArea{
                id:pressedNumber
                width:parent.width
                height:parent.height
                onClicked: {
                    productValue += panel.x > (panel.parent.width - 80) ? numbers[index] + 5 :numbers[index]
                    if(productValue.length > 2)
                        productValue.length = 0
                    console.log(productValue)
                }

            }

        }
    }
}
