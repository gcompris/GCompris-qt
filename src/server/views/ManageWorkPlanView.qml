/* GCompris - ManageWorkPlanView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import CM 1.0
import "../components"
import "../../core"
import QtQuick.Controls 2.12
import "."

Item {

    property var dataArray: [{"color":"red"},{"color":"blue"},{"color":"yellow"}]
    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            anchors.centerIn: parent
            text: "Manage Work Plan"
        }
    }

    ListView {
        id: column1
        width: 320; height: 480
        //cellWidth: 80; cellHeight: 80


        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

    //! [0]
        model: DelegateModel {
    //! [0]
            id: visualModel
            model: ListModel {
                id: colorModel
                ListElement { color: "blue" }
                ListElement { color: "green" }
                ListElement { color: "red" }
                ListElement { color: "yellow" }
                ListElement { color: "orange" }
                ListElement { color: "purple" }
                ListElement { color: "cyan" }
                ListElement { color: "magenta" }
                ListElement { color: "chartreuse" }
                ListElement { color: "aquamarine" }
                ListElement { color: "indigo" }
                ListElement { color: "black" }
                ListElement { color: "lightsteelblue" }
                ListElement { color: "violet" }
                ListElement { color: "grey" }
                ListElement { color: "springgreen" }
                ListElement { color: "salmon" }
                ListElement { color: "blanchedalmond" }
                ListElement { color: "forestgreen" }
                ListElement { color: "pink" }
                ListElement { color: "navy" }
                ListElement { color: "goldenrod" }
                ListElement { color: "crimson" }
                ListElement { color: "teal" }
            }
    //! [1]
            delegate: DropArea {
                id: delegateRoot

                width: 80; height: 80

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Rectangle {
                    id: icon
                    property int visualIndex: 0
                    width: 72; height: 72
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    radius: 3
                    color: model.color

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: parent.visualIndex
                    }

                    DragHandler {
                        id: dragHandler
                    }

                    Drag.active: dragHandler.active
                    Drag.source: icon
                    Drag.hotSpot.x: 36
                    Drag.hotSpot.y: 36

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: root
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
    //! [1]
        }
    }

    ListView {
        id: column2
        width: 320; height: 480
        anchors.left: column1.right
        anchors.top: parent.top
        //cellWidth: 80; cellHeight: 80


        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

    //! [0]
        model: DelegateModel {
    //! [0]
            id: visualModel2
            model: ListModel {
                id: colorModel2
                ListElement { color: "blue" }
                ListElement { color: "green" }
                ListElement { color: "red" }
                ListElement { color: "yellow" }
                ListElement { color: "orange" }
                ListElement { color: "purple" }
                ListElement { color: "cyan" }
                ListElement { color: "magenta" }
                ListElement { color: "chartreuse" }
                ListElement { color: "aquamarine" }
                ListElement { color: "indigo" }
                ListElement { color: "black" }
                ListElement { color: "lightsteelblue" }
                ListElement { color: "violet" }
                ListElement { color: "grey" }
                ListElement { color: "springgreen" }
                ListElement { color: "salmon" }
                ListElement { color: "blanchedalmond" }
                ListElement { color: "forestgreen" }
                ListElement { color: "pink" }
                ListElement { color: "navy" }
                ListElement { color: "goldenrod" }
                ListElement { color: "crimson" }
                ListElement { color: "teal" }
            }
    //! [1]
            delegate: DropArea {
                id: delegateRoot2

                width: 80; height: 80

                onEntered: {
                    //visualModel2.items.move(drag.source.visualIndex, icon2.visualIndex)
                    console.log("---")
                    drag.source.color = "red"
                    drag.source.parent = delegateRoot2
                }

                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon2; property: "visualIndex"; value: visualIndex }

                Rectangle {
                    id: icon2
                    property int visualIndex: 0
                    width: 72; height: 72
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    radius: 3
                    color: model.color

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: parent.visualIndex
                    }

                    DragHandler {
                        id: dragHandler2
                    }

                    Drag.active: dragHandler2.active
                    Drag.source: icon2
                    Drag.hotSpot.x: 36
                    Drag.hotSpot.y: 36

                    states: [
                        State {
                            when: icon2.Drag.active
                            ParentChange {
                                target: icon2
                                parent: root
                            }

                            AnchorChanges {
                                target: icon2
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
    //! [1]
        }
    }

    GridView {
        width: 300; height: 200
        cellWidth: 80; cellHeight: 80
        anchors.left: column2.right
        anchors.top: parent.top

        model: dataArray

        Component {
            id: contactsDelegate
            Rectangle {
                id: wrapper
                width: 80
                height: 80
                color: dataArray[index].color
                Text {
                    id: contactInfo
                    text: "oiu"
                }
            }
        }

     /*   ListView {
            model: dataArray //the array from above
            delegate: Label {
                text: dataArray[index].name
            }
        }

      /*  model: ListModel {
            id: colorModel3
            ListElement { color: "blue" }
            ListElement { color: "green" }
            ListElement { color: "red" }
            ListElement { color: "yellow" }
            ListElement { color: "orange" }
            ListElement { color: "purple" }
            ListElement { color: "cyan" }
            ListElement { color: "magenta" }
            ListElement { color: "chartreuse" }
            ListElement { color: "aquamarine" }
            ListElement { color: "indigo" }
            ListElement { color: "black" }
            ListElement { color: "lightsteelblue" }
            ListElement { color: "violet" }
            ListElement { color: "grey" }
            ListElement { color: "springgreen" }
            ListElement { color: "salmon" }
            ListElement { color: "blanchedalmond" }
            ListElement { color: "forestgreen" }
            ListElement { color: "pink" }
            ListElement { color: "navy" }
            ListElement { color: "goldenrod" }
            ListElement { color: "crimson" }
            ListElement { color: "teal" }
        }*/
        delegate: contactsDelegate
        focus: true
    }
}
