/* GCompris - MasseArea.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

import "../../core"
import "scalesboard.js" as Activity

Rectangle {
    id: masseArea
    height: itemWidth * 1.37
    color: dropArea.containsDrag ? "#33333333" : "#00000000"
    border.width: 2
    border.color: dropArea.containsDrag ? "#33666666" : "#00000000"

    property bool dropEnabled: true
    property bool dropEnabledForThisLevel: true
    property int nbColumns
    property int itemWidth: (width - masseFlow.spacing * (nbColumns - 1)) / nbColumns

    property MasseArea masseAreaCenter
    property MasseArea masseAreaLeft
    property MasseArea masseAreaRight
    property GCSoundEffect metalSound

    property alias masseModel: masseModel
    property alias dropArea: dropArea

    property int weight: 0


    function init() {
        weight = 0
        masseModel.clear()
    }

    function removeWeight(value: int) {
        weight -= value
    }

    function removeMasse(masseArea: Item, index: int, weight: int) {
        masseArea.removeWeight(weight)
        masseArea.masseModel.remove(index)
    }

    /* weight is the absolute weight
     * text is the text being displayed on the masseAreaCenter
     */
    function addMasse(img: string, weight: int, text: string, index: int, dragEnabled: bool) {
        masseModel.append( {
                              img: img,
                              weight: weight,
                              text: text,
                              masseIndex: index,
                              opacity: 1.0,
                              dragEnabled: dragEnabled
                          } )
        masseArea.weight += weight
    }

    function setAllZonesDropEnabled(enabled: bool) {
        masseAreaCenter.dropEnabled = enabled
        masseAreaLeft.dropEnabled = enabled
        masseAreaRight.dropEnabled = enabled
    }

    function showMasseInMasseArea(index: int) {
        masseAreaCenter.masseModel.get(index).opacity = 1.0
    }

    function hideMasseInMasseArea(index: int) {
        masseAreaCenter.masseModel.get(index).opacity = 0.0
    }

    ListModel {
        id: masseModel

        function contains(masseIndex: int) : bool {
            for(var i = 0; i < masseModel.count; i++) {
                if(masseModel.get(i).masseIndex == masseIndex) {
                    return masseModel.get(i).opacity == 1
                }
            }
            return false;
        }
    }

    DropArea {
        id: dropArea
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: parent.height * 2
        enabled: masseArea.dropEnabledForThisLevel && masseArea.dropEnabled
    }

    Flow {
        id: masseFlow
        anchors.fill: parent
        spacing: GCStyle.halfMargins

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: masseFlow.width * 0.05
                easing.type: Easing.InOutQuad
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                easing.type: Easing.InOutQuad
            }
        }

        Repeater {
            id: answer
            model: masseModel
            Image {
                id: answerMasseItem
                required property int index
                required property var model
                source: Activity.url + img
                sourceSize.width: masseArea.itemWidth
                opacity: model.opacity

                property string img: model.img
                property int masseIndex: model.masseIndex
                property int modelIndex: index
                property int weight: model.weight
                property string text: model.text
                property int masseOriginX
                property int masseOriginY
                property int originX
                property int originY
                property MasseArea currentMasseArea: masseArea

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width * 0.5
                Drag.hotSpot.y: height * 0.5

                function initDrag() {
                    originX = x
                    originY = y
                    if(currentMasseArea == masseArea) {
                        masseOriginX = x
                        masseOriginY = y
                    }
                    z = 111
                }

                function replace() {
                    x = originX
                    y = originY
                }

                function replaceInMasse() {
                    x = masseOriginX
                    y = masseOriginY
                }

                onOpacityChanged: opacity == 1.0 ? currentMasseArea = masseArea.masseAreaCenter : null

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    enabled: answerMasseItem.model.dragEnabled && !items.buttonsBlocked

                    onPressed: {
                        if(masseModel.contains(answerMasseItem.masseIndex)) {
                            parent.initDrag()
                        }
                        else {
                            masseArea.setAllZonesDropEnabled(false)
                        }
                    }

                    function dropOnPlate(masseArea: Item) {
                        parent.Drag.cancel()
                        if(parent.currentMasseArea == masseArea.masseAreaCenter) {
                            masseArea.hideMasseInMasseArea(parent.masseIndex)
                            parent.replaceInMasse()
                        }
                        masseArea.addMasse(parent.img,
                                           parent.weight,
                                           parent.text,
                                           parent.masseIndex,
                                           /* dragEnabled */ true)
                        if(parent.currentMasseArea != masseArea.masseAreaCenter) {
                            masseArea.removeMasse(parent.currentMasseArea,
                                                  parent.modelIndex, parent.weight)
                        }

                        parent.currentMasseArea = masseArea
                    }

                    onReleased: {
                        masseArea.setAllZonesDropEnabled(true)
                        masseArea.metalSound.play()
                        if(masseArea.masseAreaLeft.dropArea.containsDrag &&
                           parent.currentMasseArea != masseArea.masseAreaLeft) {
                            dropOnPlate(masseArea.masseAreaLeft)
                        } else if (masseArea.masseAreaRight.dropArea.containsDrag &&
                                   parent.currentMasseArea != masseArea.masseAreaRight) {
                            dropOnPlate(masseArea.masseAreaRight)
                        } else if (masseArea.masseAreaCenter.dropArea.containsDrag &&
                                   parent.dropArea != masseArea.masseAreaCenter) {
                            parent.Drag.cancel()
                            masseArea.masseAreaCenter.showMasseInMasseArea(parent.masseIndex)
                            parent.replaceInMasse()
                            if(parent.currentMasseArea != masseArea.masseAreaCenter) {
                                masseArea.removeMasse(parent.currentMasseArea,
                                                      parent.modelIndex, parent.weight)
                            }
                        } else {
                            parent.Drag.cancel()
                            parent.replace()
                        }

                    }
                }

                GCText {
                    id: text
                    anchors.fill: parent
                    anchors.topMargin: parent.height * 0.5
                    text: answerMasseItem.model.text
                    color: GCStyle.whiteText
                    fontSizeMode: Text.Fit
                    minimumPointSize: 8
                    fontSize: largeSize
                    font.bold : true
                    style: Text.Outline
                    styleColor: GCStyle.darkText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MultiEffect {
                    anchors.fill: text
                    source: text
                    shadowEnabled: true
                    shadowBlur: 1.0
                    blurMax: 16
                    shadowHorizontalOffset: 3
                    shadowVerticalOffset: 3
                    shadowOpacity: 0.5
                }
            }

        }
    }

    Behavior on y {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

}
