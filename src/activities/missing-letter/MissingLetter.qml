/* GCompris - missing-letter.qml
 *
 * Copyright (C) 2014 "Amit Tomar" <a.tomar@outlook.com>
 *
 * Authors:
 *   "Pascal Georges" <pascal.georgis1.free.fr> (GTK+ version)
 *   "Amit Tomar" <a.tomar@outlook.com> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "missing-letter.js" as Activity

ActivityBase
{
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image
    {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

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
            property alias bar: bar
            property alias bonus: bonus
            property alias questionImage: questionImage
            property alias questionText: questionText
            property alias answers: answers
            property alias currentQuestionNumberText : currentQuestionNumberText
            property GCAudio audioVoices: activity.audioVoices
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // Option holder for buttons shown on the left of screen
        Column
        {
            id: buttonHolder
            property bool buttonHolderMouseArea : true
            spacing: 10 * ApplicationInfo.ratio
            x: holder.x - width - 10 * ApplicationInfo.ratio
            y: 30

            add: Transition {
                NumberAnimation { properties: "y"; from: 10; duration: 500 }
            }

            Repeater
            {
                id: answers

                AnswerButton {
                    width: 120 * ApplicationInfo.ratio
                    height: 80 * ApplicationInfo.ratio
                    textLabel: modelData
                    isCorrectAnswer: modelData === Activity.getCorrectAnswer()
                    onCorrectlyPressed: Activity.answerPressed(modelData)
                    onPressed: {
                        Activity.playLetter(modelData)
                        if(modelData === Activity.getCorrectAnswer()) Activity.showAnswer()
                    }
                }
            }
        }

        // Picture holder for different images being shown
        Rectangle
        {
            id: holder
            width: Math.max(questionImage.width * 1.1, questionImage.height * 1.1)
            height: questionTextBg.y + questionTextBg.height
            x: (background.width - width - 130 * ApplicationInfo.ratio) / 2 +
               130 * ApplicationInfo.ratio
            y: 20
            color: "black"
            radius: 10
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#80FFFFFF" }
                GradientStop { position: 0.9; color: "#80EEEEEE" }
                GradientStop { position: 1.0; color: "#80AAAAAA" }
            }

            Item
            {
                id: spacer
                height: 20
            }

            Image
            {
                id: questionImage
                anchors.horizontalCenter: holder.horizontalCenter
                anchors.top: spacer.bottom
                width: Math.min((background.width - 120 * ApplicationInfo.ratio) * 0.7,
                                (background.height - 100 * ApplicationInfo.ratio) * 0.7)
                height: width
            }

            Rectangle {
                id: questionTextBg
                width: holder.width
                height: questionText.height * 1.5
                anchors.horizontalCenter: holder.horizontalCenter
                anchors.margins: 20
                anchors.top: questionImage.bottom
                radius: 10
                border.width: 2
                border.color: "black"
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
            }

            GCText {
                id: questionText
                anchors {
                    horizontalCenter: questionTextBg.horizontalCenter
                    verticalCenter: questionTextBg.verticalCenter
                }
                style: Text.Outline; styleColor: "black"
                color: "white"
                fontSize: largeSize

                states: [
                    State {
                        name: "question"
                        PropertyChanges {
                            target: questionText
                            scale: 1.0
                            rotation: 0
                        }
                    },
                    State {
                        name: "answer"
                        PropertyChanges {
                            target: questionText
                            scale: 1.6
                        }
                    }
                ]

                Behavior on scale { NumberAnimation { duration: 200 } }
            }

        }

        // Counter of progress within this level
        Rectangle
        {
            width: 130 * 0.7 * ApplicationInfo.ratio
            height: 70 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 10
            }
            radius: 10
            border.width: 3
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fdf1aa" }
                GradientStop { position: 0.1; color: "#fcec89" }
                GradientStop { position: 0.4; color: "#f8d600" }
                GradientStop { position: 1.0; color: "#f8d600" }
            }

            GCText {
                id: currentQuestionNumberText
                anchors.centerIn: parent
                fontSize: largeSize
                style: Text.Outline; styleColor: "white"
                color: "black"
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
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus
        {
            id: bonus
            Component.onCompleted:
            {
                win.connect(Activity.correctOptionPressed)
                loose.connect(Activity.wrongOptionPressed)
            }
        }
    }
}
