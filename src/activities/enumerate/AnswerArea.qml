import QtQuick 2.1
import "enumerate.js" as ApplicationLogic

Image{
            property string imgPath : ""
            property string backgroundImg : "qrc:/gcompris/src/activities/enumerate/resource/enumerate_answer_focus.png"
            property string backgroundImgWithFocus : "qrc:/gcompris/src/activities/enumerate/resource/enumerate_answer.png"
            property int itemType : 0

            id: answerBackground
            focus: true
            source: activeFocus ? backgroundImgWithFocus : backgroundImg

            MouseArea{
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    answerBackground.forceActiveFocus()
                }
            }

            Rectangle{
                   id: contourRect
                   height: img.height + 12
                   width: img.width - 12
                   anchors.centerIn: img
                   color: "white"
                   opacity: mouseImageArea.containsMouse? 1.0:0.0
                   radius: 8
                Rectangle{
                    id: innerRect
                    height: contourRect.height - 4
                    width: contourRect.width - 4
                    anchors.centerIn: contourRect
                    color: "red"
                    opacity: mouseImageArea.containsMouse? 0.7:0.0
                    radius: 8
                }
            }

           Image{

               MouseArea{
                   id: mouseImageArea
                   anchors.fill: parent
                   hoverEnabled: true
                }
                    id: img
                    y: 8
                    x: 10
                    height: 52
                    width: 52
                    source: imgPath
                    fillMode : Image.PreserveAspectFit
            }

           Keys.onPressed: {
                   userEntry.text=event.text
                        if(event.text!=""){
                            ApplicationLogic.setUserAnswer(itemType,parseInt(userEntry.text))
                        }
           }

           Text{
                id: userEntry
                x: img.x + img.width + 15
                anchors.verticalCenter: img.verticalCenter
                text: "?"
                color: "blue"
                font.bold: true
                font.pixelSize: 24
           }
}

