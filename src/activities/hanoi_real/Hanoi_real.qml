 /* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2014 <Amit Tomar>
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

import "../../core"
import "hanoi_real.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias hanoiStage: hanoiStage
            property alias discRepeater: discRepeater
            property alias tower1Image: tower1Image
            property alias tower2Image: tower2Image
            property alias tower3Image: tower3Image
            property alias tower1ImageHighlight: tower1ImageHighlight
            property alias tower2ImageHighlight: tower2ImageHighlight
            property alias tower3ImageHighlight: tower3ImageHighlight
            property int maxDiscs: 4
            property int maxZ: 5
        }

        onStart: { Activity.start(items) ; Activity.resetToGetLevel(1) }
        onStop : { Activity.stop() }

        onWidthChanged: Activity.sceneSizeChanged()
        onHeightChanged: Activity.sceneSizeChanged()

        Rectangle {
            id: hanoiStage
            width: parent.width
            height: parent.height * .80
            color: "lightgrey"

            property real currentX: 0.0
            property real currentY: 0.0
            property real spacing: (hanoiStage.width - 3 * tower1Image.width) / 4

            Rectangle {
                width: parent.width
                height: parent.height * .15
                color: "#527BBD"
                anchors {
                    bottom: parent.bottom
                    bottomMargin: - parent.height * .025
                }
                visible: bar.level == 1

                Text {
                    id: description
                    text: qsTr("Move the entire stack to the right peg, one disc at a time.")
                    width: parent.width
                    font.pointSize: description.width > 300 ? 18 : 15
                    wrapMode: Text.WordWrap
                    color: "white"                    
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Repeater
            {
                id: discRepeater
                model : Activity.numberOfLevel + 2

                Image {
                    id: disc
                    parent: tower1Image
                    z: tower1Image.z + 1

                    sourceSize.width: if( 0 == index ) tower1Image.width * 1.6
                                      else if ( 1 == index ) tower1Image.width * 1.3
                                      else if ( 2 == index ) tower1Image.width * 1
                                      else tower1Image.width * 0.7
                    height: tower1Image.height * 0.1
                    source: Activity.url + "disc" + (index + 1) + ".svg"
                    opacity: index >= 3 ? 0 : 1

                    property bool mouseEnabled : true

                    property alias discX: disc.x
                    property alias discY: disc.y
                    property alias discMouseArea: discMouseArea

                    property real discWidth : disc.width
                    property real discHeight: disc.height

                    signal reposition()

                    onXChanged: Activity.performTowersHighlight(index)

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

                    onReposition: Activity.repositionDiscs(index)

                    MouseArea {
                        id: discMouseArea
                        enabled: parent.mouseEnabled
                        anchors.fill: parent
                        drag.target: parent
                        drag.axis: Drag.XandYAxis

                        drag.minimumX: 0
                        drag.maximumX: hanoiStage.width - parent.width

                        drag.minimumY: 0
                        drag.maximumY: hanoiStage.height - parent.height

                        onPressed: {
                            hanoiStage.currentX = disc.x
                            hanoiStage.currentY = disc.y
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
                y: parent.spacing / 1.5
                source: Activity.url + "disc_support.svg"
                sourceSize.width: background.width / 5.5
                fillMode: Image.Stretch

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

                MouseArea {
                    anchors.fill: parent
                    onClicked: Activity.placeDiscsAtOrigine()
                }

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
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }    
}
