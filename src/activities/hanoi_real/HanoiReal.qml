 /* GCompris - hanoi_real.qml
 *
 * SPDX-FileCopyrightText: 2015 Amit Tomar <a.tomar@outlook.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Amit Tomar <a.tomar@outlook.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Graphics refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0

import "../../core"
import "hanoi_real.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string activityMode: "real"
    resourceUrl: "qrc:/gcompris/src/activities/hanoi_real/resource/"

    pageComponent: Image {
        id: activityBackground
        source: activity.resourceUrl + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias discRepeater: discRepeater
            property alias towerModel: towerModel
            property bool hasWon: false
            property int numberOfDisc: 1
            property int numberOfTower: 1
            property int maxDiskPerTower: 1
        }

        readonly property list<real> discSizes: [1.6, 1.3, 1, 0.7, 0.5]

        onStart: { Activity.start(items, activity.activityMode) }
        onStop: { Activity.stop() }

        GCTextPanel {
            id: instructionPanel
            visible: bar.level == 1
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bar.height * 1.2
            color: GCStyle.lightBg
            textItem.color: GCStyle.darkText
            textItem.text: activity.activityMode == "real" ? qsTr("Move the entire stack to the right peg, one disc at a time.") :
            qsTr("Build the same tower in the empty area as the one you see on the right-hand side")
        }

        Repeater {
            id: discRepeater
            model: items.numberOfDisc
            readonly property real discHeight: activity.activityMode == "real"?
                towerRow.height * 0.15 : towerRow.height / (items.maxDiskPerTower + 1)

            Rectangle {
                id: disc
                z: 4
                width: activity.activityMode == "real" ?
                    towerRow.towerWidth * activityBackground.discSizes[index] : towerRow.towerWidth
                height: discRepeater.discHeight
                radius: height * 0.5
                required property int index
                property color baseColor: GCStyle.grayBorder
                property alias discMouseArea: discMouseArea
                property Item towerImage
                property int position: 0 // The position index on the tower
                property alias text: textSimplified.text
                color: Qt.darker(baseColor, 1.2)

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.bottom
                    topMargin: -parent.height * 0.12 - (disc.height * disc.position)

                    Behavior on topMargin {
                        NumberAnimation {
                            id: bouncebehavior
                            duration: 100
                            easing.type: Easing.OutQuint
                        }
                    }
                }

                Rectangle {
                    id: inDisc
                    width: parent.width - GCStyle.baseMargins
                    height: parent.height - GCStyle.halfMargins
                    radius: width * 0.5
                    color: Qt.lighter(disc.baseColor, 1.2)
                    anchors.centerIn: parent

                    GCText {
                        id: textSimplified
                        visible: activity.activityMode == "simplified"
                        color: GCStyle.darkText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: GCStyle.baseMargins
                        anchors.right: parent.right
                    }
                }

                function restoreAnchors() {
                    disc.anchors.horizontalCenter = disc.parent.horizontalCenter
                    disc.anchors.top = disc.parent.bottom
                }

                MouseArea {
                    id: discMouseArea
                    enabled: disc.enabled && !items.hasWon
                    anchors.centerIn: parent
                    width: towerRow.towerWidth * activityBackground.discSizes[0]
                    height: activityBackground.height
                    drag.target: parent
                    drag.axis: Drag.XandYAxis
                    hoverEnabled: true

                    onPressed: {
                        disc.anchors.horizontalCenter = undefined
                        disc.anchors.top = undefined
                        // Need to higher the z tower for the disc to be above all other towers and disc
                        disc.towerImage.z ++
                        disc.z ++
                    }

                    onReleased: {
                        // Restore previous z before releasing the disc
                        disc.towerImage.z --
                        disc.z --
                        Activity.discReleased(disc.index)
                    }
                }
            }
        }

        Row {
            id: towerRow
            height: activityBackground.height - instructionPanel.height - bar.height * 2.2
            width: activityBackground.width - spacing * 2
            spacing: towerWidth * 0.6

            property double towerWidth: activityBackground.width / (towerModel.model * 1.6 + 0.6)
            // divided by (number of towers * (maximum disc width + sides spacing))

            anchors {
                bottom: instructionPanel.top
                horizontalCenter: parent.horizontalCenter
                bottomMargin: GCStyle.baseMargins
            }
            Repeater {
                id: towerModel
                model: items.numberOfTower
                delegate: Image {
                    id: towerImage
                    z: 3
                    required property int modelData
                    source:
                    if(activity.activityMode == "simplified" && (modelData == towerModel.model-2))
                        //in simplified mode, the target tower
                        activity.resourceUrl + "disc_support-green.svg"
                    else if(activity.activityMode == "simplified" && (modelData == towerModel.model-1))
                        // in simplified mode, the reference tower
                        activity.resourceUrl + "disc_support-red.svg"
                    else if(activity.activityMode == "real" && (modelData == towerModel.model-1))
                        // in real mode, the target tower
                        activity.resourceUrl + "disc_support-green.svg"
                    else
                        activity.resourceUrl + "disc_support.svg"
                    width: towerRow.towerWidth
                    height: towerRow.height
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.Stretch
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                activity.displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
