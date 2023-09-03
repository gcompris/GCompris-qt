/* GCompris - Babymatch.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "babymatch.js" as Activity

ActivityBase {
    id: activity

    // In most cases, these 3 are the same.
    // But for imageName for example, we reuse the images of babymatch, so we need to differentiate them
    property string imagesUrl: boardsUrl
    property string soundsUrl: boardsUrl
    property bool useMultipleDataset: false
    property string boardsUrl: "qrc:/gcompris/src/activities/babymatch/resource/"
    property int levelCount: 7
    property bool answerGlow: true	//For highlighting the answers
    property bool displayDropCircle: true	//For displaying drop circles

    onStart: focus = true;
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg" 

        signal start
        signal stop

        property bool verticalBar: background.width >= background.height

        Component.onCompleted: {
            dialogActivityConfig.initialize();
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias backgroundPiecesModel: backgroundPiecesModel
            property alias file: file
            property alias grid: grid
            property alias backgroundImageSource: backgroundImageSource
            property alias backgroundImage: backgroundImage
            property alias leftWidget: leftWidget
            property alias instruction: instruction
            property alias toolTip: toolTip
            property alias score: score
            readonly property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
            property alias dataset: dataset
            property bool inputLocked: false
            // same formula used to define dropCircle size, here to define a minimum MouseArea
            // size for dropped items if they are smaller than the circles.
            property double minimumClickArea: backgroundImage.width >= backgroundImage.height ? backgroundImage.height/35 : backgroundImage.width/35
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items, imagesUrl, soundsUrl, boardsUrl, levelCount, answerGlow, displayDropCircle, useMultipleDataset); }
        onStop: { Activity.stop(); }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: useMultipleDataset ? (help | home | level | activityConfig) : (help | home | level) }
            onHelpClicked: displayDialog(dialogHelp);
            onPreviousLevelClicked: Activity.previousLevel();
            onNextLevelClicked: Activity.nextLevel();
            onHomeClicked: {
                Activity.resetData();
                activity.home();
            }
            onActivityConfigClicked: {
                Activity.initLevel();
                displayDialog(dialogActivityConfig);
             }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels;
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels;
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels);
                activity.focus = true;
            }
            onLoadData: {
                if(activityData) {
                    Activity.initLevel();
                }
            }
            onClose: {
                home();
            }
            onStartActivity: {
                background.start();
            }
        }

        Score {
            id: score
            visible: numberOfSubLevels > 1
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: bar.top
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel);
        }

        File {
            id: file
            name: ""
        }

        Image {
            id: leftWidget
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW02.svg"
            width: background.verticalBar ?
                       90 * ApplicationInfo.ratio :
                       background.width
            height: background.verticalBar ?
                        background.height :
                        90 * ApplicationInfo.ratio
            anchors.left: parent.left
            ListWidget {
                id: availablePieces
            }
            MouseArea {
                anchors.fill: parent
                enabled: !items.inputLocked
                onPressed: instruction.opacity === 0 ? instruction.show() : instruction.hide();
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
                    text = newText;
                    opacity = 0.8;
                } else {
                    opacity = 0;
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
            x: background.verticalBar ? 90 * ApplicationInfo.ratio : 0
            y: background.verticalBar ? 0 : 90 * ApplicationInfo.ratio
            width: background.verticalBar ?
                       background.width - 90 * ApplicationInfo.ratio : background.width
            height: background.verticalBar ?
                        background.height - (bar.height * 1.1) :
                        background.height - (bar.height * 1.1) - 90 * ApplicationInfo.ratio

            // We need two items for the background image:
            // - backgroundImageSource is needed to keep the original sourceSize info which is used
            // in calculations, and to load quickly the image on startup;
            // - backgroundImage is used for the "clean" render of the image,
            // with its sourceSize linked to the actual size to get perfect svg rendering,
            // but as it can be slow on heavy maps we load this one asynchronously.
            Image {
                id: backgroundImageSource
                source: ""
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                property double ratio: sourceSize.width / sourceSize.height
                property double gridRatio: grid.width / grid.height
                // shrink size by 2 pixels to make sure it is always perfectly hidden by backgroundImage
                width: (source == "" ? grid.width :
                        (ratio > gridRatio ? grid.width : grid.height * ratio)) - 2
                height: (source == "" ? grid.height :
                        (ratio < gridRatio ? grid.height : grid.width / ratio)) - 2
            }

            Image {
                id: backgroundImage
                fillMode: Image.PreserveAspectFit
                source: backgroundImageSource.source
                z: 2
                width: backgroundImageSource.width + 2
                height: backgroundImageSource.height + 2
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
                asynchronous: true

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
                                         backgroundImage.height * sourceShape.sourceSize.height / backgroundImage.height :
                                         backgroundImage.height * sourceShape.sourceSize.height /
                                         backgroundImageSource.sourceSize.height)

                            width:
                                imgWidth ?
                                    imgWidth * backgroundImage.width :
                                    (backgroundImage.source == "" ?
                                         backgroundImage.width * sourceShape.sourceSize.width / backgroundImage.width :
                                         backgroundImage.width * sourceShape.sourceSize.width /
                                         backgroundImageSource.sourceSize.width)

                            sourceSize.width: width
                            sourceSize.height: height
                            fillMode: Image.PreserveAspectFit
                            Image {
                                id: sourceShape
                                anchors.centerIn: parent
                                source: Activity.imagesUrl + imgName
                                visible: false
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !items.inputLocked
                    onPressed: instruction.opacity === 0 ? instruction.show() : instruction.hide();
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
                    opacity = 1;
            }
            function hide() {
                opacity = 0;
            }

            Rectangle {
                id: insideFill
                width: parent.width - anchors.margins
                height: parent.height - anchors.margins
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: parent.height / 8
                radius: 10
                color: "#E8E8E8" //paper white
            }
        }

        GCText {
            id: instructionTxt
            anchors {
                top: background.verticalBar ? grid.top : leftWidget.bottom
                topMargin:  20
                horizontalCenter: background.verticalBar ? grid.horizontalCenter : leftWidget.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: regularSize
            color: "#373737"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.7, text.length * 10), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }


        ListModel {
            id: backgroundPiecesModel
        }

        Item {
            id: movePlaceholder
            z: 1000
            anchors.fill: background
        }
    }
}
