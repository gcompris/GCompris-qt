/* gcompris - ListWidget.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)

 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "analog_electricity.js" as Activity

Item {
    id: listWidget
    anchors.fill: parent
    anchors.margins: GCStyle.halfMargins
    z: 10

    readonly property bool isHorizontal: width >= height
    property alias model: mymodel
    property alias view: view
    property alias repeater: repeater
    property alias toolDelete: toolDelete
    property alias rotateLeft: rotateLeft
    property alias rotateRight: rotateRight
    property alias info: info
    property alias zoomInBtn: zoomInBtn
    property alias zoomOutBtn: zoomOutBtn

    signal hideToolbar
    onHideToolbar: toolButton.showToolBar = false;

    property int toolIconWidth: 1

    ListModel {
        id: mymodel
    }

    Grid {
        id: view
        columns: listWidget.isHorizontal ? view.nbItemsByGroup + 2 : 1
        spacing: GCStyle.tinyMargins
        z: 20

        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup: 0
        property int nbItemsByGroup: listWidget.isHorizontal ?
                Math.floor(view.width / (view.iconSize + view.spacing) - 2) :
                Math.floor(view.height / (view.iconSize + view.spacing) - 2)
        property int nbDisplayedGroup: Math.ceil(model.count / nbItemsByGroup)
        property int iconSize: GCStyle.bigButtonHeight
        property int previousNavigation: 1
        property int nextNavigation: 1

        onNbDisplayedGroupChanged: {
            view.setCurrentDisplayedGroup = 0;
            refreshInputComponentsContainer();
        }

        //For setting navigation buttons
        function setNextNavigation() {
            nextNavigation = 0;
            if(currentDisplayedGroup + 1 < nbDisplayedGroup)
                nextNavigation = 1;
        }

        function setPreviousNavigation() {
            previousNavigation = 0;
            if(currentDisplayedGroup > 0)
                previousNavigation = 1;
        }

        function refreshInputComponentsContainer() {
            view.currentDisplayedGroup = view.setCurrentDisplayedGroup;
            view.setNextNavigation();
            view.setPreviousNavigation();
        }

        Image {
            id: toolButton
            width: view.iconSize
            height: view.iconSize
            sourceSize.width: view.iconSize
            sourceSize.height: view.iconSize
            source: Activity.urlDigital + "tools.svg"
            fillMode: Image.PreserveAspectFit

            property bool showToolBar: false

            MouseArea {
                anchors.fill: parent
                onClicked: toolButton.showToolBar = !toolButton.showToolBar;
            }

            Rectangle {
                id: toolsContainer
                visible: toolButton.showToolBar
                width: tools.width + GCStyle.baseMargins
                height: tools.height + GCStyle.baseMargins
                color: "#2a2a2a"
                radius: GCStyle.tinyMargins

                Flow {
                    id: tools
                    anchors.centerIn: parent
                    spacing: GCStyle.halfMargins

                    Image {
                        id: toolDelete
                        state: "notSelected"
                        width: listWidget.toolIconWidth
                        height: listWidget.toolIconWidth
                        sourceSize.width: listWidget.toolIconWidth
                        sourceSize.height: listWidget.toolIconWidth
                        source: Activity.urlDigital + "deleteOn.svg"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                toolDelete.state = (toolDelete.state == "selected") ? "notSelected" : "selected";
                                Activity.toolDelete = !Activity.toolDelete;
                            }
                        }
                        states: [
                            State {
                                name: "selected"
                                PropertyChanges {
                                    toolDelete {
                                        opacity: 1
                                    }
                                }
                            },
                            State {
                                name: "notSelected"
                                PropertyChanges {
                                    toolDelete {
                                        opacity: 0.5
                                    }
                                }
                            }
                        ]
                    }

                    Image {
                        id: info
                        source: Activity.urlDigital + "info.svg"
                        width: listWidget.toolIconWidth
                        height: listWidget.toolIconWidth
                        sourceSize.width: listWidget.toolIconWidth
                        sourceSize.height: listWidget.toolIconWidth
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!Activity.animationInProgress && parent.state === "canBeSelected") {
                                    Activity.displayInfo();
                                    hideToolbar();
                                }
                            }
                        }
                        states: [
                            State {
                                name: "canBeSelected"
                                PropertyChanges {
                                    info {
                                        opacity: 1
                                    }
                                }
                            },
                            State {
                                name: "canNotBeSelected"
                                PropertyChanges {
                                    info {
                                        opacity: 0.5
                                    }
                                }
                            }
                        ]
                    }

                    Image {
                        id: rotateLeft
                        width: listWidget.toolIconWidth
                        height: listWidget.toolIconWidth
                        sourceSize.width: listWidget.toolIconWidth
                        sourceSize.height: listWidget.toolIconWidth
                        source: Activity.urlDigital + "rotate.svg"
                        fillMode: Image.PreserveAspectFit
                        state: "CanNotBeSelected"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                    Activity.rotateLeft();
                                }
                            }
                        }
                        states: [
                            State {
                                name: "canBeSelected"
                                PropertyChanges {
                                    rotateLeft {
                                        opacity: 1
                                    }
                                }
                            },
                            State {
                                name: "canNotBeSelected"
                                PropertyChanges {
                                    rotateLeft {
                                        opacity: 0.5
                                    }
                                }
                            }
                        ]
                    }

                    Image {
                        id: rotateRight
                        width: listWidget.toolIconWidth
                        height: listWidget.toolIconWidth
                        sourceSize.width: listWidget.toolIconWidth
                        sourceSize.height: listWidget.toolIconWidth
                        source: Activity.urlDigital + "rotate.svg"
                        fillMode: Image.PreserveAspectFit
                        mirror: true
                        state: "CanNotBeSelected"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                    Activity.rotateRight();
                                }
                            }
                        }
                        states: [
                            State {
                                name: "canBeSelected"
                                PropertyChanges {
                                    rotateRight {
                                        opacity: 1
                                    }
                                }
                            },
                            State {
                                name: "canNotBeSelected"
                                PropertyChanges {
                                    rotateRight {
                                        opacity: 0.5
                                    }
                                }
                            }
                        ]
                    }

                    Image {
                        id: zoomInBtn
                        width: listWidget.toolIconWidth
                        height: listWidget.toolIconWidth
                        sourceSize.width: listWidget.toolIconWidth
                        sourceSize.height: listWidget.toolIconWidth
                        source: Activity.urlDigital + "zoomIn.svg"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Activity.zoomIn();
                        }
                        states: [
                            State {
                                name: "canZoomIn"
                                PropertyChanges {
                                    zoomInBtn {
                                        opacity: 1.0
                                    }
                                }
                            },
                            State {
                                name: "cannotZoomIn"
                                PropertyChanges {
                                    zoomInBtn {
                                        opacity: 0.5
                                    }
                                }
                            }
                        ]
                    }

                    Image {
                        id: zoomOutBtn
                        width: listWidget.toolIconWidth
                        height: listWidget.toolIconWidth
                        sourceSize.width: listWidget.toolIconWidth
                        sourceSize.height: listWidget.toolIconWidth
                        source: Activity.urlDigital + "zoomOut.svg"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Activity.zoomOut();
                        }
                        states: [
                            State {
                                name: "canZoomOut"
                                PropertyChanges {
                                    zoomOutBtn {
                                        opacity: 1.0
                                    }
                                }
                            },
                            State {
                                name: "cannotZoomOut"
                                PropertyChanges {
                                    zoomOutBtn {
                                        opacity: 0.5
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        }

        Repeater {
            id: repeater
            property int currentIndex
            width: 100
            DragListItem {
                id: contactsDelegate
                z: 1
                heightInColumn: view.iconSize * 0.85
                widthInColumn: view.iconSize * 0.85
                tileWidth: view.iconSize
                tileHeight: view.iconSize
                visible: view.currentDisplayedGroup * view.nbItemsByGroup <= index &&
                          index <= (view.currentDisplayedGroup+1) * view.nbItemsByGroup - 1

                onPressed: repeater.currentIndex = index;
            }

            clip: true
            model: mymodel

            onModelChanged: repeater.currentIndex = -1;
        }

        Item {
            width: view.iconSize
            height: view.iconSize
            Image {
                id: previous
                opacity: (model.count > view.nbItemsByGroup &&
                          view.previousNavigation != 0 && view.currentDisplayedGroup != 0) ? 1 : 0
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.height: view.iconSize * 0.85
                fillMode: Image.PreserveAspectFit
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        repeater.currentIndex = -1;
                        if(previous.opacity == 1) {
                            view.setCurrentDisplayedGroup = view.currentDisplayedGroup - view.previousNavigation;
                            view.refreshInputComponentsContainer();
                        }
                    }
                }
            }

            Image {
                id: next
                visible: model.count > view.nbItemsByGroup && view.nextNavigation != 0 && view.currentDisplayedGroup <
                         view.nbDisplayedGroup - 1
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                sourceSize.height: view.iconSize * 0.85
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        repeater.currentIndex = -1;
                        view.setCurrentDisplayedGroup = view.currentDisplayedGroup + view.nextNavigation;
                        view.refreshInputComponentsContainer();
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "horizontalList"
            when: listWidget.isHorizontal
            PropertyChanges {
                listWidget {
                    toolIconWidth: Math.min((activityBackground.height - items.toolsMargin - bar.height * 1.5) / 6 - tools.spacing, GCStyle.bigButtonHeight)
                }
                view {
                    width: listWidget.width
                    height: listWidget.height
                }
                tools {
                    width: listWidget.toolIconWidth
                    height: (listWidget.toolIconWidth + tools.spacing) * tools.children.length
                }
            }
            AnchorChanges {
                target: toolsContainer
                anchors.top: toolButton.bottom
                anchors.horizontalCenter: toolButton.horizontalCenter
                anchors.verticalCenter: undefined
                anchors.left: undefined
            }
        },
        State {
            name: "verticalList"
            when: !listWidget.isHorizontal
            PropertyChanges {
                listWidget {
                    toolIconWidth: Math.min((activityBackground.width - items.toolsMargin) / 6 - tools.spacing, GCStyle.bigButtonHeight)
                }
                view {
                    width: parent.width
                    height: parent.height - bar.height
                }
                tools {
                    width: (listWidget.toolIconWidth + tools.spacing) * tools.children.length
                    height: listWidget.toolIconWidth
                }
            }
            AnchorChanges {
                target: toolsContainer
                anchors.verticalCenter: toolButton.verticalCenter
                anchors.left: toolButton.right
                anchors.top: undefined
                anchors.horizontalCenter: undefined
            }
        }
    ]
}
