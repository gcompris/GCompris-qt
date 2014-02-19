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
            firstOp.firstOpCalculated()
            secondOp.secondOpCalculated()
            balloon.startMoving(parent.height * 10/(Activity.currentLevel + 1))
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
                Activity.previousLevel()
                firstOp.firstOpCalculated()
                secondOp.secondOpCalculated()
                balloon.startMoving(parent.height * 10/(Activity.bar.level))
            }
            onNextLevelClicked: {
                Activity.nextLevel()
                firstOp.firstOpCalculated()
                secondOp.secondOpCalculated()
                balloon.startMoving(parent.height * 10/(Activity.bar.level))
            }
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: done.connect(Activity.nextLevel)
        }
        Balloon {
            id: balloon

        }
        NumPad {
            id:numpadLeft
            x:0
            y:0
        }

        NumPad{
            id:numpadRight
            x:parent.width - 70
            y:0
        }

        Text{
            id: firstOp
            x:90
            y:80
            font.pixelSize: 32

            function firstOpCalculated() {
                firstOp.text = Activity.firstOperand
            }


        }
        Text{
            id: multiply
            x: 150
            y:80
            font.pixelSize: 32
            text:"x"
        }

        Text{
            id: secondOp
            x: 210
            y:80
            font.pixelSize: 32


            function secondOpCalculated() {
                secondOp.text = Activity.secondOperand
            }
        }
            Text{
                id: equals
                x: 270
                y:80
                font.pixelSize: 32
                text: "="

            }
        }
    }
