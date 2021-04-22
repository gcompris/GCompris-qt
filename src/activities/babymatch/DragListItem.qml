/* gcompris - DragListItem.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.6
import QtGraphicalEffects 1.0
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
            to: tileImage.moveImageX
            duration: 430
        }
        NumberAnimation {
            target: tileImage
            easing.type: Easing.OutQuad
            property: "y"
            to: tileImage.moveImageY
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
            sourceSize.width: width
            sourceSize.height: height
            width: imgSize
            height: imgSize
            x: parent.xCenter - width * 0.5
            y: parent.yCenter - height * 0.5
            fillMode: Image.PreserveAspectFit
            source: Activity.imagesUrl + imgName

            property double fullWidth: imgWidth ? imgWidth * backgroundImage.width : (backgroundImage.source == "" ?
                                           sourceImage.sourceSize.width :
                                           backgroundImage.width * sourceImage.sourceSize.width/backgroundImage.sourceSize.width)
            property double fullHeight: imgHeight ? imgHeight * backgroundImage.height : (backgroundImage.source == "" ?
                                           sourceImage.sourceSize.height :
                                           backgroundImage.height * sourceImage.sourceSize.height/backgroundImage.sourceSize.height)
            property QtObject tileImageParent
            property double moveImageX
            property double moveImageY
            property int dropStatus: -1 // -1: Nothing / 0: Bad pos / 1: Good pos
            property bool small: true
            property Item currentTargetSpot
            property bool pressedOnce
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
                var coord = tileImage.parent.mapFromItem(tile, tile.xCenter - tileImage.width * 0.5,
                            tile.yCenter - tileImage.height * 0.5);
                tileImage.moveImageX = coord.x;
                tileImage.moveImageY = coord.y;
                tileImageAnimation.start();
            }

            function toSmall() {
                width = imgSize;
                height = imgSize;
                small = true;
            }

            function toFull() {
                width = fullWidth;
                height = fullHeight;
                small = false;
            }

            MultiPointTouchArea {
                id: mouseArea
                enabled: !items.inputLocked
                touchPoints: [ TouchPoint { id: point1 } ]
                property real startX
                property real startY

                anchors.fill: parent

                onPressed: {
                    Activity.hideInstructions();
                    item.pressed();
                    tileImage.toSmall();
                    tileImage.anchors.centerIn = undefined;
                    tileImage.dropStatus = -1;
                    item.hideOkButton();
                    startX = point1.x;
                    startY = point1.y;

                    toolTip.show(toolTipText);
                    if(tileImage.parent == tile)
                        leftWidget.z = 3;
                    else
                        leftWidget.z = 1;

                    if(tileImage.currentTargetSpot) {
                        tileImage.currentTargetSpot.currentTileImageItem = null;
                        tileImage.currentTargetSpot = null;
                    }

                    if(imgSound)
                        activity.audioVoices.play(ApplicationInfo.getAudioFilePath(imgSound));
                    tileImage.pressedOnce = true;
                }

                onUpdated: {
                    var moveX = point1.x - startX;
                    var moveY = point1.y - startY;
                    parent.x = parent.x + moveX;
                    parent.y = parent.y + moveY;
                    tileImage.opacity = 1;
                    Activity.highLightSpot(getClosestSpot(), tileImage);
                }

                onReleased: {
                    if(tileImage.pressedOnce) {
                        tileImage.opacity = 1;
                        tileImage.pressedOnce = false;
                        Activity.highLightSpot(null, tileImage);
                        var closestSpot = getClosestSpot();
                        updateFoundStatus(closestSpot);
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
                            tileImage.toFull();
                            var coord = tileImage.parent.mapFromItem(backgroundImage,
                                                                     closestSpot.xCenter - tileImage.fullWidth/2,
                                                                     closestSpot.yCenter - tileImage.fullHeight/2);
                            tileImage.moveImageX = coord.x;
                            tileImage.moveImageY = coord.y;
                            tileImage.z = 100;
                            tileImageAnimation.start();
                        }
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
