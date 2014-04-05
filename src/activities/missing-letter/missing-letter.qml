/* GCompris - missing-letter.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "qrc:/gcompris/src/core"
import "missing-letter.js" as Activity
import QtMultimedia 5.0


ActivityBase
{
    id: activity

    onStart: focus = true
    onStop: {}

    property string currentQuestion         : ""
    property string currentAnswer           : ""
    property string currentOption           : ""
    property string currentPictureSource    : ""

    pageComponent: Rectangle
    {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted:
        {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject
        {
            id: items
            property Item  main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias buttonHolderMouseArea: buttonHolder.buttonHolderMouseArea
            property alias currentQuestionNumberText : currentQuestionNumberText
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // Take appropriate action based on the character being pressed
        function optionPressed ( character )
        {
            var i = 0
            for(  ; i < currentQuestion.length ; ++i )
            {
                if( "_" == currentQuestion.charAt(i)  )
                {
                    break;
                }
            }

            buttonHolder.buttonHolderMouseArea = false
            bar.opacity = 0

            // Correct option pressed
            if( character === currentAnswer.charAt(i) )
            {
                currentQuestion = currentAnswer                

                if( 0 == Activity.currentQuestionNumber % 6 )
                    good.play()
                else if( 1 == Activity.currentQuestionNumber % 6 )
                    great.play()
                else if( 2 == Activity.currentQuestionNumber % 6 )
                    awesome.play()
                else if( 3 == Activity.currentQuestionNumber % 6 )
                    congratulation.play()
                else if( 4 == Activity.currentQuestionNumber % 6 )
                    fantastic.play()
                else if( 5 == Activity.currentQuestionNumber % 6 )
                    perfect.play()
                else
                    waytogo.play()

                items.bonus.good("flower")
            }

            // Incorrect option pressed
            else
            {
                check_answer.play()
                items.bonus.bad("flower")
            }
        }

        // Reset all questions of a given level
        function resetQuestionsOfLevel(level)
        {
            for( var i = 0 ; i < Activity.questionList().length ; ++ i )
            {
                if( level === Activity.questionList()[i].level )
                Activity.questionList()[i].questionAsked = false;
            }
        }

        // Reset all questions of game
        function resetAllQuestions()
        {
            for( var i = 0 ; i < Activity.questionList().length ; ++ i )
            {
                Activity.questionList()[i].questionAsked = false;
            }
        }

        function totalQuestionsInLevel(level)
        {
            var total = 0;
            for( var i = 0 ; i < Activity.questionList().length ; ++ i )
            {
                if( level === Activity.questionList()[i].level )
                    ++ total
            }

            return total
        }

        // Reset the screen values for next question
        function nextQuestion()
        {
            optionsModel.clear()
            var questionNumber = Activity.getNextRandomQuestionNumber( Activity.currentLevel + 1 )

            // If all the questions are over for this level, go to next level and then ask for next question
            if(  questionNumber < 0 && Activity.currentLevel+1 <= Activity.numberOfLevel )
            {
                currentQuestion = currentAnswer
                resetAllQuestions()
                Activity.nextLevel()
                nextQuestion()
            }


            // If there are still questions left for this level, ask for the number
            else
            {
                var choice = Activity.questionList()[questionNumber].choiceString

                for( var i = 0 ; i < choice.length ; ++i )
                {
                    optionsModel.insert(0,{ "option" : "" + choice.charAt(i)})
                }

                currentQuestion = Activity.questionList()[questionNumber].questionString
                currentAnswer = Activity.questionList()[questionNumber].answerString
                currentPictureSource = Activity.questionList()[questionNumber].pictureSource
                currentOption = Activity.questionList()[questionNumber].choiceString
            }
        }

        // Add a new level which contains all the questions given in the questions list, combined together.
        function addLastLevel()
        {
            var length = Activity.questionList().length

            for( var i =0 ; i < length ; ++ i)
            {
                var obj =
                {
                       "questionString": Activity.questionList()[i].questionString,
                       "answerString"  : Activity.questionList()[i].answerString,
                       "choiceString"  : Activity.questionList()[i].choiceString,
                       pictureSource   : Activity.questionList()[i].pictureSource,
                       level           : Activity.numberOfLevel,
                       questionAsked   : false
                }

                Activity.questionList().push ( obj )
            }
        }

        // Picture holder for different images being shown
        Image
        {   id: bgImage
            source: "qrc:/gcompris/src/activities/missing-letter/resource/missingletter-bg.png"
            width: parent.width * .55
            height: parent.height * .85
            anchors { right: parent.right ; bottom: parent.bottom ; bottomMargin: 50 ; rightMargin: 10 }

            Image
            {
                source: currentPictureSource
                anchors{ top: parent.top ; horizontalCenter: parent.horizontalCenter ; topMargin: parent.height * .05 }
                width: parent.width * .60
                height: width
            }

            Text
            {
                id: questionText
                text: qsTr(currentQuestion)
                anchors{ horizontalCenter: parent.horizontalCenter ; bottom: parent.bottom ; bottomMargin: parent.height * .08}
                color: "white"
                font.pixelSize: parent.width * .10
            }
        }

        // Option holder for buttons shown on the left of screen
        Column
        {
             id: buttonHolder
             property bool buttonHolderMouseArea : true
             spacing: 10
             anchors { left: parent.left ; top: parent.top ; leftMargin: parent.width * .15 ; topMargin: parent.height * .05 }

             add: Transition
             {
                     NumberAnimation { properties: "y"; from: 10; duration: 500 }
             }

             Repeater
             {
                 id: options
                 model: ListModel { id: optionsModel }

                 Image
                 {
                     source: "qrc:/gcompris/src/activities/missing-letter/resource/button.png"
                     width: activity.width * .10
                     height: width

                     Text { text: option ; color : "white" ; font.pixelSize: activity.width * .08; anchors.centerIn: parent }

                     MouseArea
                     {
                         id: buttonMouseArea
                         anchors.fill: parent
                         enabled: buttonHolder.buttonHolderMouseArea
                         onClicked:
                         {
                            optionPressed(option)
                            parent.source = "qrc:/gcompris/src/activities/missing-letter/resource/button_selected.png"
                         }

                         onEnabledChanged:
                         {
                             if( true == enabled )
                                 parent.source = "qrc:/gcompris/src/activities/missing-letter/resource/button.png"
                         }
                     }
                 }
             }
         }

        // Solved questions enumerator at a level
        Image
        {
            source: "qrc:/gcompris/src/activities/missing-letter/resource/enumerate_answer.png"
            scale: .85
            anchors{ right: parent.right ; bottom: parent.bottom; }

            Text
            {
                id: currentQuestionNumberText
                anchors.centerIn: parent
                text: "1/" + background.totalQuestionsInLevel(1)
                font.pixelSize: 35
                color: "white"
            }
        }

        DialogHelp
        {
            id: dialogHelp
            onClose: home()
        }

        Bar
        {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked:
            {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked:
            {
                background.resetAllQuestions()
                Activity.previousLevel()
                optionsModel.clear()
                background.nextQuestion()
                Activity.currentQuestionNumber = 1
                currentQuestionNumberText.text = "1/" + background.totalQuestionsInLevel(Activity.currentLevel+1)
            }
            onNextLevelClicked:
            {
                background.resetAllQuestions()
                Activity.nextLevel()
                optionsModel.clear()
                background.nextQuestion()
                Activity.currentQuestionNumber = 1
                currentQuestionNumberText.text = "1/" + background.totalQuestionsInLevel(Activity.currentLevel+1)
            }
            onHomeClicked: activity.home()
        }

        Bonus
        {
            id: bonus
            Component.onCompleted:
            {
                Activity.currentLevel = 0
                background.addLastLevel()
                win.connect(Activity.correctOptionPressed)
                loose.connect(Activity.wrongOptionPressed)

                // Generate first question
                background.nextQuestion()
            }
        }

        Audio
        {
            id: awesome
            source: "qrc:/gcompris/src/activities/missing-letter/resource/awesome.ogg"
            onError: console.log("brick play error: " + errorString)
        }

        Audio
        {
            id: congratulation
            source: "qrc:/gcompris/src/activities/missing-letter/resource/congratulation.ogg"
            onError: console.log("tux play error: " + errorString)
        }

        Audio
        {
            id: fantastic
            source: "qrc:/gcompris/src/activities/missing-letter/resource/fantastic.ogg"
            onError: console.log("youcannot play error: " + errorString)
        }

        Audio
        {
            id: good
            source: "qrc:/gcompris/src/activities/missing-letter/resource/good.ogg"
            onError: console.log("youcannot play error: " + errorString)
        }

        Audio
        {
            id: great
            source: "qrc:/gcompris/src/activities/missing-letter/resource/great.ogg"
            onError: console.log("youcannot play error: " + errorString)
        }

        Audio
        {
            id: perfect
            source: "qrc:/gcompris/src/activities/missing-letter/resource/perfect.ogg"
            onError: console.log("youcannot play error: " + errorString)
        }

        Audio
        {
            id: waytogo
            source: "qrc:/gcompris/src/activities/missing-letter/resource/waytogo.ogg"
            onError: console.log("youcannot play error: " + errorString)
        }

        Audio
        {
            id: check_answer
            source: "qrc:/gcompris/src/activities/missing-letter/resource/check_answer.ogg"
            onError: console.log("youcannot play error: " + errorString)
        }
    }
}
