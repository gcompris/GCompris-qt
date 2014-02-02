import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
import "activity.js" as Activity

ActivityBase {
    id: activity
    focus: true
    property string type: "erase"

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/erase/resource/" + Activity.getFirstImage()

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: Activity.start(main, background, bar, bonus, type)

        onStop: { Activity.stop() }

        MultiPointTouchArea {
            anchors.fill: parent
            onTouchUpdated: {

                for(var i in touchPoints) {
                    var touch = touchPoints[i]

                    var newBlock = background.childAt(touch.x, touch.y)
                    if(newBlock)
                        newBlock.enter()

                    var previousBlock = background.childAt(touch.previousX, touch.previousY)
                    if(previousBlock !== newBlock)
                        previousBlock.leave()
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: done.connect(Activity.nextSubLevel)
        }
    }

}
