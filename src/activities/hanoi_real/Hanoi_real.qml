/* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2014 <Amit Tomar>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
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

import "../../core"
import "hanoi_real.js" as Activity

import QtQuick 2.0
import QtGraphicalEffects 1.0

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
            property int maxDiscs     : 4
            property int totalLevels  : 2
            property int maxZ : 5
        }

        onStart: { Activity.start(items) ; Activity.resetToGetLevel(1) }
        onStop : { Activity.stop()       }

        onWidthChanged: {
            for( var i = 0 ; i < items.totalLevels + 2 ; ++i )
                discRepeater.itemAt(i).reposition()

            Activity.deHighlightTowers()
        }

        onHeightChanged: {
            for( var i = 0 ; i < items.totalLevels + 2 ; ++i )
                discRepeater.itemAt(i).reposition()

            Activity.deHighlightTowers()
        }

        Rectangle {
            id: hanoiStage
            width: parent.width
            height: parent.height * .80
            color: "lightgrey"

            property real currentX : 0.0
            property real currentY : 0.0

            Rectangle {
                width: parent.width
                height: parent.height * .20
                color: "#527BBD"
                anchors { bottom: parent.bottom ; bottomMargin: 10 }

                Text {
                    id: description
                    text: qsTr("Move the entire stack to the right peg, one disc at a time.")
                    width: parent.width * .70
                    font.pixelSize: description.width > 300 ? 25 : 20
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
                model : items.totalLevels + 2

                Image {
                    id: disc
                    parent: hanoiStage
                    opacity: index >= 3 ? 0 : 1

                    property alias discX: disc.x
                    property alias discY: disc.y

                    property real discWidth : disc.width
                    property real discHeight: disc.height

                    property bool mouseEnabled : true

                    signal reposition()

                    onXChanged: {
                        if( discMouseArea.pressed ) {

                            Activity.deHighlightTowers()
                            if( Activity.checkIfDiscOnTowerImage(index+1, 1) )
                                Activity.highlightTower(1)
                            if( Activity.checkIfDiscOnTowerImage(index+1, 2) )
                                Activity.highlightTower(2)
                            if( Activity.checkIfDiscOnTowerImage(index+1, 3) )
                                Activity.highlightTower(3)
                        }
                    }

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

                    onReposition: {
                        var position;
                        var newX;
                        var newY;

                         if( Activity.checkDiscInTower(index+1, Activity.tower1) ){

                             newX = tower1Image.x
                             newY = tower1Image.y
                             position = Activity.getDiscPositionInTower( index+1, Activity.tower1 )
                         }
                         else if( Activity.checkDiscInTower(index+1, Activity.tower2) ){

                             newX = tower2Image.x
                             newY = tower2Image.y
                             position = Activity.getDiscPositionInTower( index+1, Activity.tower2 )
                         }
                         else if( Activity.checkDiscInTower(index+1, Activity.tower3) ){

                             newX = tower3Image.x
                             newY = tower3Image.y
                             position = Activity.getDiscPositionInTower( index+1, Activity.tower3 )
                         }

                         disc.x = newX - items.discRepeater.itemAt(0).discWidth * (.22 - index * .05 )
                         disc.y = newY + tower1Image.height * .70 - ((position-1) *  disc.height)
                         Activity.disableNonDraggablediscs()
                    }

                    x: 20 * index
                    y: 20 * index
                    z: tower1Image.z + 1

                    source: if( 0 == index ) Activity.url + "disc1.png"
                            else if ( 1 == index ) Activity.url + "disc2.png"
                            else if ( 2 == index ) Activity.url + "disc3.png"
                            else if ( 3 == index ) Activity.url + "disc4.png"

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

                        onReleased: {
                            if( Activity.checkIfDiscOnTowerImage(index+1,1) && !(0 != Activity.tower1.length && index+1 <= Activity.tower1[Activity.tower1.length-1]) ) {
                                    disc.x = tower1Image.x - items.discRepeater.itemAt(0).discWidth * (.22 - index * .05 )
                                    disc.y = tower1Image.y + tower1Image.height * .70 - ( (Activity.tower1.length) *  disc.height)

                                    Activity.popDisc(index+1)

                                    Activity.tower1.push(index+1)
                                    Activity.discs[index+1] = 1
                            }

                            else if( Activity.checkIfDiscOnTowerImage(index+1,2) && !( 0 != Activity.tower2.length && index+1 <= Activity.tower2[Activity.tower2.length-1] ) ) {
                                    disc.x = tower2Image.x - items.discRepeater.itemAt(0).discWidth * (.22 - index * .05 )
                                    disc.y = tower2Image.y + tower2Image.height * .70 - ( (Activity.tower2.length) *  disc.height)

                                    Activity.popDisc(index+1)

                                    Activity.tower2.push(index+1)
                                    Activity.discs[index+1] = 2
                            }

                            else if( Activity.checkIfDiscOnTowerImage(index+1,3) && !( 0 != Activity.tower3.length && index+1 <= Activity.tower3[Activity.tower3.length-1] ) ) {
                                    disc.x = tower3Image.x - items.discRepeater.itemAt(0).discWidth * (.22 - index * .05 )
                                    disc.y = tower3Image.y + tower3Image.height * .70 - ( (Activity.tower3.length) *  disc.height)

                                    Activity.popDisc(index+1)

                                    Activity.tower3.push(index+1)
                                    Activity.discs[index+1] = 3
                            }

                            else {
                                disc.x = hanoiStage.currentX
                                disc.y = hanoiStage.currentY
                            }

                            Activity.disableNonDraggablediscs()
                            Activity.checkSolved()
                            Activity.deHighlightTowers()
                        }
                    }
                }
            }

            property real spacing : (hanoiStage.width - 3 * tower1Image.width) / 4

            Image {
                id: tower1Image
                x: parent.spacing
                y: parent.spacing / 3
                source: Activity.url + "disc_support.png"

                Colorize {
                    id: tower1ImageHighlight
                    anchors.fill: parent
                    source: parent
                    hue: 0.4
                    saturation: 1
                    lightness: .5
                    cached: true
                    opacity: 0

                        Behavior on opacity
                        {
                                 PropertyAnimation {
                                            duration: 150
                                     }
                        }

                }
            }

            Image {
                id: tower2Image
                anchors.left: tower1Image.right
                anchors.top: tower1Image.top
                anchors.leftMargin: parent.spacing
                source: Activity.url + "disc_support.png"

                Colorize {
                    id: tower2ImageHighlight
                    anchors.fill: parent
                    source: parent
                    hue: 0.4
                    saturation: 1
                    lightness: .5
                    cached: true
                    opacity: 0

                        Behavior on opacity
                        {
                                 PropertyAnimation {
                                            duration: 150
                                     }
                        }

                }
            }

            Image {
                id: tower3Image
                anchors.left: tower2Image.right
                anchors.top: tower2Image.top
                anchors.leftMargin: parent.spacing
                source: Activity.url + "disc_support.png"

                Colorize {
                    id: tower3ImageHighlight
                    anchors.fill: parent
                    source: parent
                    hue: 0.4
                    saturation: 1
                    lightness: .5
                    cached: true
                    opacity: 0

                        Behavior on opacity
                        {
                                 PropertyAnimation {
                                            duration: 150
                                     }
                        }
                }

                Colorize {
                    id: tower3ImageHighlightGlow
                    anchors.fill: parent
                    source: parent
                    hue: 1.0
                    saturation:  1
                    lightness:   0
                    cached: true
                    opacity: tower3ImageHighlight.opacity == 0 ? .5 : 0
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Activity.placeDiscsAtOriginal()
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }    
}
