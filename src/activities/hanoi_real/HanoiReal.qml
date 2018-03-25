 /* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2015 Amit Tomar <a.tomar@outlook.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Amit Tomar <a.tomar@outlook.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Graphics refactoring)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "hanoi_real.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string activityMode: "real"

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias discRepeater: discRepeater
            property alias towerModel: towerModel
            property bool hasWon: false
            property int numberOfDisc
        }

        onStart: { Activity.start(items, activityMode) }
        onStop : { Activity.stop() }

        onWidthChanged: Activity.sceneSizeChanged()
        onHeightChanged: Activity.sceneSizeChanged()

        Rectangle {
            id: instruction
            width: parent.width
            height: description.height + 5 * ApplicationInfo.ratio
            color: "#FFF"
            opacity: 0.8
            anchors {
                bottom: bar.top
                bottomMargin: 15 * ApplicationInfo.ratio
            }
            visible: bar.level == 1
        }
        
        GCText {
            id: description
            text: activityMode == "real" ? qsTr("Move the entire stack to the right peg, one disc at a time.") :
            qsTr("Build the same tower in the empty area as the one you see on the right-hand side")
            width: instruction.width
            fontSize: largeSize
            color: "#373737"
            wrapMode: Text.WordWrap
            anchors.centerIn: instruction
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: bar.level == 1
        }
        

        Repeater {
            id: discRepeater

            Rectangle {
                id: disc
                parent: towerModel.itemAt(0)
                z: 4
                width: Activity.getDiscWidth(index)
                height: activityMode == "real"? towerModel.itemAt(0).height * 0.15: towerModel.itemAt(0).height / (Activity.nbMaxItemsByTower+1)
                
                opacity: index < items.numberOfDisc ? 1 : 0
                onHeightChanged: Activity.sceneSizeChanged()
                property alias color: disc.color
                radius: height * 0.5
                property bool mouseEnabled : true
                property alias discMouseArea: discMouseArea
                property Item towerImage
                property int position // The position index on the tower

                property alias text: textSimplified.text

                anchors.horizontalCenter: if(parent) parent.horizontalCenter
                
                
                Behavior on y {
                    NumberAnimation {
                        id: bouncebehavior
                        easing {
                            type: Easing.OutElastic
                            amplitude: 1.0
                            period: 0.75
                        }
                    }
                }
                
                Rectangle {
                    id: inDisc
                    width: parent.width - 10 * ApplicationInfo.ratio
                    height: parent.height - 6 * ApplicationInfo.ratio
                    radius: width * 0.5
                    color: "#2AFFFFFF"
                    anchors.centerIn: parent
                    
                    GCText {
                        id: textSimplified
                        visible: activityMode == "simplified"
                        color: "#b4000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 10 * ApplicationInfo.ratio
                        anchors.right: parent.right
                    }
                    
                }
                

                MouseArea {
                    id: discMouseArea
                    enabled: disc.mouseEnabled && !items.hasWon
                    anchors.centerIn: parent
                    width: Activity.getDiscWidth(0)
                    height: background.height
                    drag.target: parent
                    drag.axis: Drag.XandYAxis
                    hoverEnabled: true

                    onPressed: {
                        disc.anchors.horizontalCenter = undefined
                        // Need to higher the z tower for the disc to be above all other towers and disc
                        disc.towerImage.z ++
                        disc.z ++
                    }

                    onReleased: {
                        // Restore previous z before releasing the disc
                        disc.towerImage.z --
                        disc.z --
                        Activity.discReleased(index)
                        disc.anchors.horizontalCenter = disc.parent.horizontalCenter
                    }
                }
            }
        }

        Grid {
            // do columns if mobile?
            rows: 1
            columnSpacing: (background.width - towerModel.model * towerModel.itemAt(0).width) / (items.towerModel.model+1)

            anchors {
                bottom: instruction.top
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            Repeater {
                id: towerModel
                model: 1 // will be dynamically set in js
                delegate: Item {
                    id: towerImage
                    width: image.width
                    height: image.height
                    onHeightChanged: Activity.sceneSizeChanged()
                    Image {
                        id: image
                        source: 
                        if(activityMode == "simplified" && (modelData == towerModel.model-2))
                            //in simplified mode, the target tower
                            Activity.url + "disc_support-green.svg"
                        else if(activityMode == "simplified" && (modelData == towerModel.model-1))
                            // in simplified mode, the reference tower
                            Activity.url + "disc_support-red.svg"
                        else if(activityMode == "real" && (modelData == towerModel.model-1))
                            // in real mode, the target tower
                            Activity.url + "disc_support-green.svg"
                        else
                            Activity.url + "disc_support.svg"
                        sourceSize.width: background.width / (towerModel.model + 2.5)
                        fillMode: Image.Stretch
                        height: background.height - instruction.height - 2 * bar.height
                    }
                    z: 3
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
