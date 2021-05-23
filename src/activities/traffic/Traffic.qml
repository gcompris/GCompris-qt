/* GCompris - Traffic.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "traffic.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/traffic/resource/traffic_bg.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        property string mode: "IMAGE" // allow to choose between "COLOR" and "IMAGE"
        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias jamBox: jamBox
            property alias jamGrid: jamGrid
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

        Image {
            id: jamBox
            source: "qrc:/gcompris/src/activities/traffic/resource/traffic_box.svg"

            anchors.centerIn: parent
            sourceSize.width: Math.min(background.width * 0.85,
                                       background.height * 0.85)
            fillMode: Image.PreserveAspectFit
            property double scaleFactor: background.width / background.sourceSize.width

            Grid {
                id: jamGrid
                anchors.centerIn: parent
                width: parent.width - 86 * jamBox.scaleFactor * ApplicationInfo.ratio
                height: parent.height - 86 * jamBox.scaleFactor * ApplicationInfo.ratio
                columns: 6
                rows: 6
                spacing: 0
                // Add an alias to mode so it can be used on Car items
                property alias mode: background.mode
                Repeater {
                    id: gridRepeater
                    model: jamGrid.columns * jamGrid.rows

                    delegate: Rectangle {
                        id: gridDelegate
                        height: jamGrid.height / jamGrid.rows
                        width: height
                        border.width: 1
                        border.color: "white"
                        color: "#444444"
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                home()
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                   background.mode = activityData["mode"];
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
        }
    }
}
