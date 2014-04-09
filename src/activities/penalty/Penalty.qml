/* GCompris - penalty.qml
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
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
import "penalty.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "penalty_bg.svgz"
        fillMode: Image.Stretch
        anchors.fill: parent
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int duration : 0
            property int progressBarOpacity : 40
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        /* Sounds */
        Audio {
            id: playFlip
            source: "qrc:/gcompris/src/core/resource/sounds/flip.wav"
        }

        Audio {
            id: playBrick
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        /* Text to help */
        Text {
            id: help
            y:parent.height*0.65
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 22
            color: "white"
            text: ""
        }

        /* The progress bars */
        Rectangle {
            id: progressLeft
            property int ratio: 0
            property ParallelAnimation anim: animationLeft

            opacity: progressBarOpacity
            anchors.left: parent.left
            anchors.leftMargin: parent.width/parent.implicitWidth*62
            anchors.top: parent.top
            anchors.topMargin: parent.height/parent.implicitHeight*100
            width: ratio/100*parent.width/parent.implicitWidth*200
            height: parent.height/parent.implicitHeight*20
            ParallelAnimation {
                id: animationLeft
                PropertyAnimation
                {
                    target: progressLeft
                    property: "ratio"
                    from: 0
                    to: 100
                    duration: items.duration
                }
                PropertyAnimation
                {
                    target: progressLeft
                    property: "color"
                    from: "#00FF00"
                    to: "#FF0000"
                    duration: items.duration
                }
            }
        }

        Rectangle {
            id: progressRight
            property int ratio: 0
            property ParallelAnimation anim: animationRight

            opacity: progressBarOpacity
            anchors.right: parent.right
            anchors.rightMargin: parent.width/parent.implicitWidth*50
            anchors.top: parent.top
            anchors.topMargin: parent.height/parent.implicitHeight*100
            width: ratio/100*parent.width/parent.implicitWidth*200
            height: parent.height/parent.implicitHeight*20
            ParallelAnimation {
                id: animationRight
                PropertyAnimation
                {
                    target: progressRight
                    property: "ratio"
                    from: 0
                    to: 100
                    duration: items.duration
                }
                PropertyAnimation
                {
                    target: progressRight
                    property: "color"
                    from: "#00FF00"
                    to: "#FF0000"
                    duration: items.duration
                }
            }
        }

        Rectangle {
            id: progressTop
            property int ratio: 0
            property ParallelAnimation anim: animationTop

            opacity: progressBarOpacity
            anchors.top: parent.top
            anchors.topMargin: parent.width/parent.implicitWidth*40
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.height/parent.implicitHeight*20
            height: ratio/100*parent.width/parent.implicitWidth*100
            ParallelAnimation {
                id: animationTop
                PropertyAnimation
                {
                    target: progressTop
                    property: "ratio"
                    from: 0
                    to: 100
                    duration: items.duration
                }
                PropertyAnimation
                {
                    target: progressTop
                    property: "color"
                    from: "#00FF00"
                    to: "#FF0000"
                    duration: items.duration
                }
            }
        }
        /* The player */
        Image {
            id: player
            source: Activity.url + "penalty_player.svgz"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width/parent.implicitWidth*implicitWidth
            height: parent.height/parent.implicitHeight*implicitHeight
            x:parent.width/2-width/2

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton
                onClicked: {
                    if (ball.y!=ball.parent.height*0.77-ball.height/2) {
                        /* The ball is not on the initial place */
                        help.text = qsTr("Click on the ball to place it again.")
                    }
                    else
                    {
                        /* The ball is  on the initial place */
                        help.text = qsTr("Click twice on the ball to shoot it.")
                    }
                }
            }
        }

        /* The ball */
        Image {
            id: ball
            source: Activity.url + "penalty_ball.svgz"
            fillMode: Image.PreserveAspectFit
            width: parent.width/parent.implicitWidth*implicitWidth
            height: parent.height/parent.implicitHeight*implicitHeight

            Behavior on x { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
            Behavior on y { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }

            state: "INITIAL"
            states: [
                State {
                    name: "INITIAL"
                    PropertyChanges { target: ball; x:parent.width/2-width/2; y:parent.height*0.77-height/2}
                },State {
                    name: "RIGHT"
                    PropertyChanges { target: ball; x:background.width*0.8; y:background.height*0.3}
                },State {
                    name: "LEFT"
                    PropertyChanges { target: ball; x:background.width*0.2; y:background.height*0.3}
                },State {
                    name: "CENTER"
                    PropertyChanges { target: ball; x:parent.width/2-width/2; y:background.height*0.1}
                }
            ]

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton
                onClicked: {
                    help.text = ""
                    if (ball.y!=ball.parent.height*0.77-ball.height/2) {
                        /* Reset initial position */
                        ball.state = "INITIAL"
                        progressRight.ratio=0
                        progressLeft.ratio=0
                        progressTop.ratio=0
                    }
                    else
                    {
                        /* This is a shoot */
                        var progess=progressTop
                        if (mouse.button == Qt.LeftButton) {
                            progess=progressLeft
                        } else if (mouse.button == Qt.RightButton) {
                            progess=progressRight
                        }

                        if(progess.ratio > 0) {
                            /* Second click, stop animation */
                            progess.anim.running = false;

                            /* Play sound */
                            playBrick.play()

                            /* Success or not */
                            if(progess.ratio<70) {
                                /* Success */
                                if(progess===progressLeft) {
                                    ball.state="LEFT"
                                } else if(progess===progressRight) {
                                    ball.state="RIGHT"
                                } else {
                                    ball.state="CENTER"
                                }

                                bonus.good("tux")
                            } else {
                                /* failure */
                                ball.y=300
                                bonus.bad("tux")
                            }
                        } else {
                            /* First click, start animation*/
                            progess.anim.running = true;

                            /* Play sound */
                            playFlip.play()
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
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
