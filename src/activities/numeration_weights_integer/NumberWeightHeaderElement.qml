
/* GCompris - NumberWeightHeaderElement.qml
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
import GCompris 1.0

import "../../core"
import "numeration_weights_integer.js" as Activity

Rectangle {
    id: numberWeightHeaderElement

    property string defaultColor: "darkred"
    property string overlapColor: "blue"

    color: "darkred"
    radius: 0.2

    anchors.top: parent.top   //?

    property int lastX
    property int lastY

    property Item dragParent

    property alias textAlias: numberWeightHeaderCaption.text

    border.color: "red"
    border.width: 0

    DropArea {
        id: numberWeightsHeaderDropArea

        anchors.fill: parent
        keys: "numberWeightHeaderKey"

        onEntered: {
            numberWeightHeaderElement.color = overlapColor
        }

        onExited: {
            numberWeightHeaderElement.color = defaultColor
        }

        onDropped: {
            numberWeightHeaderElement.color = defaultColor
            numberWeightHeaderCaption.text = drag.source.caption
        }

        Image {
            id: numberWeightHeaderImage

            anchors.fill: parent
            sourceSize.width: parent.width //?
            sourceSize.height: parent.height

            GCText {
                id: numberClassElementCaption

                anchors.fill: parent
                anchors.bottom: parent.bottom
                fontSizeMode: Text.Fit
                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    GCText {
        id: numberWeightHeaderCaption

        anchors.fill: parent
        anchors.margins: 10  //find a way to fit the text without truncating it
        fontSizeMode: Text.Fit
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: TextEdit.WordWrap
        text: qsTr("Drag column weight here.")
    }

    MouseArea {
         anchors.fill: parent
         onClicked: {
             if (numberWeightHeaderImage.status === Image.Ready) {
                Activity.removeNumberWeightComponent(numberWeightImageTile)
             }
             else {
                if (Activity.selectedNumberWeightDragElementIndex !== -1) {
                    if (numberWeightDragListModel.get(Activity.selectedNumberWeightDragElementIndex).dragkeys === "numberWeightHeaderKey") {
                        numberWeightHeaderImage.source = numberWeightDragListModel.get(Activity.selectedNumberWeightDragElementIndex).imageName
                        numberWeightHeaderCaption.text = numberWeightDragListModel.get(Activity.selectedNumberWeightDragElementIndex).caption
                    }
                }
            }
         }
    }
}
