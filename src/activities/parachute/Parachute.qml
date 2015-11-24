/* GCompris - parachute.qml
 *
 * Copyright (C) 2015 Rajdeep Kaur <rajdeep51994@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rajdeep kaur<rajdeep51994@gmail.com> (Qt Quick port)
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
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "parachute.js" as Activity

ActivityBase {
    id: activity
    
    property string dataSetUrl: "qrc:/gcompris/src/activities/parachute/resource/"
    
    onStart: focus = true
    onStop: {}

    Keys.onPressed: Activity.processPressedKey(event)
    Keys.onReleased: Activity.processReleasedKey(event)

    pageComponent: Image {
        
        id: background
        source:activity.dataSetUrl + "back.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        anchors.fill: parent

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        
        onStart: {  }
        onStop: { Activity.stop() }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias animationheli:animationheli
            property alias parachuteanimationx:parachuteanimationx
            property alias parachute1Image:parachute1Image
            property alias animationcloud:animationcloud
            property alias bar: bar
            property alias bonus: bonus
            property alias parachuteImage:parachuteImage
            property alias helicopter: helicopter
            property alias animationboat:animationboat
            property alias parachuteanimation:parachuteanimation
            property alias keyunable:keyunable
            property alias parachuteanimationup:parachuteanimationup
            property alias parachuteanimationdown:parachuteanimationdown
            property alias parachuteanimationrelup: parachuteanimationrelup
            property alias   parachuteanimationreldown: parachuteanimationreldown
        }

        IntroMessage {
            id:message
            onIntroDone: {
                Activity.start(items)

            }
            intro: [
                qsTr("The red boat moves in the water from left to right."),
                qsTr("Penguin Tux falls off from the plane, to land on the boat safely. "),
                qsTr("The purpose of the game is to determine the exact time when"
                      + "he should fall off from the plane, in order to safely get to the boat. "),
                qsTr("Tux also carries a parachute, that lets him prevent free fall under gravity, that is dangerous."
                     +"Tux falls off when the player left clicks on the plane."),
                qsTr("His speed can be controlled by the player by pressing UP and DOWN arrow keys,"
                     + "such that Tux is saved from falling in water. "),
                qsTr("Help Tux save his life!")
            ]
            z: 20
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
        }


        Item{
            id:helimotion
            width:helicopter.width
            height:helicopter.height
            x: -width
            Rectangle{
                id:forhover
                width:helicopter.width
                height:helicopter.height
                visible:false
                border.width:7
                radius:20
                border.color:"#A80000"
                color:"#500000"
            }
            Image{
                id:helicopter
                source:activity.dataSetUrl+"tuxplane.svgz"
                MouseArea {
                    id:mousei
                    hoverEnabled: true
                    anchors.fill:parent
                    onEntered:{
                        forhover.visible=true
                    }
                    onExited:{
                        forhover.visible=false
                    }
                    onClicked:{
                        parachute1Image.visible=true
                        Activity.parachuefun()
                    }

                }
            }


            PropertyAnimation {
                id:animationheli
                target:helimotion
                properties: "x"
                from:-helimotion.width
                to:background.width
                duration: (bar.level === 1 ? 20000 : bar.level === 2 ? 16000 : bar.level === 3 ? 12000 : bar.level === 4 ? 10000 : 9000)
                easing.type:Easing.Linear
            }
        }

        Item{
            id:parachutOpen
            Image{
                id:parachuteImage
                visible:false
                source:activity.dataSetUrl+"parachute.svgz"
            }
            Image{
                id:parachute1Image
                visible:false
                source:activity.dataSetUrl+"minitux.svgz"
                MouseArea{
                    id:paramouse
                    anchors.fill:parent
                    onClicked:{
                        parachute1Image.visible=false
                        parachuteImage.visible=true
                        keyunable.visible=true

                    }
                }
                PropertyAnimation{
                    id:parachuteanimation
                    target:parachutOpen
                    properties: "y"
                    from:helicopter.height
                    to:background.height/1.2
                    duration:(bar.level === 1 ? 15000 : bar.level === 2 ? 14000 : bar.level === 3 ? 13000 : bar.level === 4 ? 10000 : 9000)
                    easing.type:Easing.Linear
                }

                PropertyAnimation{
                    id:parachuteanimationup
                    target:parachutOpen
                    properties:  "y"
                    from:parachutOpen.y
                    to:background.height/1.2
                    duration:(bar.level === 1 ? 30000 : bar.level === 2 ? 26000 : bar.level === 3 ? 20000 : bar.level === 4 ? 15000 : 9000)
                    easing.type:Easing.Linear
                }

                PropertyAnimation{
                    id:parachuteanimationdown
                    target:parachutOpen
                    properties:  "y"
                    from:parachutOpen.y
                    to:background.height/1.2
                    duration:(bar.level === 1 ? 6000 : bar.level === 2 ? 5000 : bar.level === 3 ? 4000 : bar.level === 4 ? 2000 : 9000)
                    easing.type:Easing.Linear

                }

                PropertyAnimation{
                    id:parachuteanimationrelup
                    target:parachutOpen
                    properties:  "y"
                    from:parachutOpen.y
                    to:background.height/1.2
                    duration:(bar.level === 1 ? 15000 : bar.level === 2 ? 14000 : bar.level === 3 ? 13000 : bar.level === 4 ? 10000 : 9000)
                    easing.type:Easing.Linear

                }

                PropertyAnimation{
                    id:parachuteanimationreldown
                    target:parachutOpen
                    properties:  "y"
                    from:parachutOpen.y
                    to:background.height/1.2
                    duration:(bar.level === 1 ? 10000 : bar.level === 2 ? 9000 : bar.level === 3 ? 7000 : bar.level === 4 ? 5000 : 9000)
                    easing.type:Easing.Linear
                }



                PropertyAnimation{
                    id:parachuteanimationx
                    target:parachutOpen
                    properties: "x"
                    from:-helimotion.width
                    to:background.width
                    duration:(bar.level === 1 ? 20000 : bar.level === 2 ? 16000 : bar.level === 3 ? 12000 : bar.level === 4 ? 10000 : 9000)
                }
            }
        }
        Item{
            id:cloudmotion
            width:cloud.width
            height:height.height
            Image{
                id:cloud
                source:activity.dataSetUrl+"cloud.svgz"
                y:background.height/7
            }
            PropertyAnimation {
                id:animationcloud
                target:cloudmotion
                properties:"x"
                from:background.width
                to:-cloud.width
                duration:(bar.level === 1 ? 19000 : bar.level === 2 ? 15000 : bar.level === 3 ? 11000 : bar.level === 4 ? 9000 : 9000)
                easing.type:Easing.Linear
            }
        }


        Item{
            id:boatmotion
            width:boat.width
            height:boat.heigt
            Image{
                id:boat
                source:activity.dataSetUrl+"fishingboat.svgz"
                y:background.height/1.2
            }
            PropertyAnimation {
                id:animationboat
                target:boatmotion
                properties:"x"
                from:-boat.width
                to:background.width-2*boat.width
                duration:(bar.level === 1 ? 24000 : bar.level === 2 ? 20500 : bar.level === 3 ? 19000 : bar.level === 4 ? 17000 : 9000)
                easing.type:Easing.Linear
            }
        }


        GCText {
            id:keyunable
            anchors.centerIn: parent
            fontSize: largeSize
            visible:false
            text:"Control fall speed with up and down arrow keys"
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
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
