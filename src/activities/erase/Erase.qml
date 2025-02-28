/* GCompris - Erase.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0

import "../../core"
import "erase.js" as Activity

ActivityBase {
    id: activity
    focus: true
    property string type: "erase"

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias activityBackground: activityBackground
            property alias blocks: blocks
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias okButton: okButton
            property alias winSound: winSound
            property int nbSubLevel: 6
            property int currentSubLevel: 0
            property int mode: 1 // default is automatic
        }
        onStart: Activity.start(items)

        onStop: { Activity.stop() }

        function alignBackground() {
            activityBackground.horizontalAlignment = Activity.backgroundImages[Activity.currentImage][1]
            activityBackground.verticalAlignment = Activity.backgroundImages[Activity.currentImage][2]
        }

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: eraser1Sound
            source: "qrc:/gcompris/src/activities/erase/resource/eraser1.wav"
        }

        GCSoundEffect {
            id: eraser2Sound
            source: "qrc:/gcompris/src/activities/erase/resource/eraser2.wav"
        }

        MultiPointTouchArea {
            anchors.fill: parent
            onTouchUpdated: (touchPoints) => {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]

                    var newBlock = rootItem.childAt(touch.x, touch.y)
                    if(newBlock && activity.type === "erase")
                        newBlock.enter()

                    var previousBlock = rootItem.childAt(touch.previousX, touch.previousY)
                    if(previousBlock !== newBlock && previousBlock != repeater)
                        previousBlock.leave()
                }
            }
        }

        Item {
            id: rootItem
        }

        ListModel {
            id: blocks
        }
        Repeater {
            id: repeater
            model: blocks
            parent: rootItem
            Block {
                id: modelData
                required property int nx
                required property int ny
                required property int a
                required property int b
                required property string img
                nbx: nx
                nby: ny
                ix: a
                iy: b
                source: img
                type: activity.type
                blockBackground: items.activityBackground
                bar: bar
                eraser1Sound: eraser1Sound
                eraser2Sound: eraser2Sound
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: activity.home()

            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                    okButton.levelFinished = false
                }
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                activity.displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            onWin: Activity.nextLevel()
        }

        Score {
            id: score
            anchors {
                bottom: (activityBackground.width >= activityBackground.height + 4 * GCStyle.baseMargins) ? activityBackground.bottom : bar.top
                bottomMargin: GCStyle.baseMargins
                right: parent.right
                rightMargin: GCStyle.baseMargins
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel
            onStop: {
                if(items.mode === 1)
                    Activity.nextSubLevel()
            }
        }

        // Next Level Button, if Manual is activated
        BarButton {
            id: okButton
            property bool levelFinished: false
            enabled: items.mode == 2 && levelFinished
            visible: enabled

            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: score.width
            z: score.z
            anchors {
                bottom: score.top
                right: score.right
                bottomMargin: GCStyle.baseMargins
            }
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
            }
            onClicked: {
                levelFinished = false
                Activity.nextSubLevel()
            }
        }
    }
}
