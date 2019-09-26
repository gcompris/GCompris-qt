/* GCompris - NumberClassDropArea.qml
 *
 * Copyright (C) 2019 Emmanuel Charruau <echarruau@gmail.com>
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
import GCompris 1.0 //?
import QtQuick.Layouts 1.3

import "../../core"
import "numeration_weights_integer.js" as Activity

Rectangle {
    id: numberClassDropArea

    property string className
    property var unitColumnWeightImagesArray: ["","","","","","","","",""]   //?
    property int unitColumnWeightImagesArrayIndex: 0
    property var tenColumnWeightImagesArray: ["","","","","","","","",""]
    property int tenColumnWeightImagesArrayIndex: 0
    property var hundredColumnWeightImagesArray: ["","","","","","","","",""]
    property int hundredColumnWeightImagesArrayIndex: 0
    property string numberClassDropAreaIndex: index

    property string defaultColor: "darkseagreen"
    property string overlapColor: "grey"

    property alias numberWeightsDropAreasRepeaterAlias: numberWeightsDropAreasRepeater

    width: parent.width
    height: parent.height - numberClassHeaders.height

    color: "blue"

    ListModel {
            id: numberWeightHeadersModel

            ListElement {
                weightType: "Hundred"
            }
            ListElement {
                weightType: "Ten"
            }
            ListElement {
                weightType: "Unit"
            }
        }

    RowLayout {
        id: numberWeightsDropAreasRowLayout

        width: parent.width
        height: parent.height
        spacing: 10

        Repeater {
            id: numberWeightsDropAreasRepeater
            model: numberWeightHeadersModel


            Rectangle {
                id: numberWeightDropAreaRectangle

                property string numberWeightDropAreaRectangleIndex: index
                property string numberWeightKey: weightType
                property alias numberWeightsDropTiles: numberWeightsDropTiles
                property alias numberWeightHeaderElement: numberWeightHeaderElement
                property string numberWeightType: weightType

                color: "lightsteelblue"

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 50
                Layout.preferredWidth: 100

                NumberWeightHeaderElement {
                    id: numberWeightHeaderElement

                    x: 0
                    y: 0
                    width: numberWeightDropAreaRectangle.width
                    height: numberWeightDropAreaRectangle.height /10
                }

                // Implement columns where the numberWeights are set by the user
                Rectangle {
                    id: numberWeightsDropTiles

                    property alias numberWeightDropAreaGridRepeater: numberWeightDropAreaGridRepeater

                    anchors.top: numberWeightHeaderElement.bottom
                    width: parent.width
                    height: parent.height - numberWeightHeaderElement.height

                    Grid {
                        id: numberWeightDropAreaGrid

                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom;
                        width: parent.width
                        height: parent.height
                        columns: 1

                        Repeater {
                            id: numberWeightDropAreaGridRepeater
                            model: 9

                            DropArea {
                                property alias numberWeightImageTile: numberWeightImageTile
                                property alias numberWeightComponentRectangle: numberWeightComponentRectangle

                                keys: "numberWeightKey"

                                width: parent.width
                                height: parent.height/9

                                onEntered: {
                                    numberWeightComponentRectangle.color = overlapColor
                                }

                                onExited: {
                                    numberWeightComponentRectangle.color = defaultColor
                                }

                                onDropped: {
                                    var imageName = drag.source.imageName
                                    var caption = drag.source.caption
                                    var weightValue = drag.source.weightValue
                                    Activity.setNumberWeightComponent(numberWeightImageTile,imageName,caption, weightValue)
                                    numberWeightComponentRectangle.color = defaultColor
                                }

                                Rectangle {
                                    id: numberWeightComponentRectangle

                                    border.color: "black"
                                    border.width: 5
                                    radius: 10
                                    width: parent.width
                                    height: parent.height
                                    color: defaultColor

                                    Image {
                                        id: numberWeightImageTile

                                        property string caption: ""
                                        property string weightValue: ""
                                        property alias border: numberWeightComponentRectangle.border

                                        anchors.fill: parent
                                        sourceSize.width: parent.width
                                        sourceSize.height: parent.height

                                        MouseArea {
                                             anchors.fill: parent
                                             onClicked: {
                                                 if (numberWeightImageTile.status === Image.Ready) {
                                                    Activity.removeNumberWeightComponent(numberWeightImageTile)
                                                 }
                                                 else {
                                                    if (Activity.selectedNumberWeightDragElementIndex !== -1) {
                                                         var imageName = numberWeightDragListModel.get(Activity.selectedNumberWeightDragElementIndex).imageName
                                                         var caption = numberWeightDragListModel.get(Activity.selectedNumberWeightDragElementIndex).caption
                                                         var weightValue = numberWeightDragListModel.get(Activity.selectedNumberWeightDragElementIndex).weightValue
                                                         Activity.setNumberWeightComponent(numberWeightImageTile,imageName,caption,weightValue)
                                                    }
                                                }
                                             }
                                        }

                                        GCText {
                                            id: numberClassElementCaption

                                            anchors.fill: parent
                                            anchors.bottom: parent.bottom
                                            fontSizeMode: Text.Fit
                                            color: "white"
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            text: numberWeightImageTile.caption
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
