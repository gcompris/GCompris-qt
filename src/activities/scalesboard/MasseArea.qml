/* GCompris - MasseArea.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtGraphicalEffects 1.0

import "../../core"
import "scalesboard.js" as Activity

Rectangle {
    id: masseArea
    height: itemHeight
    color: dropArea.containsDrag ? "#33333333" : "#00000000"
    border.width: 2
    border.color: dropArea.containsDrag ? "#33666666" : "#00000000"

    property bool dropEnabled: true
    property bool dropEnabledForThisLevel: true
    property int nbColumns
    property int itemWidth: (width - masseFlow.spacing * nbColumns) / nbColumns
    property int itemHeight: itemWidth * 1.2

    property Item masseAreaCenter
    property Item masseAreaLeft
    property Item masseAreaRight

    property alias masseModel: masseModel
    property alias dropArea: dropArea

    property int weight: 0

    property GCSfx audioEffects

    function init() {
        weight = 0
        masseModel.clear()
    }

    function removeWeight(value) {
        weight -= value
    }

    function removeMasse(masseArea, index, weight) {
        masseArea.removeWeight(weight)
        masseArea.masseModel.remove(index)
    }

    /* weight is the absolute weight
     * text is the text being displayed on the masseAreaCenter
     */
    function addMasse(img, weight, text, index, dragEnabled) {
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

    function setAllZonesDropEnabled(enabled) {
        masseAreaCenter.dropEnabled = enabled
        masseAreaLeft.dropEnabled = enabled
        masseAreaRight.dropEnabled = enabled
    }

    function showMasseInMasseArea(index) {
        masseAreaCenter.masseModel.get(index).opacity = 1.0
    }

    function hideMasseInMasseArea(index) {
        masseAreaCenter.masseModel.get(index).opacity = 0.0
    }

    ListModel {
        id: masseModel

        function contains(masseIndex) {
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
        enabled: dropEnabledForThisLevel && dropEnabled
    }
    
    Flow {
        id: masseFlow
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        anchors.fill: parent
        spacing: 10
        flow: Flow.TopToBottom

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: parent.width * 0.05
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
                source: Activity.url + img
                sourceSize.height: masseArea.itemHeight
                height: masseArea.itemHeight
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
                property Item currentMasseArea: masseArea

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

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

                onOpacityChanged: opacity == 1.0 ? currentMasseArea = masseAreaCenter : null

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    enabled: model.dragEnabled

                    onPressed: {
                        if(masseModel.contains(parent.masseIndex)) {
                            parent.initDrag()
                        }
                        else {
                            setAllZonesDropEnabled(false)
                        }
                    }

                    function dropOnPlate(masseArea) {
                        parent.Drag.cancel()
                        if(parent.currentMasseArea == masseAreaCenter) {
                            masseArea.hideMasseInMasseArea(parent.masseIndex)
                            parent.replaceInMasse()
                        }
                        masseArea.addMasse(parent.img,
                                           parent.weight,
                                           parent.text,
                                           parent.masseIndex,
                                           /* dragEnabled */ true)
                        if(parent.currentMasseArea != masseAreaCenter) {
                            removeMasse(parent.currentMasseArea,
                                        parent.modelIndex, parent.weight)
                        }

                        parent.currentMasseArea = masseArea
                    }

                    onReleased: {
                        setAllZonesDropEnabled(true)
                        if(masseArea.audioEffects)
                            masseArea.audioEffects.play(Activity.url + 'metal_hit.wav')
                        if(masseAreaLeft.dropArea.containsDrag &&
                           parent.currentMasseArea != masseAreaLeft) {
                            dropOnPlate(masseAreaLeft)
                        } else if (masseAreaRight.dropArea.containsDrag &&
                                   parent.currentMasseArea != masseAreaRight) {
                            dropOnPlate(masseAreaRight)
                        } else if (masseAreaCenter.dropArea.containsDrag &&
                                   parent.dropArea != masseAreaCenter) {
                            parent.Drag.cancel()
                            masseAreaCenter.showMasseInMasseArea(parent.masseIndex)
                            parent.replaceInMasse()
                            if(parent.currentMasseArea != masseAreaCenter) {
                                removeMasse(parent.currentMasseArea,
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
                    text: model.text.replace(" ", "\n")
                    color: "white"
                    fontSizeMode: Text.Fit
                    minimumPointSize: 10
                    fontSize: largeSize
                    font.bold : true
                    style: Text.Outline
                    styleColor: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                DropShadow {
                    anchors.fill: text
                    cached: false
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 8.0
                    samples: 16
                    color: "#80000000"
                    source: text
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
