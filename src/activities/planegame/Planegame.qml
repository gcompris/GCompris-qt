/* gcompris - Planegame.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "planegame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
    onStop: { }

    Keys.onPressed: Activity.processPressedKey(event)
    Keys.onReleased: Activity.processReleasedKey(event)

    property var dataset
    property var tutorialInstructions: ""
    property bool showTutorial: false

    property int oldWidth: width
    onWidthChanged: {
        // Reposition helico and clouds, same for height
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition helico and clouds, same for height
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        signal voiceDone
        source: Activity.url + "../algorithm/resource/desert_scene.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        Component.onCompleted: {
                activity.start.connect(start)
                activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: tutorialSection

        QtObject {
            id: items
            property Item activityPage: activity
            property alias background: background
            property alias bar: bar
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias plane: plane
            property alias fileChecker: fileChecker
            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property alias movePlaneTimer: movePlaneTimer
            property alias cloudCreation: cloudCreation
            property bool showTutorial: activity.showTutorial
            property bool goToNextLevel: false
       }

       onVoiceDone: {
           if(items.goToNextLevel) {
               items.goToNextLevel = false;
               items.bonus.good("flower");
           }
        }

        onStart: {
            activity.audioVoices.done.connect(voiceDone)
            Activity.start(items, dataset)
        }
        onStop: { Activity.stop() }

        File {
            id: fileChecker
        }

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: "../digital_electricity/resource/texture01.webp"
            anchors.fill: parent
            fillMode: Image.Tile
            z: 1
            visible: showTutorial
            Tutorial {
                id: tutorialSection
                tutorialDetails: tutorialInstructions
                useImage: false
                onSkipPressed: {
                    showTutorial = false
                    Activity.initLevel()
                }
            }
        }
        // Tutorial section ends

        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [ TouchPoint { id: point1 } ]

            onReleased: {
                plane.x = point1.x - plane.width / 2
                plane.y = point1.y - plane.height / 2
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: items.showTutorial ? (help | home) : (help | home | level) }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            visible: !showTutorial
            fontSize: background.width >= background.height ? internalTextComponent.largeSize : internalTextComponent.mediumSize
            height: internalTextComponent.height + 10
            anchors.bottom: bar.top
            anchors.margins: 10
        }

        property int movePlaneTimerCounter: 0
        Timer {
            id: movePlaneTimer
            running: false
            repeat: true
            onTriggered: {
                plane.state = "play"
                interval = 50
                if(movePlaneTimerCounter++ % 3 == 0) {
                    /* Do not call this too often or plane commands are too hard */
                    Activity.handleCollisionsWithCloud();
                }
                Activity.computeVelocity();
                Activity.planeMove();
            }
        }

        Timer {
            id: cloudCreation
            running: false
            repeat: true
            interval: 10200 - (bar.level * 200)
            onTriggered: Activity.createCloud()
        }

        Plane {
            id: plane
            visible: !showTutorial
            background: background
        }

    }
}
