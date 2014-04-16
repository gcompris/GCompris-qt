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

import "qrc:/gcompris/src/core"
import "missing-letter.js" as Activity
import QtMultimedia 5.0


ActivityBase
{
    id: activity

    onStart: focus = true
    onStop: {}

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
            property alias bar: bar
            property alias bonus: bonus
            property alias questionImage: questionImage
            property alias questionText: questionText
            property alias answers: answers
            property alias currentQuestionNumberText : currentQuestionNumberText
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // Picture holder for different images being shown
        Image
        {   id: bgImage
            source: Activity.url + "missingletter-bg.png"
            sourceSize.width: parent.width * .55
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 50
                rightMargin: 10
            }

            Image
            {
                id: questionImage
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    topMargin: parent.height * .05
                }
                sourceSize.width: parent.width * .60
            }

            Text
            {
                id: questionText
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height * .08
                }
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
             anchors {
                 left: parent.left
                 top: parent.top
                 leftMargin: parent.width * .15
                 topMargin: parent.height * .05
             }

             add: Transition {
                 NumberAnimation { properties: "y"; from: 10; duration: 500 }
             }

             Repeater
             {
                 id: answers
                 Image
                 {
                     source: Activity.url + "button.png"
                     width: activity.width * .10
                     height: width

                     Text {
                         text: modelData
                         color : "white";
                         font.pointSize: 24;
                         anchors.centerIn: parent
                     }

                     MouseArea
                     {
                         id: buttonMouseArea
                         anchors.fill: parent
                         onClicked: {
                             if(Activity.answerPressed(modelData))
                                 particle.emitter.burst(30)
                         }
                     }
                     ParticleSystemStar {
                         id: particle
                     }
                 }
             }
         }

        // Counter of progress within this level
        Image
        {
            source: Activity.url + "enumerate_answer.png"
            scale: .85
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            Text
            {
                id: currentQuestionNumberText
                anchors.centerIn: parent
                font.pointSize: 24
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
