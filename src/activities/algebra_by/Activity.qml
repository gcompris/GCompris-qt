import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Window 2.1
import QtMultimedia 5.0
import QtQml.Models 2.1
import "../../core"

import "qrc:/gcompris/src/core"
import "activity.js" as Activity

ActivityBase {
    id: activity
    focus: true
    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/algebra_by/resource/scenery2_background.png"
        fillMode: Image.PreserveAspectCrop
        id: background
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart:
        {
            Activity.start(main, background, bar, bonus)

        }
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
                iamReady.visible = true
                balloon.visible = false
                balloon.stopMoving()
                Activity.previousLevel()

            }
            onNextLevelClicked: {
                iamReady.visible = true
                balloon.visible = false
                balloon.stopMoving()
                Activity.nextLevel()

            }
            onHomeClicked: home()
        }

        ReadyButton{
            id:iamReady

            Component.onCompleted: {
                clickTheBox.connect(reset)
            }

            function reset()
            {
                iamReady.visible = false
                firstOp.visible = true
                secondOp.visible = true
                firstOp.firstOpCalculated()
                secondOp.secondOpCalculated()
                score.currentSubLevel = 0
                score.numberOfSubLevels = 10
                balloon.visible = true
                balloon.stopMoving()
                balloon.startMoving(balloon.parent.height * 50/(Activity.currentLevel + 1))

            }
        }

        Balloon {
            id: balloon
            visible:(!iamReady.visible)
        }

        Bonus {
            id: bonus
        }

        NumPad {
            id:numpad

            onAnswerChanged:{
                Activity.questionsLeft(numpad, score, firstOp, secondOp, balloon, iamReady)
            }
        }

        Text{
            id: firstOp
            visible:(!iamReady.visible)
            x:90
            y:80
            font.pixelSize: 32
            font.bold: true

            function firstOpCalculated() {
                firstOp.text = Activity.firstOperand
            }
        }

        Text{
            id: multiply
            x: 150
            y:80
            visible:(firstOp.visible)
            font.pixelSize: 32
            text:"x"
            font.bold: true
        }

        Text{
            id: secondOp
            x: 210
            y:80
            visible:(!iamReady.visible)
            font.pixelSize: 32
            font.bold: true
            function secondOpCalculated() {
                secondOp.text = Activity.secondOperand
            }
        }

        Text{
            id: equals
            x: 270
            y:80
            visible:(firstOp.visible)
            font.pixelSize: 32
            font.bold: true
            text: "="
        }

        Text{
            id:product
            x: 330
            y:80
            visible:(!iamReady.visible)
            font.pixelSize: 32
            font.bold: true
            text: numpad.answer
        }

        Score{
            id:score
            x: parent.width * 3/4
            y: parent.height - 100
            currentSubLevel: 0
            numberOfSubLevels:10

        }
    }
}

