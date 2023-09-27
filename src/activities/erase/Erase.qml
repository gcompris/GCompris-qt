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
import GCompris 1.0

import "../../core"
import "erase.js" as Activity

ActivityBase {
    id: activity
    focus: true
    property string type: "erase"

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
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
            property alias background: background
            property alias bar: bar
            property alias blocks: blocks
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int nbSubLevel: 6
            property int currentSubLevel: 0
            property int mode: 1 // default is automatic
        }
        onStart: Activity.start(main, items, type)

        onStop: { Activity.stop() }

        function alignBackground() {
            if(Activity.backgroundImages[Activity.currentImage][1] === "left")
                background.horizontalAlignment = Image.AlignLeft
            else if(Activity.backgroundImages[Activity.currentImage][1] === "right")
                background.horizontalAlignment = Image.AlignRight
            else
                background.horizontalAlignment = Image.AlignHCenter

            if(Activity.backgroundImages[Activity.currentImage][2] === "top")
                background.verticalAlignment = Image.AlignTop
            else if(Activity.backgroundImages[Activity.currentImage][2] === "bottom")
                background.verticalAlignment = Image.AlignBottom
            else
                background.verticalAlignment = Image.AlignVCenter
        }

        MultiPointTouchArea {
            anchors.fill: parent
            onTouchUpdated: {
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
                background: items.background
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
                background.stop()
                background.start()
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
            onWin: {
                if(items.mode === 1)
                    Activity.nextSubLevel()
                else
                    okButton.levelFinished = true
            }
        }

        Score {
            id: score
            anchors {
                bottom: (background.width >= background.height + 40 * ApplicationInfo.ratio) ? background.bottom : bar.top
                bottomMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel + 1
        }

        // Next Level Button, if Manual is activated
        BarButton {
            id: okButton
            property bool levelFinished: false
            enabled: items.mode == 2 && levelFinished
            visible: enabled

            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            height: width
            width: score.width
            sourceSize.width: width
            sourceSize.height: height
            z: score.z
            anchors {
                bottom: score.top
                right: score.right
                bottomMargin: 20
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
