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
import core 1.0

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
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg" 

        signal start
        signal stop

        property bool verticalBar: activityBackground.width >= activityBackground.height

        Component.onCompleted: {
            dialogActivityConfig.initialize();
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias backgroundPiecesModel: backgroundPiecesModel
            property alias grid: grid
            property alias backgroundImageSource: backgroundImageSource
            property alias backgroundImage: backgroundImage
            property alias leftWidget: leftWidget
            property alias instructionPanel: instructionPanel
            property alias toolTip: toolTip
            property alias score: score
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
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
                activityBackground.start();
            }
        }

        Score {
            id: score
            visible: numberOfSubLevels > 1
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.baseMargins
            anchors.bottom: bar.top
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel);
        }

        Image {
            id: leftWidget
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW02.svg"
            width: activityBackground.verticalBar ?
                       90 * ApplicationInfo.ratio :
                       activityBackground.width
            height: activityBackground.verticalBar ?
                        activityBackground.height :
                        90 * ApplicationInfo.ratio
            anchors.left: parent.left
            ListWidget {
                id: availablePieces
            }
            MouseArea {
                anchors.fill: parent
                enabled: !items.inputLocked
                onPressed: instructionPanel.opacity === 0 ? instructionPanel.show() : instructionPanel.hide();
            }
        }

        Rectangle {
            id: toolTip
            anchors {
                bottom: bar.top
                left: leftWidget.left
                margins: GCStyle.halfMargins
            }
            width: toolTipTxt.contentWidth + GCStyle.baseMargins
            height: toolTipTxt.contentHeight + GCStyle.tinyMargins
            opacity: 1
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.blueBorder
            z: 100
            color: GCStyle.paperWhite
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText: string) {
                if(newText) {
                    text = newText;
                    opacity = 0.8;
                } else {
                    opacity = 0;
                }
            }

            GCText {
                id: toolTipTxt
                anchors.centerIn: parent
                fontSize: regularSize
                color: GCStyle.darkText
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        Item {
            id: grid
            z: 2
            x: activityBackground.verticalBar ? 90 * ApplicationInfo.ratio : 0
            y: activityBackground.verticalBar ? 0 : 90 * ApplicationInfo.ratio
            width: activityBackground.verticalBar ?
                       activityBackground.width - 90 * ApplicationInfo.ratio : activityBackground.width
            height: activityBackground.verticalBar ?
                        activityBackground.height - (bar.height * 1.1) :
                        activityBackground.height - (bar.height * 1.1) - 90 * ApplicationInfo.ratio

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
                    onPressed: instructionPanel.opacity === 0 ? instructionPanel.show() : instructionPanel.hide();
                }
            }
        }

        GCTextPanel {
            id: instructionPanel
            z: 10
            panelWidth: grid.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, grid.height * 0.2)
            fixedHeight: false
            anchors {
                top: activityBackground.verticalBar ? grid.top : leftWidget.bottom
                topMargin: GCStyle.baseMargins
                horizontalCenter: activityBackground.verticalBar ? grid.horizontalCenter : leftWidget.horizontalCenter
            }
            color: GCStyle.paperWhite
            border.color: GCStyle.blueBorder
            border.width: GCStyle.thinBorder
            textItem.color: GCStyle.darkText

            Behavior on opacity { NumberAnimation { duration: 100 } }

            function show() {
                if(textItem.text)
                    opacity = 1;
            }
            function hide() {
                opacity = 0;
            }
        }

        ListModel {
            id: backgroundPiecesModel
        }

        Item {
            id: movePlaceholder
            z: 1000
            anchors.fill: activityBackground
        }
    }
}
