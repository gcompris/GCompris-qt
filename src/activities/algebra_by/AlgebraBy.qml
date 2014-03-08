import QtQuick 2.1

import "qrc:/gcompris/src/core"
import "activity.js" as Activity

ActivityBase {
    id: activity
    focus: true

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/algebra_by/resource/scenery2_background.png"
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: Activity.start(main, background, bar, bonus, score, balloon,
                                iAmReady, firstOp, secondOp)
        onStop: Activity.stop()

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
            onPreviousLevelClicked: {
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                Activity.nextLevel()

            }
            onHomeClicked: home()
        }

        ReadyButton {
            id: iAmReady

            onClicked: {
                iAmReady.visible = false
                firstOp.visible = true
                secondOp.visible = true
                balloon.startMoving(balloon.parent.height * 50)
            }
        }

        Balloon {
            id: balloon
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
            }
        }

        NumPad {
            id:numpad

            onAnswerChanged: {
                Activity.questionsLeft(numpad, firstOp, secondOp)
            }
        }

        Text {
            id: firstOp
            visible: !iAmReady.visible
            x:90
            y:80
            font.pixelSize: 32
            font.bold: true
        }

        Text{
            id: multiply
            x: 150
            y:80
            visible: firstOp.visible
            font.pixelSize: 32
            text: "x"
            font.bold: true
        }

        Text{
            id: secondOp
            x: 210
            y: 80
            visible: !iAmReady.visible
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            id: equals
            x: 270
            y: 80
            visible: firstOp.visible
            font.pixelSize: 32
            font.bold: true
            text: "="
        }

        Text {
            id:product
            x: 330
            y:80
            visible: !iAmReady.visible
            font.pixelSize: 32
            font.bold: true
            text: numpad.answer
        }

        Score {
            id: score
            x: parent.width * 3/4
            y: parent.height - 100
            currentSubLevel: 0
            numberOfSubLevels: 10
        }
    }
}

