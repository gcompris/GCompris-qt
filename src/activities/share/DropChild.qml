/* GCompris - DropChild.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu29@gmail.com> (initial version)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

Rectangle {
    id: dropChild
    z: 5
    color: "#40ffffff"
    radius: GCStyle.halfMargins

    readonly property int subSizeUnit: width / 3
    property string name
    property alias childImage: childImage
    property alias area: area
    property int indexS: index
    property alias candyCount: candyCount

    Image {
        id: childImage
        width: dropChild.subSizeUnit
        height: dropChild.subSizeUnit - GCStyle.halfMargins
        sourceSize.height: height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: GCStyle.halfMargins
        anchors.leftMargin: GCStyle.baseMargins
        source: "resource/images/" + name + ".svg"
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    //displays the number of candies each child has
    GCText {
        id: candyCount
        color: GCStyle.darkText
        width: dropChild.subSizeUnit
        height: dropChild.subSizeUnit
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: GCStyle.baseMargins
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit

        //"listModel.get(index) ? ... " because of an error received at startup of each level
        text: (listModel.get(index)) ? listModel.get(index).countS : ""
    }

    Rectangle {
        width: area.width
        height: GCStyle.baseMargins
        anchors.top: area.top
        color: GCStyle.lightBg
    }

    Rectangle {
        id: area
        width: dropChild.subSizeUnit * 3
        height: dropChild.subSizeUnit * 2
        anchors.bottom: parent.bottom
        radius: GCStyle.halfMargins
        color: GCStyle.lightBg

        property var childCoordinate: repeaterDropAreas.mapToItem(activityBackground, dropChild.x, dropChild.y)
        property var candyCoord: candyWidget.mapToItem(activityBackground, candyWidget.element.x, candyWidget.element.y)

        opacity: candyCoord.x > childCoordinate.x &&
                 candyCoord.y > childCoordinate.y + childImage.height &&
                 candyCoord.x < childCoordinate.x + childCoordinate.width &&
                 candyCoord.y < childCoordinate.y + childCoordinate.height ? 0.5 : 1

        MouseArea {
            anchors.fill: parent
            enabled: !items.buttonsBlocked

            onClicked: {
                if (items.acceptCandy) {
                    // Easy mode
                    if (activityBackground.easyMode) {
                        if (activityBackground.currentCandies < items.candyWidget.total) {
                            if (listModel.get(index).countS + 1 <= items.maxNumberOfCandiesPerWidget) {
                                //add candies in the first rectangle
                                repeaterDropAreas.itemAt(index).candyCount.text = listModel.get(index).countS + 1
                                listModel.setProperty(index, "countS", listModel.get(index).countS + 1)
                                //the current number of candies increases
                                activityBackground.currentCandies ++
                                //on the last one, the candy image from top goes away (destroy)
                                if (activityBackground.currentCandies === items.candyWidget.total) {
                                    activityBackground.resetCandy()
                                    candyWidget.element.opacity = 0.6
                                }
                            }
                            else {
                                activityBackground.wrongMove.visible = true
                            }
                        }
                        else {
                            activityBackground.resetCandy()
                            candyWidget.element.opacity = 0.6
                        }
                    }
                    // Hard mode
                    else {
                        if (activityBackground.currentCandies < items.candyWidget.total) {
                            if (listModel.get(index).countS + 1 <= items.maxNumberOfCandiesPerWidget) {
                                //add candies in the first rectangle
                                repeaterDropAreas.itemAt(index).candyCount.text = listModel.get(index).countS + 1
                                listModel.setProperty(index, "countS", listModel.get(index).countS + 1)
                                //the current number of candies increases
                                activityBackground.currentCandies ++
                                if (activityBackground.currentCandies === items.candyWidget.total) {
                                    activityBackground.resetCandy()
                                    candyWidget.element.opacity = 0.6
                                }
                            }
                            else {
                                activityBackground.wrongMove.visible = true
                            }
                        }
                    }
                }
            }
        }

        Flow {
            id: candyDropArea
            spacing: GCStyle.halfMargins
            width: parent.width
            height: parent.height
            y: GCStyle.halfMargins * 0.5

            Repeater {
                id: repeaterCandyDropArea
                model: countS

                Image {
                    id: candyArea
                    width: dropChild.subSizeUnit - GCStyle.halfMargins
                    height: dropChild.subSizeUnit - GCStyle.halfMargins
                    sourceSize.height: height
                    source: "resource/images/candy.svg"
                    fillMode: Image.PreserveAspectFit

                    property int lastX
                    property int lastY

                    MouseArea {
                        anchors.fill: parent

                        //enables dragging the candy after placed
                        drag.target: parent
                        enabled: !items.buttonsBlocked

                        onPressed: {
                            instructionPanel.hide()
                            //set the initial position
                            candyArea.lastX = candyArea.x
                            candyArea.lastY = candyArea.y
                            //move this rectangle/grid on top of everything
                            dropChild.z++
                        }

                        function childContainsCandy(currentChild, candy) {
                            //coordinates of "boy/girl rectangle" in background coordinates
                            var child = dropAreas.mapToItem(items.activityBackground, currentChild.x, currentChild.y)
                            return (candy.x > child.x &&
                                candy.x < child.x + currentChild.width &&
                                candy.y > child.y &&
                                candy.y < child.y + currentChild.height)
                        }

                        onReleased: {
                            //move this rectangle/grid to its previous state
                            dropChild.z--

                            var candyCoordinate = candyArea.mapToItem(activityBackground, 0, 0)

                            //check where the candy is being dropped
                            for (var i = 0 ; i < listModel.count ; i++) {
                                var currentChild = repeaterDropAreas.itemAt(i)

                                if (currentChild !== dropChild) {
                                    //check if the user wants to put a candy to another rectangle
                                    if (childContainsCandy(currentChild, candyCoordinate)) {
                                        // don't drop more than the maximum of allowed candies per widget
                                        if(listModel.get(currentChild.indexS).countS >= items.maxNumberOfCandiesPerWidget) {
                                            activityBackground.wrongMove.visible = true
                                            break;
                                        }

                                        //add the candy to the i-th rectangle
                                        repeaterDropAreas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                                        //remove the candy from current rectangle
                                        repeaterDropAreas.itemAt(rect2.indexS).candyCount.text = listModel.get(rect2.indexS).countS - 1
                                        listModel.setProperty(rect2.indexS, "countS", listModel.get(rect2.indexS).countS - 1);
                                        break;
                                    }
                                }
                            }

                            //restore the candy to its initial position
                            candyArea.x = candyArea.lastX
                            candyArea.y = candyArea.lastY
                        }

                        //when clicked, it will restore the candy
                        onClicked: {
                            repeaterDropAreas.itemAt(rect2.indexS).candyCount.text = listModel.get(rect2.indexS).countS - 1
                            activityBackground.currentCandies--
                            candyWidget.element.opacity = 1
                            items.candyWidget.canDrag = true
                            listModel.setProperty(rect2.indexS, "countS", listModel.get(rect2.indexS).countS - 1);
                        }
                    }
                }
            }
        }
    }
}
