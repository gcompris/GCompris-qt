/* GCompris - droftware_activity.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import "droftware_activity.js" as Activity

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

        Item{
            id: surface
            anchors.fill: parent


            GCText {
                id: status
                text: "Color the graph"
                fontSize: 20
                font.weight: Font.DemiBold
                color: "white"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 50
                anchors.verticalCenterOffset: 100
            }
            Image{
                id: okButton
                anchors.right: parent.right
                anchors.rightMargin: 50
                height:100
                width:100
                anchors.verticalCenter: parent.verticalCenter
                source:"qrc:/gcompris/src/core/resource/apply.svg"

                MouseArea{
                    id:okArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered:{
                        okButton.height = 120
                        okButton.width = 120
                    }
                    onExited:{
                        okButton.height = 100
                        okButton.width = 100
                    }

                    onClicked:{
                        var flag = 0;
                        for(var i=0; i<edgesModel.count; i++){
                            if(edgesModel.get(i).node1.color === edgesModel.get(i).node2.color){
                                flag = 1;
                                break;
                            }
                        }
                        if(flag == 0){
                            console.log("You matched correctly");
                            status.text = "You matched correctly"

                        }
                        else{
                            console.log("You matched it wrong");
                            status.text = "You matched it wrong"
                        }


                    }
                }

            }

            Canvas{
                id: edgeCanvas
                anchors.fill:parent
                onPaint:{
                    var ctx = getContext("2d")

                    ctx.lineWidth = 4
                    ctx.strokeStyle = "black"
                    ctx.beginPath()
                    //Edge 1
                    ctx.moveTo(nodeADrop.x + nodeADrop.width/2, nodeADrop.y + nodeADrop.width/2)
                    ctx.lineTo(nodeBDrop.x + nodeBDrop.width/2, nodeBDrop.y + nodeBDrop.width/2)
                    //Edge 2
                    ctx.moveTo(nodeADrop.x + nodeADrop.width/2, nodeADrop.y + nodeADrop.width/2)
                    ctx.lineTo(nodeCDrop.x + nodeCDrop.width/2, nodeCDrop.y + nodeCDrop.width/2)
                    //Edge 3
                    ctx.moveTo(nodeBDrop.x + nodeBDrop.width/2, nodeBDrop.y + nodeBDrop.width/2)
                    ctx.lineTo(nodeEDrop.x + nodeEDrop.width/2, nodeEDrop.y + nodeEDrop.width/2)
                    //Edge 4
                    ctx.moveTo(nodeCDrop.x + nodeCDrop.width/2, nodeCDrop.y + nodeCDrop.width/2)
                    ctx.lineTo(nodeDDrop.x + nodeDDrop.width/2, nodeDDrop.y + nodeDDrop.width/2)
                    //Edge 5
                    ctx.moveTo(nodeEDrop.x + nodeEDrop.width/2, nodeEDrop.y + nodeEDrop.width/2)
                    ctx.lineTo(nodeDDrop.x + nodeDDrop.width/2, nodeDDrop.y + nodeDDrop.width/2)
                    //Edge 6
                    ctx.moveTo(nodeADrop.x + nodeADrop.width/2, nodeADrop.y + nodeADrop.width/2)
                    ctx.lineTo(nodeFDrop.x + nodeFDrop.width/2, nodeFDrop.y + nodeFDrop.width/2)
                    //Edge 7
                    ctx.moveTo(nodeFDrop.x + nodeFDrop.width/2, nodeFDrop.y + nodeFDrop.width/2)
                    ctx.lineTo(nodeGDrop.x + nodeGDrop.width/2, nodeGDrop.y + nodeGDrop.width/2)
                    //Edge 8
                    ctx.moveTo(nodeFDrop.x + nodeFDrop.width/2, nodeFDrop.y + nodeFDrop.width/2)
                    ctx.lineTo(nodeHDrop.x + nodeHDrop.width/2, nodeHDrop.y + nodeHDrop.width/2)
                    //Edge 9
                    ctx.moveTo(nodeEDrop.x + nodeEDrop.width/2, nodeEDrop.y + nodeEDrop.width/2)
                    ctx.lineTo(nodeHDrop.x + nodeHDrop.width/2, nodeHDrop.y + nodeHDrop.width/2)
                    //Edge 10
                    ctx.moveTo(nodeDDrop.x + nodeDDrop.width/2, nodeDDrop.y + nodeDDrop.width/2)
                    ctx.lineTo(nodeGDrop.x + nodeGDrop.width/2, nodeGDrop.y + nodeGDrop.width/2)
                    //Edge 11
                    ctx.moveTo(nodeJDrop.x + nodeJDrop.width/2, nodeJDrop.y + nodeJDrop.width/2)
                    ctx.lineTo(nodeHDrop.x + nodeHDrop.width/2, nodeHDrop.y + nodeHDrop.width/2)
                    //Edge 12
                    ctx.moveTo(nodeIDrop.x + nodeIDrop.width/2, nodeIDrop.y + nodeIDrop.width/2)
                    ctx.lineTo(nodeGDrop.x + nodeGDrop.width/2, nodeGDrop.y + nodeGDrop.width/2)
                    //Edge 13
                    ctx.moveTo(nodeIDrop.x + nodeIDrop.width/2, nodeIDrop.y + nodeIDrop.width/2)
                    ctx.lineTo(nodeJDrop.x + nodeJDrop.width/2, nodeJDrop.y + nodeJDrop.width/2)
                    //Edge 14
                    ctx.moveTo(nodeCDrop.x + nodeCDrop.width/2, nodeCDrop.y + nodeCDrop.width/2)
                    ctx.lineTo(nodeJDrop.x + nodeJDrop.width/2, nodeJDrop.y + nodeJDrop.width/2)
                    //Edge 15
                    ctx.moveTo(nodeIDrop.x + nodeIDrop.width/2, nodeIDrop.y + nodeIDrop.width/2)
                    ctx.lineTo(nodeBDrop.x + nodeBDrop.width/2, nodeBDrop.y + nodeBDrop.width/2)




                    ctx.stroke()

                }
            }

            ListModel{
                id: edgesModel
                /*ListElement{ "node1": nodeADrop "node2": nodeBDrop }
                ListElement{ "node1": nodeADrop; "node2": nodeCDrop }
                ListElement{ "node1": nodeBDrop; "node2": nodeEDrop }
                ListElement{ "node1": nodeCDrop; "node2": nodeDDrop }
                ListElement{ "node1": nodeEDrop; "node2": nodeDDrop }*/
            }

            DropArea{
                    id : nodeADrop
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -150
                    width: 50
                    height: 50
                    property alias color: nodeA.color

                    /*onEntered:  {
                        nodeA.color = "grey"
                    }
                    onExited: {
                        nodeA.color = "white"
                    }*/
                    onDropped: {
                        nodeA.color = drag.source.color
                    }
                    Rectangle {
                        id:nodeA
                        radius: width/2
                        anchors.fill: parent
                        color: "white"
                        border.color: "black"
                        border.width : 4
                        visible: true
                        Behavior on color {
                                    ColorAnimation { duration: 250 }
                                }
                    }

                }
            DropArea{
                    id: nodeBDrop
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenterOffset: 75
                    anchors.verticalCenterOffset: 150
                    width: 50; height: 50
                    property alias color: nodeB.color
                    /*onEntered:  {
                        nodeA.color = "grey"
                    }
                    onExited: {
                        nodeA.color = "white"
                    }*/
                    onDropped: {
                        nodeB.color = drag.source.color
                    }


                    Rectangle {
                        id:nodeB
                        radius: width/2
                        anchors.fill: parent
                        color: "white"
                        border.color: "black"
                        border.width : 4
                        visible: true
                        Behavior on color {
                                    ColorAnimation { duration: 250 }
                                }
                    }
                }
                DropArea{
                    id: nodeCDrop
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenterOffset: -75
                    anchors.verticalCenterOffset: 150
                    width: 50; height: 50
                    property alias color: nodeC.color
                    onDropped: {
                        nodeC.color = drag.source.color
                    }
                    Rectangle {
                        id:nodeC
                        radius: width/2
                        anchors.fill: parent
                        color: "white"
                        border.color: "black"
                        border.width : 4
                        visible: true
                        Behavior on color {
                                    ColorAnimation { duration: 500 }
                                }
                    }
                }
                DropArea{
                    id: nodeDDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: 150
                        property alias color: nodeD.color
                        width: 50; height: 50
                        /*onEntered:  {
                            nodeA.color = "grey"
                        }
                        onExited: {
                            nodeA.color = "white"
                        }*/
                        onDropped: {
                            nodeD.color = drag.source.color
                        }


                        Rectangle {
                            id:nodeD
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 500 }
                                    }
                        }
                    }
                DropArea{
                    id: nodeEDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: -150
                        width: 50; height: 50
                        property alias color: nodeE.color
                        /*onEntered:  {
                            nodeA.color = "grey"
                        }
                        onExited: {
                            nodeA.color = "white"
                        }*/
                        onDropped: {
                            nodeE.color = drag.source.color
                        }


                        Rectangle {
                            id:nodeE
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 1000 }
                                    }
                        }
                    }
                DropArea{
                    id: nodeFDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -250
                        width: 50; height: 50
                        property alias color: nodeF.color
                        onDropped: {
                            nodeF.color = drag.source.color
                        }
                        Rectangle {
                            id:nodeF
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 1000 }
                                    }
                        }
                    }
                DropArea{
                    id: nodeGDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: 250
                        anchors.verticalCenterOffset: -50
                        width: 50; height: 50
                        property alias color: nodeG.color
                        onDropped: {
                            nodeG.color = drag.source.color
                        }
                        Rectangle {
                            id:nodeG
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 1000 }
                                    }
                        }
                    }
                DropArea{
                    id: nodeHDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: -250
                        anchors.verticalCenterOffset: -50
                        width: 50; height: 50
                        property alias color: nodeH.color
                        onDropped: {
                            nodeH.color = drag.source.color
                        }
                        Rectangle {
                            id:nodeH
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 1000 }
                                    }
                        }
                    }
                DropArea{
                    id: nodeIDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: 150
                        anchors.verticalCenterOffset: 225
                        width: 50; height: 50
                        property alias color: nodeI.color
                        onDropped: {
                            nodeI.color = drag.source.color
                        }
                        Rectangle {
                            id:nodeI
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 1000 }
                                    }
                        }
                    }
                DropArea{
                    id: nodeJDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: -150
                        anchors.verticalCenterOffset: 225
                        width: 50; height: 50
                        property alias color: nodeJ.color
                        onDropped: {
                            nodeJ.color = drag.source.color
                        }
                        Rectangle {
                            id:nodeJ
                            radius: width/2
                            anchors.fill: parent
                            color: "white"
                            border.color: "black"
                            border.width : 4
                            visible: true
                            Behavior on color {
                                        ColorAnimation { duration: 1000 }
                                    }
                        }
                    }
                //******************--------------------Brushes below
                Rectangle {
                        id: brushRed
                        x:10
                        y:20
                        width: 50
                        height: 50
                        radius: width/2
                        color: "red"
                        Drag.active: dragAreaRed.drag.active
                        Drag.hotSpot.x: 10
                        Drag.hotSpot.y: 10

                        MouseArea {
                            id: dragAreaRed
                            anchors.fill: parent
                            drag.target: parent
                            onReleased: {
                                parent.Drag.drop()
                                parent.x = 10
                                parent.y = 20
                            }
                        }
                    }
                Rectangle {
                    id: brushGreen
                        x:70
                        y:20
                        width: 50
                        height: 50
                        radius: width/2
                        color: "green"

                        Drag.active: dragAreaGreen.drag.active
                        Drag.hotSpot.x: 10
                        Drag.hotSpot.y: 10

                        MouseArea {
                            id: dragAreaGreen
                            anchors.fill: parent
                            drag.target: parent
                            onReleased: {
                                parent.Drag.drop()
                                parent.x = 70
                                parent.y = 20
                        }
                    }
                }
                Rectangle {
                    id: brushOrange
                        x:130
                        y:20
                        width: 50
                        height: 50
                        radius: width/2
                        color: "orange"

                        Drag.active: dragAreaOrange.drag.active
                        Drag.hotSpot.x: 10
                        Drag.hotSpot.y: 10

                        MouseArea {
                            id: dragAreaOrange
                            anchors.fill: parent
                            drag.target: parent
                            onReleased: {
                                parent.Drag.drop()
                                parent.x = 130
                                parent.y = 20
                        }
                    }
                }
                Rectangle {
                    id: brushBlue
                        x:190
                        y:20
                        width: 50
                        height: 50
                        radius: width/2
                        color: "blue"

                        Drag.active: dragAreaBlue.drag.active
                        Drag.hotSpot.x: 10
                        Drag.hotSpot.y: 10

                        MouseArea {
                            id: dragAreaBlue
                            anchors.fill: parent
                            drag.target: parent
                            onReleased: {
                                parent.Drag.drop()
                                parent.x = 190
                                parent.y = 20
                        }
                    }
                }
                Rectangle {
                    id: brushPurple
                        x:250
                        y:20
                        width: 50
                        height: 50
                        radius: width/2
                        color: "purple"

                        Drag.active: dragAreaPurple.drag.active
                        Drag.hotSpot.x: 10
                        Drag.hotSpot.y: 10

                        MouseArea {
                            id: dragAreaPurple
                            anchors.fill: parent
                            drag.target: parent
                            onReleased: {
                                parent.Drag.drop()
                                parent.x = 250
                                parent.y = 20
                        }
                    }
                }

                Component.onCompleted:{
                    edgesModel.append({"node1": nodeADrop, "node2": nodeBDrop})
                    edgesModel.append({"node1": nodeADrop, "node2": nodeCDrop})
                    edgesModel.append({"node1": nodeBDrop, "node2": nodeEDrop})
                    edgesModel.append({"node1": nodeCDrop, "node2": nodeDDrop})
                    edgesModel.append({"node1": nodeEDrop, "node2": nodeDDrop})
                    edgesModel.append({"node1": nodeADrop, "node2": nodeFDrop})
                    edgesModel.append({"node1": nodeFDrop, "node2": nodeGDrop})
                    edgesModel.append({"node1": nodeFDrop, "node2": nodeHDrop})
                    edgesModel.append({"node1": nodeEDrop, "node2": nodeHDrop})
                    edgesModel.append({"node1": nodeDDrop, "node2": nodeGDrop})
                    edgesModel.append({"node1": nodeJDrop, "node2": nodeHDrop})
                    edgesModel.append({"node1": nodeIDrop, "node2": nodeGDrop})
                    edgesModel.append({"node1": nodeIDrop, "node2": nodeJDrop})
                    edgesModel.append({"node1": nodeCDrop, "node2": nodeJDrop})
                    edgesModel.append({"node1": nodeBDrop, "node2": nodeIDrop})

                }
        }

// ****************************************


        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }


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
