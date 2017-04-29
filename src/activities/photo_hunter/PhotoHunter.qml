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
import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.5
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
            property int total
            property int totalFound: img1.good + img2.good
            property alias problem: problem
            property alias frame: frame
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width < background.height
        property double barHeight: ApplicationSettings.isBarHidden ? bar.height / 2 : bar.height
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
                    if (items.problem.z > 0)
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
                                                                    background.vert ? - frame.problemTextHeight * 0.5 - img1.height * 0.5 - 5 : - frame.problemTextHeight * 0.5
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
                                                                   background.vert ? - frame.problemTextHeight * 0.5 + img1.height * 0.5 + 5 : - frame.problemTextHeight * 0.5
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

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: {
                background.startedHelp = !background.startedHelp
                slider.value = 0
            }
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
