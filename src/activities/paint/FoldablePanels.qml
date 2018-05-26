/* GCompris - FoldablePanels.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "paint.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: root
    width: background.width
    height: background.height * 0.08
    color: "#add8e6"
    anchors.top: background.top
    anchors.horizontalCenter: background.horizontalCenter
    property bool collapsePanels: true

    ListView {
        id: tools
        width: root.width
        interactive: false
        anchors.top: root.top
        model: nestedModel
        anchors.right: root.right
        orientation: ListView.Horizontal
        //spacing: 10
        delegate: categoryDelegate
    }

    ListModel {
        id: nestedModel
        ListElement {
            categoryName: "Menu"
            collapsed: true

            // A ListElement can't contain child elements, but it can contain
            // a list of elements. A list of ListElements can be used as a model
            // just like any other model type.
            subItems: [
                ListElement { itemName: qsTr("Save") },
                ListElement { itemName: qsTr("Load") },
                ListElement { itemName: qsTr("Undo") },
                ListElement { itemName: qsTr("Redo") },
                ListElement { itemName: qsTr("Erase all") },
                ListElement { itemName: qsTr("Background color") },
                ListElement { itemName: qsTr("Export to PNG") }
            ]
        }

        ListElement {
            categoryName: "Tools"
            collapsed: true
            subItems: [
                ListElement { itemName: qsTr("Pencil") },
                ListElement { itemName: qsTr("Geometric") },
                ListElement { itemName: qsTr("Text") },
                ListElement { itemName: qsTr("Brush") },
                ListElement { itemName: qsTr("Line") },
                ListElement { itemName: qsTr("Eraser") },
                ListElement { itemName: qsTr("Bucket fill") }
            ]
        }

        ListElement {
            categoryName: "Color"
            collapsed: true
            subItems: [
                ListElement { itemName: qsTr("Red") },
                ListElement { itemName: qsTr("Green") },
                ListElement { itemName: qsTr("Yellow") },
                ListElement { itemName: qsTr("Orange") },
                ListElement { itemName: qsTr("Blue") },
                ListElement { itemName: qsTr("More Colors") }
            ]
        }

        ListElement {
            categoryName: "Tool Options"
            collapsed: true
            subItems: [
                ListElement { itemName: qsTr("Modes") },
                ListElement { itemName: qsTr("Size") },
                ListElement { itemName: qsTr("More to be added") }
            ]
        }
    }

    Component {
        id: categoryDelegate
        Column {
            width: root.width * 0.22
            Rectangle {
                id: categoryItem
                border.color: "black"
                border.width: 5
                radius: 50
                color: "white"
                height: 50
                width: root.width / 5

                GCText {
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.centerIn: parent
                    //x: 15
                    font.pixelSize: 24
                    text: categoryName
                }
                MouseArea {
                    anchors.fill: parent

                    // Toggle the 'collapsed' property
                    onClicked: {
                        nestedModel.setProperty(index, "collapsed", !collapsed)
                        root.collapsePanels = !root.collapsePanels
                        console.log("Clicked on " + categoryName)
                    }
                }
            }

            Loader {
                id: subItemLoader

                // This is a workaround for a bug/feature in the Loader element. If sourceComponent is set to null
                // the Loader element retains the same height it had when sourceComponent was set. Setting visible
                // to false makes the parent Column treat it as if it's height was 0.
                visible: !collapsed
                property var subItemModel: subItems
                sourceComponent: collapsed ? null : subItemColumnDelegate
                onStatusChanged: if (status == Loader.Ready) item.model = subItemModel
            }
        }
    }

    Component {
        id: subItemColumnDelegate
        Column {
            property alias model : subItemRepeater.model
            width: 200
            Repeater {
                id: subItemRepeater
                delegate: Rectangle {
                    color: "#cccccc"
                    height: 40
                    width: 200
                    border.color: "black"
                    border.width: 2

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 30
                        font.pixelSize: 18
                        text: itemName
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Activity.selectTool(itemName)
                        }
                    }
                }
            }
        }
    }
}
