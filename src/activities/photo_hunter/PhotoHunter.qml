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
            property alias img1: img1
            property alias img2: img2
            property int total
            property int totalFound: img1.good + img2.good
            property alias problemTxt: problemTxt

            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int cellSize: Math.min(background.width / 11 ,
                                            background.height / (9 + barHeightAddon))
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width < background.height
        property double barHeight: (items.barHeightAddon == 1) ? 0 : bar.height

        function checkAnswer() {
            if (items.totalFound === items.model.length) {
                bonus.good("flower")

                //remove the problem from the board after first level
                if (problem.opacity != 0) {
                    frame.anchors.top = background.top
                    problemTxt.opacity = 0
                    problemTxt.height = 0
                    problem.opacity = 0
                }
            }
        }

        Rectangle {
            id: problem
            width: parent.width
            height: problemTxt.height
            anchors.top: parent.top
            anchors.topMargin: 10
            border.width: 2
            border.color: "black"
            color: "red"



            GCText {
                id: problemTxt
                anchors.centerIn: parent
                width: parent.width * 3 / 4
                fontSize: mediumSize
                wrapMode: Text.WordWrap
                text: qsTr("Click on the differences between the two images!")
                color: "white"
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

            //left/top image
            Observe {
                id: img1
                sourceSize.width: background.vert ? undefined : (background.width - 30 - problemTxt.height) / 2
                sourceSize.height: background.vert ?
                                       (background.height - background.barHeight - 40 - problemTxt.height) /2 :
                                       background.height - background.barHeight - 30
                show: true
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: background.vert ? 0 : -img1.width/2-5
                }
            }

            //right/bottom image
            Observe {
                id: img2
                sourceSize.width: background.vert ? undefined : (background.width - 30 - problemTxt.height) / 2
                sourceSize.height: background.vert ?
                                       (background.height - background.barHeight - 40 - problemTxt.height) /2 :
                                       background.height - background.barHeight - 30
                show: false
                anchors {
                    top: background.vert ? img1.bottom : parent.top
                    topMargin: background.vert ? 10 : 0
                    left: background.vert ? img1.left : img1.right
                    leftMargin: background.vert ? 0 : 10
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
