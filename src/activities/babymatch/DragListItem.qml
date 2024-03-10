/* gcompris - DragListItem.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import Qt5Compat.GraphicalEffects 1.0
import GCompris 1.0
import "babymatch.js" as Activity

Item {
    id: item

    width: tile.width
    height: tile.height

    property string source: imgName
    property double tileSize
    property int imgSize: Math.round(tileSize * 0.9)
    property QtObject answer: tileImage.parent
    property bool selected: false
    property alias dropStatus: tileImage.dropStatus

    signal pressed

    ParallelAnimation {
        id: tileImageAnimation
        NumberAnimation {
            target: tileImage
            easing.type: Easing.OutQuad
            property: "x"
            to: tileImage.targetImageX
            duration: 430
        }
        NumberAnimation {
            target: tileImage
            easing.type: Easing.OutQuad
            property: "y"
            to: tileImage.targetImageY
            duration: 430
        }
        NumberAnimation {
            target: tileImage
            easing.type: Easing.OutQuad
            property: "width"
            to: tileImage.targetImageWidth
            duration: 430
        }
        NumberAnimation {
            target: tileImage
            easing.type: Easing.OutQuad
            property: "height"
            to: tileImage.targetImageHeight
            duration: 430
        }
        onStarted: {
            tileImage.anchors.centerIn = undefined;
            view.showGlow = false;
        }
        onStopped: {
            tileImage.parent = tileImage.tileImageParent;
            if(tileImage.currentTargetSpot == null) {
                tileImage.centerInTile();
            } else {
                tileImage.anchors.centerIn = tileImage.currentTargetSpot;
            }
            updateOkButton();
        }
    }

    Rectangle {
        id: tile
        width: tileSize
        height: tileSize
        color: (parent.selected && tileImage.parent == tile) ? "#33FF294D" : "transparent"
        border.color: (parent.selected && tileImage.parent == tile) ? "white" : "transparent"
        border.width: 3
        radius: 2

        property double xCenter: tile.x + tile.width * 0.5
        property double yCenter: tile.y + tile.height * 0.5

        Image {
            id: sourceImage
            visible: false
            source: Activity.imagesUrl + imgName
        }

        Image {
            id: tileImage
            sourceSize.width: imgSize
            sourceSize.height: imgSize
            width: imgSize
            height: imgSize
            x: parent.xCenter - width * 0.5
            y: parent.yCenter - height * 0.5
            fillMode: Image.PreserveAspectFit
            source: Activity.imagesUrl + imgName

            property double fullWidth: imgWidth ? imgWidth * backgroundImage.width : (backgroundImage.source == "" ?
                                           sourceImage.sourceSize.width :
                                           backgroundImage.width * sourceImage.sourceSize.width/backgroundImageSource.sourceSize.width)
            property double fullHeight: imgHeight ? imgHeight * backgroundImage.height : (backgroundImage.source == "" ?
                                           sourceImage.sourceSize.height :
                                           backgroundImage.height * sourceImage.sourceSize.height/backgroundImageSource.sourceSize.height)
            property QtObject tileImageParent
            // Animated properties
            property double targetImageX
            property double targetImageY
            property double targetImageWidth
            property double targetImageHeight

            property int dropStatus: -1 // -1: Nothing / 0: Bad pos / 1: Good pos
            property bool small: true
            property Item currentTargetSpot
            property bool dropEnabled: false
            property bool parentIsTile : parent == tile ? true : false

            onFullWidthChanged: correctDroppedImageSize();
            onFullHeightChanged: correctDroppedImageSize();

            function correctDroppedImageSize() {
                if(tileImage.dropStatus == 0 || tileImage.dropStatus == 1) {
                    tileImage.width = tileImage.fullWidth;
                    tileImage.height = tileImage.fullHeight;
                }
            }

            function centerInTile() {
                x = tile.xCenter - tileImage.width * 0.5;
                y = tile.yCenter - tileImage.height * 0.5;
            }

            function imageRemove() {
                dropStatus = -1;
                if(backgroundImage.source == "")
                    leftWidget.z = 1;

                tileImage.currentTargetSpot = null;
                tileImage.tileImageParent = tile;
                toSmall();
                // destCoord needs to be calculated with the final size of the tile -> targetImageWidth/targetImageHeight
                var destCoord = tileImage.parent.mapFromItem(tile, tile.xCenter - tileImage.targetImageWidth * 0.5,
                            tile.yCenter - tileImage.targetImageHeight * 0.5);
                tileImage.targetImageX = destCoord.x;
                tileImage.targetImageY = destCoord.y;
                tileImageAnimation.start();
            }

            function toSmall() {
                targetImageWidth = imgSize;
                targetImageHeight = imgSize;
                sourceSize.width = imgSize;
                sourceSize.height = imgSize;
                small = true;
            }

            function toFull() {
                targetImageWidth = fullWidth;
                targetImageHeight = fullHeight;
                sourceSize.width = fullWidth;
                sourceSize.height = fullHeight;
                small = false;
            }

            MouseArea {
                enabled: !items.inputLocked
                drag.target: parent
                property real startX
                property real startY

                anchors.centerIn: parent
                // the MouseArea size of dropped items is never smaller than the dropCircles
                width: Math.max(parent.width, items.minimumClickArea)
                height: Math.max(parent.height, items.minimumClickArea)

                onPressed: {
                    Activity.hideInstructions();
                    item.pressed();
                    tileImage.anchors.centerIn = undefined;
                    tileImage.dropStatus = -1;
                    item.hideOkButton();
                    startX = mouseX;
                    startY = mouseY;
                    toolTip.show(toolTipText);
                    if(tileImage.parent == tile)
                        leftWidget.z = 3;
                    else {
                        leftWidget.z = 1;
                    }

                    if(tileImage.currentTargetSpot) {
                        var coords = movePlaceholder.mapFromItem(backgroundImage, tileImage.currentTargetSpot.xCenter, tileImage.currentTargetSpot.yCenter);
                        tileImage.parent = movePlaceholder;
                        tileImage.x = coords.x - tileImage.width * 0.5;
                        tileImage.y = coords.y - tileImage.height * 0.5;
                        tileImage.currentTargetSpot.currentTileImageItem = null;
                        tileImage.currentTargetSpot = null;
                    }
                    if(imgSound)
                        activity.audioVoices.play(ApplicationInfo.getAudioFilePath(imgSound));
                }

                onPositionChanged: {
                    tileImage.opacity = 0.5;
                    if((background.verticalBar && tileImage.x > leftWidget.width) || (!background.verticalBar && tileImage.y > leftWidget.height)) {
                        tileImage.dropEnabled = true;
                        Activity.highLightSpot(getClosestSpot(), tileImage);
                    } else {
                        tileImage.dropEnabled = false;
                        Activity.clearHighLightSpots();
                    }
                }

                onReleased: {
                    tileImage.opacity = 1;
                    Activity.highLightSpot(null, tileImage);
                    var closestSpot = null;
                    if(tileImage.dropEnabled) {
                        closestSpot = getClosestSpot();
                        updateFoundStatus(closestSpot);
                        tileImage.dropEnabled = false;
                    }
                    if(closestSpot === null) {
                        if(tileImage.currentTargetSpot)
                            tileImage.currentTargetSpot.imageRemove();
                        else
                            tileImage.imageRemove();
                    } else {
                        if(tileImage.currentTargetSpot !== closestSpot) {
                            closestSpot.imageRemove();
                            closestSpot.imageAdd(tileImage);
                        }
                        tileImage.currentTargetSpot = closestSpot;
                        tileImage.tileImageParent = backgroundImage;
                        var originCoords = tileImage.parent.mapToItem(backgroundImage, tileImage.x, tileImage.y);
                        tileImage.parent = tileImage.tileImageParent;
                        tileImage.x = originCoords.x;
                        tileImage.y = originCoords.y;
                        tileImage.toFull();
                        var destCoord = tileImage.parent.mapFromItem(backgroundImage,
                                                                     closestSpot.xCenter - tileImage.fullWidth/2,
                                                                     closestSpot.yCenter - tileImage.fullHeight/2);
                        tileImage.targetImageX = destCoord.x;
                        tileImage.targetImageY = destCoord.y;
                        tileImage.z = 100;
                        tileImageAnimation.start();
                    }
                }

                function getClosestSpot() {
                    var coordImg = tileImage.parent.mapToItem(backgroundImage,
                                                              tileImage.x + tileImage.width/2,
                                                              tileImage.y + tileImage.height/2);
                    return Activity.getClosestSpot(coordImg.x, coordImg.y);
                }

                function updateFoundStatus(closestSpot) {
                    if(!closestSpot) {
                        tileImage.dropStatus = -1;
                        return;
                    }
                    if(closestSpot.imgName === imgName)
                           tileImage.dropStatus = 1;
                    else
                        tileImage.dropStatus = 0;
                }
            }

            Image {
                id: wrongAnswer
                anchors.centerIn: parent
                height: imgSize * 0.3
                width: imgSize * 0.3
                fillMode: Image.PreserveAspectFit
                z: 10
                source:"qrc:/gcompris/src/activities/babymatch/resource/error.svg"
                visible: view.showGlow && tileImage.dropStatus === 0
            }

        }

        Glow {
            id: tileImageGlow
            parent: tileImage.parent
            anchors.fill: tileImage
            radius: 8
            samples: 17
            color: view.showGlow && Activity.glowEnabled ?
                       (tileImage.dropStatus === 0 ? "red" : "white") :
                       'transparent'
            source: tileImage
            opacity: tileImage.opacity
        }
    }

    function hideOkButton() {
        if(view.okShowed) {
            hideOk.start();
            view.okShowed = false;
            view.showGlow = false;
        }
    }

    function updateOkButton() {
        if(view.areAllPlaced()) {
            showOk.start();
        }
        if(!view.okShowed && tileImage.dropStatus >= 0)
            view.checkDisplayedGroup();
        if(!view.okShowed && tileImage.dropStatus == -1) {
            view.displayedGroup[parseInt(index/view.nbItemsByGroup)] = true;
            view.setPreviousNavigation();
            view.setNextNavigation();
            view.checkDisplayedGroup();
        }
    }
}
