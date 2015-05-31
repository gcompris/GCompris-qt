/* GCompris - Babymatch.qml
 *
 * Copyright (C) 2015 Pulkit Gupta
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
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "babymatch.js" as Activity

ActivityBase {
    id: activity

    property string url: "qrc:/gcompris/src/activities/babymatch/resource/"
    property int levelCount: 7
    property int subLevelCount: 0
    property bool answerGlow: true	//For highlighting the answers
    property bool displayDropCircle: true	//For displaying drop circles

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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias backgroundPiecesModel: backgroundPiecesModel
            property alias file: file
            property alias grid: grid
            property alias backgroundImage: backgroundImage
            property alias leftWidget: leftWidget
            property alias showLeftWidget: showLeftWidget
            property alias hideLeftWidget: hideLeftWidget
            property alias leftBar: leftBar
            property alias instruction: instruction
            property alias toolTip: toolTip
            property alias score: score
            property alias dataset: dataset
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items, url, levelCount, subLevelCount, answerGlow, displayDropCircle) }
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

        PropertyAnimation {
            id: showLeftWidget
            target: leftWidget
            properties: "width"
            from: 0
            to: leftWidget.leftWidgetWidth
            duration: 300
            onStarted: {
                //activity.audioEffects.stop()
                //activity.audioEffects.play("qrc:/gcompris/src/activities/babymatch/resource/sound/slideOut.wav")
            }
        }
        PropertyAnimation {
            id: hideLeftWidget
            target: leftWidget
            properties: "width"
            from: leftWidget.leftWidgetWidth
            to: 0
            duration: 300
            onStarted: {
                //activity.audioEffects.stop()
                //activity.audioEffects.play("qrc:/gcompris/src/activities/babymatch/resource/sound/slideIn.wav")
            }
            onStopped: {
                availablePieces.view.currentDisplayedGroup = availablePieces.view.setCurrentDisplayedGroup
                availablePieces.view.setNextNavigation()
                availablePieces.view.setPreviousNavigation()
                showLeftWidget.start()
            }
        }

        Rectangle {
            id: leftContainer
            width: leftWidget.leftWidgetWidth + leftBar.width
            height: background.height
            color: "transparent"
            anchors.left: parent.left
            z: 1
            
            Rectangle {
                id: leftBar
                width: leftWidget.leftWidgetWidth/10
                height: background.height - 5 * ApplicationInfo.ratio
                radius: 10
                color: "#666"
                anchors.left: leftWidget.right
                anchors.verticalCenter: parent.verticalCenter
                border.width: 2
                border.color: "black"
            }
            
            Rectangle {
                id: leftWidget
                property double leftWidgetWidth: Math.min((availablePieces.view.height/availablePieces.view.nbItemsByGroup) 
												 - (1.5*availablePieces.view.spacing), (background.width/5) - 
												 availablePieces.view.spacing) + 10 * ApplicationInfo.ratio
                width: leftWidgetWidth
                height: background.height
                color: "#FFFF42"
                border.color: "#FFD85F" 
                border.width: 4
                anchors.left: parent.left
                ListWidget {
                    id: availablePieces
                }
            }
        }
        
        Rectangle {
            id: toolTip
            anchors.top: toolTipTxt.top
            anchors.horizontalCenter: toolTipTxt.horizontalCenter
            width: toolTipTxt.width + 10
            height: toolTipTxt.height + 5
            visible: false
            opacity: 0.8
            radius: 10
            z: 100
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            property alias text: toolTipTxt.text
        }
        
        GCText {
            id: toolTipTxt
            anchors {
                bottom: bar.top
                bottomMargin: 10
                left: leftContainer.left//horizontalCenter
                leftMargin: 5
            }
            visible: toolTip.visible
            z: 101
            fontSize: regularSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: TextEdit.WordWrap
        }
        
        Rectangle {
            id: grid

            color: "transparent"
            z: 2
            y: 10
            anchors.left: leftContainer.right
            width: background.width - leftContainer.width
            height: background.height - (bar.height * 1.1)
            
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
							source: Activity.url + imgName
							x: posX * backgroundImage.width - width / 2
							y: posY * backgroundImage.height - height / 2
							
							height: imgHeight ? imgHeight * backgroundImage.height : (backgroundImage.source == "" ? 
									backgroundImage.height * shapeBackground.sourceSize.height/backgroundImage.height : 
									backgroundImage.height * shapeBackground.sourceSize.height/
									backgroundImage.sourceSize.height)
									
							width: imgWidth ? imgWidth * backgroundImage.width : (backgroundImage.source == "" ? 
								   backgroundImage.width * shapeBackground.sourceSize.width/backgroundImage.width : 
								   backgroundImage.width * shapeBackground.sourceSize.width/backgroundImage.sourceSize.width)
							
							fillMode: Image.PreserveAspectFit
						}
					}
				}

                MouseArea {
                    anchors.fill: parent
                    onClicked: (instruction.opacity === 0 ?
                                instruction.opacity = 1 : instruction.opacity = 0)
                }
            }
            
           Rectangle {
				id: instruction
				anchors.fill: instructionTxt
                opacity: 0.8
                radius: 10
                z: 3
                border.width: 2
                border.color: "black"
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
                property alias text: instructionTxt.text

                Behavior on opacity { PropertyAnimation { duration: 200 } }
           }
            
            GCText {
                id: instructionTxt
                anchors {
                    top: grid.top
                    topMargin: -10
                    horizontalCenter: grid.horizontalCenter
                }
                opacity: instruction.opacity
                z: instruction.z
                fontSize: regularSize
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                width: Math.max(Math.min(parent.width * 0.9, text.length * 11), parent.width * 0.3)
                wrapMode: TextEdit.WordWrap
            }
            
        }
        
        ListModel {
            id: backgroundPiecesModel
        }
    }
}
