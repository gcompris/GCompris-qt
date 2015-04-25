 /* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2014 Amit Tomar <a.tomar@outlook.com>
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
import QtQuick 2.3
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "hanoi_real.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property real currentX: 0.0
        property real currentY: 0.0
        property real spacing: (background.width - 3 * tower1Image.width) / 4

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
            property alias tower1Image: tower1Image
            property alias tower2Image: tower2Image
            property alias tower3Image: tower3Image
            property alias tower1ImageHighlight: tower1ImageHighlight
            property alias tower2ImageHighlight: tower2ImageHighlight
            property alias tower3ImageHighlight: tower3ImageHighlight
            property int numberOfDisc
            property int maxZ: 5
        }

        onStart: { Activity.start(items) }
        onStop : { Activity.stop() }

        onWidthChanged: Activity.sceneSizeChanged()
        onHeightChanged: Activity.sceneSizeChanged()

        Rectangle {
            id: instruction
            width: parent.width
            height: description.height  + 5 * ApplicationInfo.ratio
            color: "#FFF"
            opacity: 0.7
            anchors {
                bottom: bar.top
                bottomMargin: 15 * ApplicationInfo.ratio
            }
            visible: bar.level == 1

            GCText {
                id: description
                text: qsTr("Move the entire stack to the right peg, one disc at a time.")
                width: parent.width
                fontSize: largeSize
                color: "black"
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Repeater
        {
            id: discRepeater

            Image {
                id: disc
                parent: tower1Image
                z: tower1Image.z + 1

                sourceSize.width: Activity.getDiscWidth(index)
                height: tower1Image.height * 0.1
                source: Activity.url + "disc" + (index + 1) + ".svg"
                opacity: index < items.numberOfDisc ? 1 : 0

                property bool mouseEnabled : true
                property alias discMouseArea: discMouseArea
                property Item towerImage
                property int position // The position index on the tower

                onXChanged: Activity.performTowersHighlight(disc, x)

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

                MouseArea {
                    id: discMouseArea
                    enabled: parent.mouseEnabled
                    anchors.centerIn: parent
                    width: Activity.getDiscWidth(0)
                    height: background.height
                    drag.target: parent
                    drag.axis: Drag.XandYAxis

                    onPressed: {
                        background.currentX = disc.x
                        background.currentY = disc.y
                        disc.z ++

                        disc.z = items.maxZ
                        ++items.maxZ
                    }

                    onReleased: Activity.discReleased(index)
                }
            }
        }

        Image {
            id: tower1Image
            x: parent.spacing
            anchors {
                bottom: instruction.top
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: Activity.url + "disc_support.svg"
            sourceSize.width: background.width / 5.5
            fillMode: Image.Stretch

            property alias highlight: tower1ImageHighlight.highlight

            Highlight {
                id: tower1ImageHighlight
            }
        }

        Image {
            id: tower2Image
            anchors.left: tower1Image.right
            anchors.top: tower1Image.top
            anchors.leftMargin: parent.spacing
            source: Activity.url + "disc_support.svg"
            sourceSize.width: background.width / 5.5
            fillMode: Image.Stretch

            property alias highlight: tower2ImageHighlight.highlight

            Highlight {
                id: tower2ImageHighlight
            }
        }

        Image {
            id: tower3Image
            anchors.left: tower2Image.right
            anchors.top: tower2Image.top
            anchors.leftMargin: parent.spacing
            source: Activity.url + "disc_support.svg"
            sourceSize.width: background.width / 5.5
            fillMode: Image.Stretch

            property alias highlight: tower3ImageHighlight.highlight

            Highlight {
                id: tower3ImageHighlight
            }

            Highlight {
                id: tower3ImageHighlightGlow
                hue: 1.0
                lightness:   0
                opacity: tower3ImageHighlight.opacity == 0 ? .5 : 0
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
