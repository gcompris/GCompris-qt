/* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
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
import QtQuick 2.1

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
            property alias disc1: disc1
            property alias disc2: disc2
            property alias disc3: disc3
            property alias disc4: disc4
            property alias tower1Image: tower1Image
            property alias tower2Image: tower2Image
            property alias tower3Image: tower3Image
            property alias discOneMouse  : discOneMouse
            property alias discTwoMouse  : discTwoMouse
            property alias discThreeMouse: discThreeMouse
            property alias discFourMouse : discFourMouse

        }

        onStart: { Activity.start(items) }
        onStop : { Activity.stop()       }

        Rectangle
        {
            id: hanoiStage
            width: parent.width
            height: parent.height * .80
            color: "lightgrey"

            property real currentX : 0.0
            property real currentY : 0.0

            // Banner for rules
            Rectangle
            {
                width: parent.width
                height: parent.height * .10
                color: "#527BBD"
                anchors { bottom: parent.bottom ; bottomMargin: 10 }

                Text
                {
                    id: name
                    text: qsTr("Move the entire stack to the right peg, one disc at a time.")
                    font.pixelSize: 35
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            Image
            {
                id: tower1Image
                x: parent.width / 5
                y: parent.height / 4
                source: Activity.url + "disc_support.png"
            }

            Image
            {
                id: tower2Image
                anchors.left: tower1Image.right
                anchors.top: tower1Image.top
                anchors.leftMargin: parent.width / 5
                source: Activity.url + "disc_support.png"
            }

            Image
            {
                id: tower3Image
                anchors.left: tower2Image.right
                anchors.top: tower2Image.top
                anchors.leftMargin: parent.width / 5
                source: Activity.url + "disc_support.png"

                Rectangle
                {
                    color: "pink"
                    radius: 25
                    opacity: .50
                    anchors{ left: parent.left ; right : parent.right ; bottom:  parent.bottom ; top: parent.top ; leftMargin: -25 ; rightMargin:  -25; topMargin:  -25 ; bottomMargin:  -25  }
                    z: -1
                }
            }

            Image
            {
                id: disc1
                x: tower1Image.x - width * .20
                y: tower1Image.y + tower1Image.height * .70
                source: Activity.url + "disc1.png"

                MouseArea
                {
                    id: discOneMouse
                    enabled: false
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XandYAxis

                    drag.minimumX: 0
                    drag.maximumX: hanoiStage.width - parent.width

                    drag.minimumY: 0
                    drag.maximumY: hanoiStage.height - parent.height

                    onPressed:
                    {
                        hanoiStage.currentX = disc1.x
                        hanoiStage.currentY = disc1.y
                        disc1.z ++
                    }

                    onReleased:
                    {
                        // disc 1 is released over tower1Image
                        if( Activity.checkdiscOverTower(1,1) )
                        {
                            if( (0 != Activity.tower1.length && 1 <= Activity.tower1[Activity.tower1.length-1]) )
                            {
                                disc1.x = hanoiStage.currentX
                                disc1.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc1.x = tower1Image.x - width * .20
                                disc1.y = tower1Image.y + tower1Image.height * .70 - ( (Activity.tower1.length) *  disc1.height)

                                Activity.popdisc(1)

                                Activity.tower1.push(1)
                                Activity.discs[1] = 1
                            }
                        }

                        // disc 1 is released over tower2Image
                        else if( Activity.checkdiscOverTower(1,2)  )
                        {
                            if( 0 != Activity.tower2.length && 1 <= Activity.tower2[Activity.tower2.length-1] )
                            {
                                disc1.x = hanoiStage.currentX
                                disc1.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc1.x = tower2Image.x - width * .20
                                disc1.y = tower2Image.y + tower2Image.height * .70 - ( (Activity.tower2.length) *  disc1.height)

                                Activity.popdisc(1)

                                Activity.tower2.push(1)
                                Activity.discs[1] = 2
                            }
                        }

                        // disc 1 is released over tower3Image
                        else if( Activity.checkdiscOverTower(1,3) )
                        {
                            if( 0 != Activity.tower3.length && 1 <= Activity.tower3[Activity.tower3.length-1] )
                            {
                                disc1.x = hanoiStage.currentX
                                disc1.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc1.x = tower3Image.x - width * .20
                                disc1.y = tower3Image.y + tower3Image.height * .70 - ( (Activity.tower3.length) *  disc1.height)

                                Activity.popdisc(1)

                                Activity.tower3.push(1)
                                Activity.discs[1] = 3
                            }
                        }

                        else
                        {
                            disc1.x = hanoiStage.currentX
                            disc1.y = hanoiStage.currentY
                        }

                        Activity.disableNonDraggablediscs()
                        Activity.checkSolved()
                    }
                }
            }

            Image
            {
                id: disc2
                x: tower1Image.x - width * .18
                y: tower1Image.y + tower1Image.height * .70 - disc1.height
                source: Activity.url + "disc2.png"

                MouseArea
                {
                    id: discTwoMouse
                    enabled: false
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XandYAxis

                    drag.minimumX: 0
                    drag.maximumX: hanoiStage.width - parent.width

                    drag.minimumY: 0
                    drag.maximumY: hanoiStage.height - parent.height

                    onPressed:
                    {
                        hanoiStage.currentX = disc2.x
                        hanoiStage.currentY = disc2.y
                        disc2.z ++
                    }

                    onReleased:
                    {
                        // disc 2 is released over tower1Image
                        if( Activity.checkdiscOverTower(2,1) )
                        {
                            if( (0 != Activity.tower1.length && 2 <= Activity.tower1[Activity.tower1.length-1]) )
                            {
                                disc2.x = hanoiStage.currentX
                                disc2.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc2.x = tower1Image.x - width * .18
                                disc2.y = tower1Image.y + tower1Image.height * .70 - ( (Activity.tower1.length) *  disc1.height)

                                Activity.popdisc(2)

                                Activity.tower1.push(2)
                                Activity.discs[2] = 1
                            }
                        }

                        // disc 2 is released over tower2Image
                        else if( Activity.checkdiscOverTower(2,2)  )
                        {
                            if( 0 != Activity.tower2.length && 2 <= Activity.tower2[Activity.tower2.length-1] )
                            {
                                disc2.x = hanoiStage.currentX
                                disc2.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc2.x = tower2Image.x - width * .18
                                disc2.y = tower2Image.y + tower2Image.height * .70 - ( (Activity.tower2.length) *  disc1.height)

                                Activity.popdisc(2)

                                Activity.tower2.push(2)
                                Activity.discs[2] = 2
                            }
                        }

                        // disc 2 is released over tower3Image
                        else if( Activity.checkdiscOverTower(2,3) )
                        {
                            if( 0 != Activity.tower3.length && 2 <= Activity.tower3[Activity.tower3.length-1] )
                            {
                                disc2.x = hanoiStage.currentX
                                disc2.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc2.x = tower3Image.x - width * .18
                                disc2.y = tower3Image.y + tower3Image.height * .70 - ( (Activity.tower3.length) *  disc1.height)

                                Activity.popdisc(2)

                                Activity.tower3.push(2)
                                Activity.discs[2] = 3
                            }
                        }

                        else
                        {
                            disc2.x = hanoiStage.currentX
                            disc2.y = hanoiStage.currentY
                        }

                        Activity.disableNonDraggablediscs()
                        Activity.checkSolved()
                    }
                }
            }

            Image
            {
                id: disc3
                x: tower1Image.x - width * .15
                y: tower1Image.y + tower1Image.height * .70 - disc1.height - disc2.height
                source: Activity.url + "disc3.png"

                MouseArea
                {
                    id: discThreeMouse
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XandYAxis

                    drag.minimumX: 0
                    drag.maximumX: hanoiStage.width - parent.width

                    drag.minimumY: 0
                    drag.maximumY: hanoiStage.height - parent.height

                    onPressed:
                    {
                        hanoiStage.currentX = disc3.x
                        hanoiStage.currentY = disc3.y
                        disc3.z ++
                    }

                    onReleased:
                    {
                        // disc 3 is released over tower1Image
                        if( Activity.checkdiscOverTower(3,1) )
                        {
                            if( (0 != Activity.tower1.length && 3 <= Activity.tower1[Activity.tower1.length-1]) )
                            {
                                disc3.x = hanoiStage.currentX
                                disc3.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc3.x = tower1Image.x - width * .20
                                disc3.y = tower1Image.y + tower1Image.height * .70 - ( (Activity.tower1.length) *  disc1.height)

                                Activity.popdisc(3)

                                Activity.tower1.push(3)
                                Activity.discs[3] = 1
                            }
                        }

                        // disc 3 is released over tower2Image
                        else if( Activity.checkdiscOverTower(3,2)  )
                        {
                            if( 0 != Activity.tower2.length && 3 <= Activity.tower2[Activity.tower2.length-1] )
                            {
                                disc3.x = hanoiStage.currentX
                                disc3.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc3.x = tower2Image.x - width * .20
                                disc3.y = tower2Image.y + tower2Image.height * .70 - ( (Activity.tower2.length) *  disc1.height)

                                Activity.popdisc(3)

                                Activity.tower2.push(3)
                                Activity.discs[3] = 2
                            }
                        }

                        // disc 3 is released over tower3Image
                        else if( Activity.checkdiscOverTower(3,3) )
                        {
                            if( 0 != Activity.tower3.length && 3 <= Activity.tower3[Activity.tower3.length-1] )
                            {
                                disc3.x = hanoiStage.currentX
                                disc3.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc3.x = tower3Image.x - width * .20
                                disc3.y = tower3Image.y + tower3Image.height * .70 - ( (Activity.tower3.length) *  disc1.height)

                                Activity.popdisc(3)

                                Activity.tower3.push(3)
                                Activity.discs[3] = 3
                            }
                        }

                        else
                        {
                            disc3.x = hanoiStage.currentX
                            disc3.y = hanoiStage.currentY
                        }

                        Activity.disableNonDraggablediscs()
                        Activity.checkSolved()
                    }
                }
            }

            Image
            {
                id: disc4
                x: tower1Image.x - width * .15
                y: tower1Image.y + tower1Image.height * .70 - disc1.height - disc2.height - disc3.height
                source: Activity.url + "disc4.png"
                height: 0

                MouseArea
                {
                    id: discFourMouse
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XandYAxis

                    drag.minimumX: 0
                    drag.maximumX: hanoiStage.width - parent.width

                    drag.minimumY: 0
                    drag.maximumY: hanoiStage.height - parent.height

                    onPressed:
                    {
                        hanoiStage.currentX = disc4.x
                        hanoiStage.currentY = disc4.y
                    }

                    onReleased:
                    {
                        // disc 4 is released over tower1Image
                        if( Activity.checkdiscOverTower(4,1) )
                        {
                            if( (0 != Activity.tower1.length && 4 <= Activity.tower1[Activity.tower1.length-1]) )
                            {
                                disc4.x = hanoiStage.currentX
                                disc4.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc4.x = tower1Image.x - width * .20
                                disc4.y = tower1Image.y + tower1Image.height * .70 - ( (Activity.tower1.length) *  disc1.height)

                                Activity.popdisc(4)

                                Activity.tower1.push(4)
                                Activity.discs[4] = 1
                            }
                        }

                        // disc 4 is released over tower2Image
                        else if( Activity.checkdiscOverTower(4,2)  )
                        {
                            if( 0 != Activity.tower2.length && 4 <= Activity.tower2[Activity.tower2.length-1] )
                            {
                                disc4.x = hanoiStage.currentX
                                disc4.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc4.x = tower2Image.x - width * .20
                                disc4.y = tower2Image.y + tower2Image.height * .70 - ( (Activity.tower2.length) *  disc1.height)

                                Activity.popdisc(4)

                                Activity.tower2.push(4)
                                Activity.discs[4] = 2
                            }
                        }

                        // disc 4 is released over tower3Image
                        else if( Activity.checkdiscOverTower(4,3) )
                        {
                            if( 0 != Activity.tower3.length && 4 <= Activity.tower3[Activity.tower3.length-1] )
                            {
                                disc4.x = hanoiStage.currentX
                                disc4.y = hanoiStage.currentY
                            }

                            else
                            {
                                disc4.x = tower3Image.x - width * .20
                                disc4.y = tower3Image.y + tower3Image.height * .70 - ( (Activity.tower3.length) *  disc1.height)

                                Activity.popdisc(4)

                                Activity.tower3.push(4)
                                Activity.discs[4] = 3
                            }
                        }

                        else
                        {
                            disc4.x = hanoiStage.currentX
                            disc4.y = hanoiStage.currentY
                        }

                        Activity.disableNonDraggablediscs()
                        Activity.checkSolved()
                    }
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
