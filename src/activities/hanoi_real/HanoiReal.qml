 /* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2015 Amit Tomar <a.tomar@outlook.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Amit Tomar <a.tomar@outlook.com> (Qt Quick port)
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
import QtGraphicalEffects 1.0
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
        sourceSize.width: parent.width
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
            opacity: 0.7
            anchors {
                bottom: bar.top
                bottomMargin: 15 * ApplicationInfo.ratio
            }
            visible: bar.level == 1

            GCText {
                id: description
                text: activityMode == "real" ? qsTr("Move the entire stack to the right peg, one disc at a time.") :
                qsTr("Build the same tower in the empty area as the one you see on the right-hand side")
                width: parent.width
                fontSize: largeSize
                color: "black"
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Repeater {
            id: discRepeater

            Item {
                id: disc
                parent: towerModel.itemAt(0)
                z: 4
                width: discImage.width
                height: discImage.height
                opacity: index < items.numberOfDisc ? 1 : 0
                onHeightChanged: Activity.sceneSizeChanged()
                property alias color: colorEffect.color
                //radius: 10
                property bool mouseEnabled : true
                property alias discMouseArea: discMouseArea
                property Item towerImage
                property int position // The position index on the tower

                property alias text: textSimplified.text

                onXChanged: Activity.performTowersHighlight(disc, x)

                anchors.horizontalCenter: if(parent) parent.horizontalCenter

                Image {
                    id: discImage
                    source: Activity.url + "disc.svg"
                    sourceSize.width: Activity.getDiscWidth(index)
                    height: activityMode == "real"? towerModel.itemAt(0).height * 0.15:
                    towerModel.itemAt(0).height / (Activity.nbMaxItemsByTower+1)

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

                    GCText {
                        id: textSimplified
                        visible: activityMode == "simplified"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 4
                        anchors.right: parent.right
                    }
                }

                MouseArea {
                    id: discMouseArea
                    enabled: disc.mouseEnabled
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

                ColorOverlay {
                    id: colorEffect
                    anchors.fill: discImage
                    source: discImage
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
                    property alias highlight: towerImageHighlight.highlight
                    Image {
                        id: image
                        source: Activity.url + "disc_support.svg"
                        sourceSize.width: background.width / (towerModel.model + 2.5)
                        fillMode: Image.Stretch
                        height: background.height - instruction.height - 2 * bar.height
                    }
                    z: 3

                    Highlight {
                        id: towerImageHighlight
                        source: image
                    }
                    Highlight {
                        // last tower highlight
                        id: towerImageHighlightGlow
                        source: image
                        hue: 1.0
                        lightness: 0
                        opacity: towerImageHighlight.opacity == 0 ? 0.5 : 0
                        visible: modelData == towerModel.model-1
                    }

                    // in simplified mode only, the target tower
                    Highlight {
                        hue: 0.3
                        source: image
                        lightness: 0
                        opacity: towerImageHighlight.opacity == 0 ? 0.5 : 0
                        visible: activityMode == "simplified" && (modelData == towerModel.model-2)
                    }

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
