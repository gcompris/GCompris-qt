/* GCompris - space-encounter.qml
 *
 * Copyright (C) 2016 Varun Kumar <varun13169@iiitd.ac.in>
 *
 * Authors:
 *   Varun Kumar <varun13169@iiitd.ac.in>
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

import "../../core"
import "space-encounter.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        source: "./resource/asteroid.svg"
        sourceSize.width: parent.width
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

            /* Variables */
            property bool flag: true
            property bool timerRunning: false
            property bool timerRepeat: true

            property int spacePresses: 0
            property int ticks: 0
            property int highScore: 0
            property int playerScore: 0

            property string textbuttText: qsTr("Press Space Bar to Start")
            property string displayCounterText: qsTr("%1 Seconds").arg(items.ticks)
            property string spaceBarButtonColor: "#ABCDEF"
        }

        onStart: { 
            Activity.start(items)
            textbutt.forceActiveFocus()
        }
        onStop: { Activity.stop() }

        
/////////////////////////////////////////////////////////////////
        Rectangle {
            id: spaceBarButton
            anchors.centerIn: parent;
            width: 750; height: 100;
            color: items.spaceBarButtonColor;
            GCText {
                id: textbutt
                anchors.centerIn: parent
                fontSize: largeSize
                text: items.textbuttText;

                focus: true
                Keys.onPressed: {
                    if((event.key == Qt.Key_Space)&&(event.isAutoRepeat == 0)) {
                        Activity.increment();
                    }
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: spaceBarButton.horizontalCenter;
            anchors.top: spaceBarButton.bottom;
            anchors.topMargin: 30;
            width: 200; height: 50;
            color: "#ABCDEF"
                GCText {
                id: displayCounter
                anchors.centerIn: parent;
                text: items.displayCounterText
            }
        }

        Rectangle {
            anchors.top: parent.top;
            anchors.left: parent.left;
            width: 200; height: 50;
            color: "transparent";
            GCText {
                id: highScoreDisplay
                anchors.centerIn: parent;
                color: "#FF6633"
                text: qsTr("High Score %1").arg(items.highScore);
            }
        }

        Rectangle {
            anchors.top: parent.top;
            anchors.right: parent.right;
            width: 200; height: 50;
            color: "transparent";
            GCText {
                id: playerScoredisplay
                anchors.centerIn: parent;
                color: "#FF6633"
                text: qsTr("Your Score %1").arg(items.playerScore);
            }
        }

        Timer {
            id: counter
            interval: 1000; repeat: items.timerRepeat; running: items.timerRunning;
            onTriggered: Activity.incrementTicks();
        }

/////////////////////////////////////////////////////////////////////////////


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

        //////////////////////////////////////////////////////////////////////////////
        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
                loose.connect(Activity.nextLevel)
            }
        }
        ///////////////////////////////////////////////////////////////////////////////
    }

}
