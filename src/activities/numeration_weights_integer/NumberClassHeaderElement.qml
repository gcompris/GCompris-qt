 
/* GCompris - NumberClassHeaderElement.qml
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


Item {
    id: numberClassHeaderElement

    MouseArea {
        id: dragArea

        property bool held: false

        width: mainZoneArea.width / numberClassListModel.count
        height: numberClassHeaders.height

        drag.target: held ? content : undefined
        drag.axis: Drag.XAxis

        onPressAndHold: {
            held = true
        }
        onReleased: {
            if ((content.x < leftWidget.width) && held)  //don't understand why I have a content.x = 0 when held is not true, this point needs to be cleared
            {
                numberClassListModel.get(index).element_src.dragEnabled = true
                numberClassListModel.remove(index,1)
            }
            held = false
        }


        Rectangle {
            id: content

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            width: mainZoneArea.width / numberClassListModel.count
            height: numberClassHeaders.height / 2
            border.width: 1
            border.color: "lightsteelblue"
            color: dragArea.held ? "lightsteelblue" : "white"
            Behavior on color { ColorAnimation { duration: 100 } }
            radius: 2
            Drag.active: dragArea.held
            Drag.source: dragArea
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            states: State {
                when: dragArea.held

                ParentChange { target: content; parent: root }
                AnchorChanges {
                    target: content
                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                }
            }

            GCText {
                id: numberClassHeaderCaption

                anchors.fill: parent
                anchors.bottom: parent.bottom
                fontSizeMode: Text.Fit
                color: "black"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: index     //numberClassListModel.get(index).name //?
                z: 100
            }

        }

        DropArea {
            anchors { fill: parent; margins: 10 }

            onEntered: {

                console.log("entered")
                visualModel.items.move(
                        drag.source.DelegateModel.itemsIndex,
                        dragArea.DelegateModel.itemsIndex)
                        console.log("drag.source.DelegateModel.itemsIndex : " + drag.source.DelegateModel.itemsIndex)
                        console.log("dragArea.DelegateModel.itemsIndex : " + dragArea.DelegateModel.itemsIndex)
                numberClassListModel.move(
                            drag.source.DelegateModel.itemsIndex,
                            dragArea.DelegateModel.itemsIndex,1)
            }
        }
    }
}

