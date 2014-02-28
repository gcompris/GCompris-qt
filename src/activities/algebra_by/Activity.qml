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

    //property bool iamReadyFlag: false
    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/algebra_by/resource/scenery2_background.png"
        fillMode: Image.PreserveAspectCrop
        id: background
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
//            if(iamReadyFlag)
//            {
                activity.start.connect(start)
                activity.stop.connect(stop)
//            }
        }

        onStart:
        {
            Activity.start(main, background, bar, bonus)
            firstOp.firstOpCalculated()
            secondOp.secondOpCalculated()
            displayScore.displayText()
            balloon.startMoving(parent.height * 50/(Activity.currentLevel + 1))
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
                balloon.startMoving(parent.height * 50/(Activity.bar.level))
            }
            onNextLevelClicked: {
                Activity.nextLevel()
                firstOp.firstOpCalculated()
                secondOp.secondOpCalculated()
                balloon.startMoving(parent.height * 50/(Activity.bar.level))
            }
            onHomeClicked: home()
        }

        Balloon {
            id: balloon

        }

        NumPad {
            id:numpad

            onAnswerChanged:{
                questionsLeft()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted:
            {
                //done.connect(Activity.nextLevel)

            }
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

        Text{
            id:product
            x: 330
            y:80
            font.pixelSize: 32
            text: numpad.answer
        }

        Rectangle{
         id:scoreBoundary
         x: parent.width * 3/4
         y: parent.height - 100
         width: 100
         height:50
         //color: '#FFFF00'
         border.color: "black"
         radius:4
         smooth:true
         border.width:2
         gradient: Gradient {
                     GradientStop { position: 0.0; color: "#FFFF66" }
                     GradientStop { position: 1.0; color: "#FFFF00" }
                 }

        Text{
            id:displayScore
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 32

            function displayText()
            {
                console.log("Display text" + Activity.score)
                if(Activity.score > 0)
                    displayScore.text = Activity.score + " / 10"
                else
                    displayScore.text = "0 / 10"
            }
        }
        }

        function questionsLeft()
        {
            if(Activity.validateAnswer(numpad.answer))
            {
                //numpad.answer =""
                numpad.resetText()
                if(Activity.totalQuestions < 2)
                {
                    Activity.totalQuestions += 1
                    Activity.score += 1
                    displayScore.displayText()
                    Activity.calculateOperands()
                    firstOp.firstOpCalculated()
                    secondOp.secondOpCalculated()
                    balloon.startMoving(parent.height * 50/(Activity.currentLevel + 1))
                    console.log("product.text")

                }

                else
                {
                    Activity.nextLevel()
                    Activity.score = 0
                    Activity.totalQuestions = 0
                    firstOp.firstOpCalculated()
                    console.log("FirstOperand()" + Activity.firstOperand)
                    secondOp.secondOpCalculated()
                    console.log("SecondOperand()" + Activity.secondOperand)
                    balloon.startMoving(parent.height * 50/(Activity.currentLevel + 1))

                    console.log("Calling bonus")
                    bonus.good("smiley");
                }


            }
        }
    }
//    Rectangle{
//        id:iamReady
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter
//        width:parent.width/5
//        height:parent.height/5
//        border.color: "black"
//        radius:4
//        smooth:true
//        border.width:2
//        gradient: Gradient {
//                    GradientStop { position: 0.0; color: "#FFFF66" }
//                    GradientStop { position: 1.0; color: "#FFFF00" }
//                }
//        MouseArea{
//            anchors.fill: parent

//            onClicked: {
//                iamReadyFlag = true
//            }
//        }


//    }

}
