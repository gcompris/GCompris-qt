
/* GCompris - CategoryReview.qml
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
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

import "../../core"
import "categorization.js" as Activity

Item {
    id: rootItem
    property alias categorybackground: categorybackground
    property alias repeater: repeater
    property alias score: score
    property alias imagesdataset: imagesdataset
    property alias categorydataset: categorydataset
    property alias instructionBox: instructionBox
    property bool isDropped : true
    property bool leftAreaContainsDrag: false
    property bool rightAreaContainsDrag: false
    property bool started: rootItem.opacity == 1
    property bool horizontalLayout: categorybackground.width > categorybackground.height
    
    anchors.fill: parent
    signal pressed
    
    Loader {
        id: imagesdataset
        asynchronous: false
    }
    
    Loader {
        id: categorydataset
        asynchronous: false
    }
    
    Image {
        id: categorybackground
        source: "qrc:/gcompris/src/activities/categorization/resource/background.svg"
        anchors.fill: parent
        sourceSize.width:parent.width
        
        Rectangle {
            id: leftscreen
            width: parent.width/3
            height: parent.height
            anchors.left: parent.left
            color: leftAreaContainsDrag ? "#9933FF" : "red"
            opacity: 0.52
        }
        
        Rectangle {
            id: rightscreen      
            width: parent.width/3.2
            height: parent.width
            anchors.right: parent.right
            anchors.bottom: categorybackground.bottom
            anchors.top: categorybackground.top
            color: rightAreaContainsDrag ? "#FFCC00" : "green"
            opacity: 0.47
        }
        
        Rectangle {
            id: middlescreen
            anchors.left: leftscreen.right
            anchors.right: rightscreen.left
            color: Qt.rgba(1,1,1,0)
            width: parent.width/3
            height: parent.width  
        }
        
        Rectangle {
            id: instructionBox
            anchors.left: score.right
            anchors.right: categoryimage.left
            anchors.leftMargin: 0.1 * parent.width
            anchors.rightMargin: 0.03 * parent.width
            color: "black"
            opacity: items.instructionsChecked ? 0.85 : 0
            z: 3
            radius: 10
            border.width: 2
            width: horizontalLayout ? parent.width/5 : parent.width/3
            height: horizontalLayout ? parent.height/6 : parent.height * 0.09
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
        }

        Flow {
            id: options
            y: instructions.height
            spacing: 0.012 * middlescreen.width
            anchors{
                left: leftscreen.right
                right: rightscreen.left
                top: parent.top
                topMargin: 0.05 * parent.height
                bottom: categorybackground.bottom
                leftMargin: 0.015 * middlescreen.width
            }
            
            Repeater {
                id:repeater
                
                Item {
                    id: item
                    width: middlescreen.width*0.32
                    height: categorybackground.height * 0.2
                    opacity: 1
                    
                    Image {
                        id: image
                        source: modelData.src
                        anchors.fill: parent
                    }
                    property string droppedPosition: "middle"
                    property bool isRight: modelData.isRight
                    
                    MultiPointTouchArea {
                        id: dragArea
                        anchors.fill: parent
                        touchPoints: [ TouchPoint { id: point1 } ]
                        property real positionX
                        property real positionY
                        property real lastX
                        property real lastY 
                        
                        onPressed: {
                            items.instructionsChecked = false
                            positionX = point1.x
                            positionY = point1.y
                        }
                        
                        onUpdated: {
                            var moveX = point1.x - positionX
                            var moveY = point1.y - positionY
                            parent.x = parent.x + moveX
                            parent.y = parent.y + moveY
                            leftAreaContainsDrag = isDragInLeftArea(0,parent.x+parent.width)
                            rightAreaContainsDrag = isDragInRightArea(rootItem.width/3,parent.x)
                            lastX = 0, lastY = 0
                        }
                        
                        onReleased: {
                            if(lastX == point1.x && lastY == point1.y)
                                return ;
                            //Drag.drop();
                            if(leftAreaContainsDrag) {
                                item.droppedPosition = "left";
                                activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/smudge.wav")    
                            }
                            
                            else if(rightAreaContainsDrag) {
                                item.droppedPosition = "right";
                                activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/smudge.wav")
                            }
                            
                            else {
                                item.droppedPosition = "middle";
                            }
                            leftAreaContainsDrag = false;
                            rightAreaContainsDrag = false;
                            lastX = point1.x, lastY = point1.y
                        }
                    }
                }
            }
        }
        
        GCText {
            id: instructions
            text: items.details ? items.details[bar.level - 1].instructions : ""
            visible: items.instructionsChecked
            anchors.fill: instructionBox
            anchors.bottom: instructionBox.bottom
            font.pixelSize: horizontalLayout ? 0.039 * parent.height : 0.016 * parent.height
            wrapMode: Text.Wrap
            z: 3
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
        
        Image {
            id:categoryimage
            source: items.details ? items.details[bar.level-1].image : ""
            width: horizontalLayout ? rightscreen.width * 0.35 : rightscreen.width * 0.35
            height: horizontalLayout ? rightscreen.height * 0.18 : rightscreen.height * 0.15
            y: 0.015*parent.height
            visible: items.categoryImageChecked
            anchors {
                left: middlescreen.right
                leftMargin: 0.35 * rightscreen.width
            }
        }
        
        BarButton {
            id: validate
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: horizontalLayout ? rightscreen.width * 0.20 : rightscreen.width * 0.35
            height: horizontalLayout ? rightscreen.width * 0.20 : rightscreen.width * 0.35
            y: parent.height*0.8
            anchors{
                rightMargin: 14 * ApplicationInfo.ratio
                right: parent.right
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Activity.allPlaced();
                }                
            }
        }
        
        DropArea {
            id: rightArea
            anchors.fill: rightscreen
        }
        
        DropArea {
            id: leftArea
            anchors.fill: leftscreen
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        Score {
            id: score
            fontSize: horizontalLayout ? 0.013 * parent.width : 0.02 * parent.width
            visible: items.scoreChecked
            height: horizontalLayout ? 0.1 * parent.height : 0.06 * parent.height
            width: horizontalLayout ? 0.015 * parent.width : parent.width
            anchors {
                top: parent.top
                right: middlescreen.left
                rightMargin: horizontalLayout ? 0.2 * parent.width : 0.15 * parent.width
                left: parent.left
                bottom: undefined
            }    
        }
    }
    
    Keys.onEscapePressed:{ Activity.launchMenuScreen();
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = true
            Activity.launchMenuScreen()
        }
    }

    function stop() {
        if(items.mode == "expert")
            items.menuScreen.iAmReady.visible = true
        focus = false
        rootItem.visible = 0
    }
    
    function start(){
        focus = true
        rootItem.visible = 1
    }
    
    function isDragInLeftArea(leftAreaRightBorderPos,elementRightPos) {
        if(elementRightPos <= leftAreaRightBorderPos)
            return true;
        else
            return false;      
    }
    
    function isDragInRightArea(rightAreaLeftBorderPos,elementLeftPos) {
        if(elementLeftPos >= rightAreaLeftBorderPos)
            return true;
        else
            return false;  
    }
}
