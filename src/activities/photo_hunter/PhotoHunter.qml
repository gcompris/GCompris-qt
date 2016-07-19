/* GCompris - PhotoHunter.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "../../core"
import "photo_hunter.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "white"
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
            property var model
            property bool notShowed: true
            property alias img1: img1
            property alias img2: img2
            property alias helpButton: helpButton
            property int total
            property int totalFound: img1.good + img2.good
            property alias problem: problem
            property alias frame: frame
            property int helpPressed: 0

            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int cellSize: Math.min(background.width / 11 ,
                                            background.height / (9 + barHeightAddon))
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width < background.height
        property double barHeight: (items.barHeightAddon == 1) ? 0 : bar.height
        property bool startedHelp: false

        function checkAnswer() {
            if (items.totalFound === items.model.length) {
                bonus.good("flower")

                // after completing a level, mark the problem as shown
                if (items.notShowed) {
                    items.notShowed = false
                }

                //remove the problem from the board after first level
                if (problem.z > 0)
                    Activity.hideProblem()
            }
        }

        Rectangle {
            id: problem
            width: parent.width
            height: problemText.height
            anchors.top: parent.top
            anchors.topMargin: 10
            border.width: 2
            border.color: "black"
            color: "red"
            z: 5

            property alias problemText: problemText

            GCText {
                id: problemText
                anchors.centerIn: parent
                width: parent.width * 3 / 4
                fontSize: mediumSize
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: background.startedHelp ? qsTr("Drag the slider to show the differences!") :
                                          qsTr("Click on the differences between the two images!")
                color: "white"
                onHeightChanged: {
                    frame.problemTextHeight = problemText.height
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Activity.hideProblem()
            }
        }

        Rectangle {
            id: frame
            color: "transparent"
            width: background.vert ? img1.width : parent.width - 20
            height: parent.height - background.barHeight - 30

            anchors.top: problem.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10

            property real problemTextHeight: problemText.height

            //left/top image
            Observe {
                id: img1
                show: true
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: background.startedHelp ? 0 : background.vert ? 0 : - img1.width / 2 - 5

                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: background.startedHelp ?  background.vert ? - frame.problemTextHeight * 0.8 : - frame.problemTextHeight * 1.01 :
                                                                    background.vert ? - frame.problemTextHeight * 0.5 - img1.height * 0.5 - 5 : 0
                }
            }

            //right/bottom image
            Observe {
                id: img2
                opacity: background.startedHelp ? 1 - slider.value : 1
                show: false
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: background.startedHelp ? 0 : background.vert ? 0 : img1.width / 2 + 5

                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: background.startedHelp ? background.vert ? - frame.problemTextHeight * 0.8 : - frame.problemTextHeight * 1.01 :
                                                                   background.vert ? - frame.problemTextHeight * 0.5 + img1.height * 0.5 + 5 : 0
                }
            }

            Slider {
                id: slider
                value: 0
                height: 50
                width: img1.width * 0.9
                z: background.startedHelp ? 5 : -5
                opacity: background.startedHelp ? 1 : 0
                enabled: background.startedHelp

                style: SliderStyle {
                        handle: Rectangle {
                            height: background.vert ? 80 : 70
                            width: height
                            radius: width / 2
                            color: "lightblue"
                        }

                        groove: Rectangle {
                            implicitHeight: slider.height
                            implicitWidth: background.vert ? slider.width * 0.85 : slider.width
                            radius: height / 2
                            border.color: "#6699ff"
                            color: "#99bbff"

                            Rectangle {
                                height: parent.height
                                width: styleData.handlePosition
                                implicitHeight: 6
                                implicitWidth: 100
                                radius: height/2
                                color: "#4d88ff"
                            }
                        }
                    }

                anchors {
                    top: img1.bottom
                    topMargin: 20
                    horizontalCenter: img1.horizontalCenter
                }
            }
        }

        //help button
        Image {
            id: helpButton
            source: Activity.url + "help.svg"
            sourceSize.height: background.vert ? bar.height * 0.77 : bar.height * 1
            height: background.vert ? bar.height * 0.7 : bar.height * 0.9
            fillMode: Image.PreserveAspectFit
            anchors {
                bottom: background.vert ? bar.top : bar.bottom
                bottomMargin: 10
                left: background.vert ? parent.left : bar.right
                leftMargin: background.vert || ApplicationSettings.isBarHidden ? 10 : bar.width * 3.55
            }

            property bool notPressed: true

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }

            states: State {
                name: "scaled"; when: mouseArea.containsMouse
                PropertyChanges {
                    target: helpButton
                    scale: 1.1
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                enabled: items.helpPressed < 2 ? true : false
                hoverEnabled: ApplicationInfo.isMobile ? false : true

                onClicked: {
                    background.startedHelp = !background.startedHelp

                    if (!background.startedHelp)
                        items.helpPressed ++

                    if (items.helpPressed < 2)
                        if (!background.startedHelp)
                            helpButton.opacity = 1
                        else
                            helpButton.opacity = 0.8
                    else helpButton.opacity = 0.5

                    if (helpButton.notPressed) {
                        items.frame.anchors.top = items.problem.bottom
                        items.problem.z = 5
                        frame.problemTextHeight = problemText.height
                        helpButton.notPressed = false
                    } else if (!items.notShowed) {
                        Activity.hideProblem()
                        frame.problemTextHeight = 0
                    }


                    slider.value = 0
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
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

        Score {
            anchors {
                bottom: parent.bottom
                bottomMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.total
            currentSubLevel: items.totalFound
        }

    }

}
