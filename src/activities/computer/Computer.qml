import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "computer.js" as Activity

ActivityBase {
    id: activity
    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/computer/resource/background.svgz"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus

            property bool hoverEnabled : false
          }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Column
        {
            id : column
            anchors.centerIn: parent
            spacing : 5
            Repeater{
                model : ["easy","medium","hard","difficult"]
                Rectangle{
                    height : 50
                    width : 100
                    color : "white"
                    Text{
                        text : modelData
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:
                        {
                            column.visible = false
                            var component = Qt.createComponent(modelData + ".qml")
                            var window    = component.createObject(background)
                            window.show()
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | level
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
        }     
    }
}

