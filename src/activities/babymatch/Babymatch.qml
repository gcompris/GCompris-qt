/* GCompris - Babymatch.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "babymatch.js" as Activity

ActivityBase {
    id: activity

    // In most cases, these 3 are the same.
    // But for imageName for example, we reuse the images of babymatch, so we need to differentiate them
    property string imagesUrl: boardsUrl
    property string soundsUrl: boardsUrl
    property string boardsUrl: "qrc:/gcompris/src/activities/babymatch/resource/"
    property int levelCount: 7
    property bool answerGlow: true	//For highlighting the answers
    property bool displayDropCircle: true	//For displaying drop circles

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg" 

        signal start
        signal stop

        property bool vert: background.width > background.height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias backgroundPiecesModel: backgroundPiecesModel
            property alias file: file
            property alias grid: grid
            property alias backgroundImage: backgroundImage
            property alias leftWidget: leftWidget
            property alias instruction: instruction
            property alias toolTip: toolTip
            property alias score: score
            property alias dataset: dataset
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items, imagesUrl, soundsUrl, boardsUrl, levelCount, answerGlow, displayDropCircle) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {displayDialog(dialogHelp)}
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }
        
        Score {
            id: score
            visible: numberOfSubLevels > 1
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        File {
            id: file
            name: ""
        }

        Image {
            id: leftWidget
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW02.svg"
            width: background.vert ?
                       90 * ApplicationInfo.ratio :
                       background.width
            height: background.vert ?
                        background.height :
                        90 * ApplicationInfo.ratio
            anchors.left: parent.left
            ListWidget {
                id: availablePieces
                vert: background.vert
            }
            MouseArea {
                anchors.fill: parent
                onPressed: (instruction.opacity == 0 ?
                                instruction.show() : instruction.hide())
            }
        }

        Rectangle {
            id: toolTip
            anchors {
                bottom: bar.top
                bottomMargin: 10
                left: leftWidget.left
                leftMargin: 5
            }
            width: toolTipTxt.width + 10
            height: toolTipTxt.height + 5
            opacity: 1
            radius: 10
            z: 100
            color: "#E8E8E8"
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText) {
                if(newText) {
                    text = newText
                    opacity = 0.8
                } else {
                    opacity = 0
                }
            }
            
            Rectangle {
                width: parent.width - anchors.margins
                height: parent.height - anchors.margins
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: parent.height/8
                radius: 10
                color: "#87A6DD"  //light blue
            }
        
            Rectangle {
                width: parent.width - anchors.margins
                height: parent.height - anchors.margins
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: parent.height/4
                radius: 10
                color: "#E8E8E8" //paper white
            }
            
            GCText {
                id: toolTipTxt
                anchors.centerIn: parent
                fontSize: regularSize
                color: "#373737"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }
        
        
        Rectangle {
            id: grid

            color: "transparent"
            z: 2
            x: background.vert ? 90 * ApplicationInfo.ratio : 0
            y: background.vert ? 0 : 90 * ApplicationInfo.ratio
            width: background.vert ?
                       background.width - 90 * ApplicationInfo.ratio : background.width
            height: background.vert ?
                        background.height - (bar.height * 1.1) :
                        background.height - (bar.height * 1.1) - 90 * ApplicationInfo.ratio
            
            Image {
                id: backgroundImage
                fillMode: Image.PreserveAspectFit
                property double ratio: sourceSize.width / sourceSize.height
                property double gridRatio: grid.width / grid.height
                property alias instruction: instruction
                source: ""
                z: 2
                width: source == "" ? grid.width : (ratio > gridRatio ? grid.width : grid.height * ratio)
                height: source == "" ? grid.height : (ratio < gridRatio ? grid.height : grid.width / ratio)
                anchors.topMargin: 10
                anchors.centerIn: parent
                
                //Inserting static background images
                Repeater {
                    id: backgroundPieces
                    model: backgroundPiecesModel
                    delegate: piecesDelegate
                    z: 2

                    Component {
                        id: piecesDelegate
                        Image {
                            id: shapeBackground
                            source: Activity.imagesUrl + imgName
                            x: posX * backgroundImage.width - width / 2
                            y: posY * backgroundImage.height - height / 2

                            height:
                                imgHeight ?
                                    imgHeight * backgroundImage.height :
                                    (backgroundImage.source == "" ?
                                         backgroundImage.height * shapeBackground.sourceSize.height / backgroundImage.height :
                                         backgroundImage.height * shapeBackground.sourceSize.height /
                                         backgroundImage.sourceSize.height)

                            width:
                                imgWidth ?
                                    imgWidth * backgroundImage.width :
                                    (backgroundImage.source == "" ?
                                         backgroundImage.width * shapeBackground.sourceSize.width / backgroundImage.width :
                                         backgroundImage.width * shapeBackground.sourceSize.width /
                                         backgroundImage.sourceSize.width)

                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: (instruction.opacity == 0 ?
                                    instruction.show() : instruction.hide())
                }
            }
        }
        
        Rectangle {
            id: instruction
            anchors.horizontalCenter: instructionTxt.horizontalCenter
            anchors.verticalCenter: instructionTxt.verticalCenter
            width: instructionTxt.width + 40
            height: instructionTxt.height + 40
            opacity: 0.8
            radius: 10
            z: 3
            color: "#87A6DD"  //light blue
            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            function show() {
                if(text)
                    opacity = 1
            }
            function hide() {
                opacity = 0
            }
            
            Rectangle {
                id: insideFill
                width: parent.width - anchors.margins
                height: parent.height - anchors.margins
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: parent.height/8
                radius: 10
                color: "#E8E8E8" //paper white
            }
        }

        GCText {
            id: instructionTxt
            anchors {
                top: background.vert ? grid.top : leftWidget.bottom
                topMargin: -10
                horizontalCenter: background.vert ? grid.horizontalCenter : leftWidget.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: regularSize
            color: "#373737"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.9, text.length * 11), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }

        
        ListModel {
            id: backgroundPiecesModel
        }
    }
}
