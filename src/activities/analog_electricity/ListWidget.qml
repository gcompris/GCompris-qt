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
import GCompris 1.0
import "../../core"
import "analog_electricity.js" as Activity

Item {
    id: listWidget
    anchors.fill: parent
    anchors.topMargin: 5 * ApplicationInfo.ratio
    anchors.leftMargin: 5 * ApplicationInfo.ratio
    z: 10

    property bool hori
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

    property int minIconWidth: Math.min((background.width - 1.5 * view.width) / 6, 100)

    ListModel {
        id: mymodel
    }

    Grid {
        id: view
        width: inputComponentsContainer.width
        height: background.height - 2 * bar.height
        spacing: 5
        z: 20
        columns: 1

        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup: 0
        property int nbItemsByGroup: parent.height / iconSize - 2
        property int nbDisplayedGroup: Math.ceil(model.count / nbItemsByGroup)
        property int iconSize: 80 * ApplicationInfo.ratio
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
            width: listWidget.width - listWidget.anchors.leftMargin
            height: width
            sourceSize.width: width
            sourceSize.height: height
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
                width: (toolDelete.width + tools.spacing) * tools.children.length + tools.spacing * 4
                height: parent.width
                anchors.top: parent.top
                anchors.left: parent.right
                color: "#2a2a2a"
                radius: 4 * ApplicationInfo.ratio

                Flow {
                    id: tools
                    width: parent.width
                    height: parent.height

                    property int topMarginAmt: (toolsContainer.height - toolDelete.height) / 2
                    property int leftMarginAmt: (toolsContainer.width - toolDelete.width) / 2

                    anchors {
                        fill: parent
                        leftMargin: 8 * ApplicationInfo.ratio
                        topMargin: tools.topMarginAmt
                    }
                    spacing: 4 * ApplicationInfo.ratio

                    Image {
                        id: toolDelete
                        state: "notSelected"
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
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
                                    target: toolDelete
                                    opacity: 1
                                }
                            },
                            State {
                                name: "notSelected"
                                PropertyChanges {
                                    target: toolDelete
                                    opacity: 0.5
                                }
                            }
                        ]
                    }

                    Image {
                        id: info
                        source: Activity.urlDigital + "info.svg"
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
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
                                    target: info
                                    opacity: 1
                                }
                            },
                            State {
                                name: "canNotBeSelected"
                                PropertyChanges {
                                    target: info
                                    opacity: 0.5
                                }
                            }
                        ]
                    }

                    Image {
                        id: rotateLeft
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
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
                                    target: rotateLeft
                                    opacity: 1
                                }
                            },
                            State {
                                name: "canNotBeSelected"
                                PropertyChanges {
                                    target: rotateLeft
                                    opacity: 0.5
                                }
                            }
                        ]
                    }

                    Image {
                        id: rotateRight
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
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
                                PropertyChanges{
                                    target: rotateRight
                                    opacity: 1
                                }
                            },
                            State {
                                name: "canNotBeSelected"
                                PropertyChanges {
                                    target: rotateRight
                                    opacity: 0.5
                                }
                            }
                        ]
                    }

                    Image {
                        id: zoomInBtn
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
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
                                    target: zoomInBtn
                                    opacity: 1.0
                                }
                            },
                            State {
                                name: "cannotZoomIn"
                                PropertyChanges {
                                    target: zoomInBtn
                                    opacity: 0.5
                                }
                            }
                        ]
                    }

                    Image {
                        id: zoomOutBtn
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
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
                                    target: zoomOutBtn
                                    opacity: 1.0
                                }
                            },
                            State {
                                name: "cannotZoomOut"
                                PropertyChanges {
                                    target: zoomOutBtn
                                    opacity: 0.5
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
                heightInColumn: view.iconSize * 0.75
                widthInColumn: view.iconSize * 0.85
                tileWidth: view.iconSize
                tileHeight: view.iconSize * 0.85
                visible: view.currentDisplayedGroup * view.nbItemsByGroup <= index &&
                          index <= (view.currentDisplayedGroup+1) * view.nbItemsByGroup - 1

                onPressed: repeater.currentIndex = index;
            }

            clip: true
            model: mymodel

            onModelChanged: repeater.currentIndex = -1;
        }

        Row {
            spacing: view.iconSize * 0.20
            Image {
                id: previous
                opacity: (model.count > view.nbItemsByGroup &&
                          view.previousNavigation != 0 && view.currentDisplayedGroup != 0) ? 1 : 0
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.width: view.iconSize * 0.30
                fillMode: Image.PreserveAspectFit
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
                sourceSize.width: view.iconSize * 0.30
                fillMode: Image.PreserveAspectFit
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
            when: listWidget.hori
            PropertyChanges {
                target: listWidget
                minIconWidth: Math.min((background.width - 1.5 * view.width) / 6, 100)
            }
            PropertyChanges {
                target: view
                width: inputComponentsContainer.width
                height: background.height - 2 * bar.height
                columns: 1
                nbItemsByGroup: parent.height / iconSize - 2
            }
            PropertyChanges {
                target: toolButton
                width: listWidget.width - listWidget.anchors.leftMargin
            }
            PropertyChanges {
                target: toolsContainer
                width: (toolDelete.width + tools.spacing) * tools.children.length + tools.spacing * 4
                height: parent.width
            }
            AnchorChanges {
                target: toolsContainer
                anchors.top: parent.top
                anchors.left: parent.right
            }
            PropertyChanges {
                target: tools
                anchors.leftMargin: 8 * ApplicationInfo.ratio
                anchors.topMargin: tools.topMarginAmt
            }
        },
        State {
            name: "verticalList"
            when: !listWidget.hori
            PropertyChanges {
                target: listWidget
                minIconWidth: Math.min((background.height - 1.5 * bar.height - view.height) / 6, 100)
            }
            PropertyChanges {
                target: view
                width: 2 * bar.height
                height: bar.height
                columns: nbItemsByGroup + 2
                nbItemsByGroup: parent.width / iconSize - 2
            }
            PropertyChanges {
                target: toolButton
                width: listWidget.height - listWidget.anchors.leftMargin
            }
            PropertyChanges {
                target: toolsContainer
                width: parent.width
                height: (toolDelete.height + tools.spacing) * tools.children.length + tools.spacing * 4
            }
            AnchorChanges {
                target: toolsContainer
                anchors.top: parent.bottom
                anchors.left: parent.left
            }
            PropertyChanges {
                target: tools
                anchors.leftMargin: tools.leftMarginAmt
                anchors.topMargin: 8 * ApplicationInfo.ratio
            }
        }
    ]
}
