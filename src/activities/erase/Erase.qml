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
        source: Activity.url + Activity.getFirstImage()
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
            property alias bar: bar
            property alias blocks: blocks
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias okButton: okButton
            property alias winSound: winSound
            property alias eraser1Sound: eraser1Sound
            property alias eraser2Sound: eraser2Sound
            property int nbSubLevel: 6
            property int currentSubLevel: 0
            property int mode: 1 // default is automatic
        }
        onStart: Activity.start(main, items, type)

        onStop: { Activity.stop() }

        function alignBackground() {
            if(Activity.backgroundImages[Activity.currentImage][1] === "left")
                activityBackground.horizontalAlignment = Image.AlignLeft
            else if(Activity.backgroundImages[Activity.currentImage][1] === "right")
                activityBackground.horizontalAlignment = Image.AlignRight
            else
                activityBackground.horizontalAlignment = Image.AlignHCenter

            if(Activity.backgroundImages[Activity.currentImage][2] === "top")
                activityBackground.verticalAlignment = Image.AlignTop
            else if(Activity.backgroundImages[Activity.currentImage][2] === "bottom")
                activityBackground.verticalAlignment = Image.AlignBottom
            else
                activityBackground.verticalAlignment = Image.AlignVCenter
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
                nbx: nx
                nby: ny
                ix: a
                iy: b
                opacity: op
                source: img
                type: activity.type
                main: MAIN
                bar: BAR
                blockBackground: items.activityBackground
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: home()

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
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
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
