/* gcompris - CardItem.qml
 *
 * Copyright (C) 2014 JB BUTET
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
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
import QtMultimedia 5.0
import "memory.js" as Activity
import GCompris 1.0
import "qrc:/gcompris/src/core"

Item {
    id: item
    property Item main
    property Item bar
    property string audioSrc
    property string backPict
    property string imagePath
    property string matchCode
    property bool isBack: true
    property bool isFound: false
    property string audioFile
    property string textDisplayed
    property string imageSource
    property alias rotAngle: image.rotAngle
    property bool transitionFacedFinished
    property bool transitionReturnedFinished

    property bool transitionHiddenFinished


    onIsFoundChanged: {
        timer.start()
    }


    Timer { id:timer
            interval: 500; running: false; repeat: false
            onTriggered: particles.emitter.burst(50)
        }

    onRotAngleChanged:  {
        if (rotAngle < 90) {
                image.source = backPict
            } else {
                image.source = imagePath
            }
    }

    ParticleSystemStar {
        id: particles
        anchors.fill: parent
        clip: false
    }
    Timer {id:animationTimer
             interval: 750; running: false; repeat: false
             onTriggered: theresAClick()
         }
    Image {
        id: image
        width:item.width
        height: item.height
        fillMode: Image.PreserveAspectFit
        source : backPict
        property real rotAngle: rotation.angle //in degrees
        signal clicked()
        transform: [
            Scale {
                    id: scaleTransform
                    origin.x: item.width/2; origin.y: item.height/2
                    xScale: mouseArea.containsMouse ? 1.05 : 1  // <-
                    Behavior on xScale {  // for animation
                        NumberAnimation { duration: 200 }
                    }
            },
            Rotation {
                        id: rotation
                        origin.x: item.width/2
                        origin.y: item.height/2
                        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                        angle: 0    // the default angle
                        Behavior on angle {  // for animation
                                            NumberAnimation { duration: 1000 }
                                        }

            }
        ]
    }

    MouseArea {
        id:mouseArea
        anchors.fill: parent
        enabled: item.isBack

    }


    function doWithClick(){
        Activity.reverseCards()
        isBack = false
        item.state = "faced"
        animationTimer.start()
    }

    function theresAClick(){

        Activity.cardClicked(item)
        if (Activity.type == "sound"){
            sound1.source = "qrc:/gcompris/src/activities/memory-sound/resource/"+ audioFile
            sound1.play()
        }
    }

    Component.onCompleted: {
        mouseArea.onClicked.connect(doWithClick)
    }

    Text {
           id:text1
           anchors.centerIn: parent
           visible : rotAngle>Math.PI/2 ? true : false
           font.family: "Helvetica"
           font.pointSize: {Activity.column==5 ? 14 : 36/(Math.floor(Activity.column/3)+1)}/*,correction < 10 ? 10 : correction} *///awful hack to set a good font size
           horizontalAlignment: Text.AlignHCenter
           verticalAlignment: Text.AlignVCenter
           color: "black"
           property real rotAngle : image.rotAngle/180*Math.PI
           text: textDisplayed
           x: image.x + image.width/2 - image.width*Math.cos(rotAngle) * 0.5
           transform: [
               Scale {
                    yScale: 1
                    origin.x: 0; origin.y: 0
                    xScale: Math.abs(Math.cos(text1.rotAngle))
               }
           ]
       }

    states : [
        State {
          name: "hidden"; when: isFound == true
          PropertyChanges { target: item; imageSource:item.imagePath; opacity:0 }
          PropertyChanges { target: rotation; angle: 180 }
        },
        State {
            name:"back"; when: isBack == true
            PropertyChanges { target: item; imageSource:item.backPict }
            PropertyChanges { target: rotation; angle: 0 }

        },
        State {
            name:"faced"; when: isBack==false
            PropertyChanges { target: item; imageSource:item.imagePath }
            PropertyChanges { target: rotation; angle: 180 }
        }
    ]

    transitions: [
        Transition {
            from: "faced"; to: "hidden"; reversible: false
            SequentialAnimation {
                id : hiddenAnimation
                PauseAnimation { duration: 500 }
                PropertyAction{
                                    target:item; property:"transitionHiddenFinished"; value: "false"
                                }
                PropertyAnimation {
                    duration: 1000;
                    target: item;
                    property: "opacity";
                    to: 0
                }
                PropertyAction{
                                    target:item; property:"transitionHiddenFinished"; value: "true"
                                }
            }
        },
        Transition {
            from: "faced"; to : "back" ;reversible: false
            SequentialAnimation {
                id:returnedAnimation

                PropertyAction{
                                    target:item; property:"transitionReturnedFinished"; value: "false"
                                }
                PropertyAnimation {

                    duration: 300;
                    target: item;
                    property: "imageSource";
                    from: item.imagePath;
                    to: item.backPict;

            }
                PropertyAction{
                                    target:item; property:"transitionReturnedFinished"; value: "true"
                                }
        }
        },
        Transition {
            from: "back"; to : "faced" ;reversible: false

            SequentialAnimation {
                id:facedAnimation

                PropertyAction{
                                    target:item; property:"transitionFacedFinished"; value: "false"
                                }
                PropertyAnimation {

                    duration: 300;
                    target: item;
                    property: "imageSource";
                    from: item.backPict
                    to: item.imagePath;

                }
                PropertyAction{
                                    target:item; property:"transitionFacedFinished"; value: "true"
                                }

            }
        }
    ]
}


