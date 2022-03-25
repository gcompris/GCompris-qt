/* gcompris - ListWidget.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "digital_electricity.js" as Activity

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
    onHideToolbar: toolButton.showToolBar = false

    property int minIconWidth: listWidget.hori ? Math.min((background.width - 1.5*view.width) / 6, 100) : Math.min((background.height - 1.5*bar.height - view.height) / 6, 100)

    ListModel {
        id: mymodel
    }

    Grid {
        id: view
        width: listWidget.hori ? inputComponentsContainer.width : 2 * bar.height
        height: listWidget.hori ? background.height - 2 * bar.height : bar.height
        spacing: 5
        z: 20
        columns: listWidget.hori ? 1 : nbItemsByGroup + 2

        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup: 0
        property int nbItemsByGroup:
            listWidget.hori ?
                parent.height / iconSize - 2 :
                parent.width / iconSize - 2

        property int nbDisplayedGroup: Math.ceil(model.count / nbItemsByGroup)
        property int iconSize: 80 * ApplicationInfo.ratio
        property int previousNavigation: 1
        property int nextNavigation: 1

        onNbDisplayedGroupChanged: {
            view.setCurrentDisplayedGroup = 0
            refreshInputComponentsContainer()
        }

        //For setting navigation buttons
        function setNextNavigation() {
            nextNavigation = 0
            if(currentDisplayedGroup + 1 < nbDisplayedGroup)
                nextNavigation = 1
        }

        function setPreviousNavigation() {
            previousNavigation = 0
            if(currentDisplayedGroup > 0)
                previousNavigation = 1
        }

        function refreshInputComponentsContainer() {
            availablePieces.view.currentDisplayedGroup = availablePieces.view.setCurrentDisplayedGroup
            availablePieces.view.setNextNavigation()
            availablePieces.view.setPreviousNavigation()
        }

        Image {
            id: toolButton
            width: (listWidget.hori ? listWidget.width : listWidget.height) - listWidget.anchors.leftMargin
            height: width
            sourceSize.width: width
            sourceSize.height: height
            source: Activity.url + "tools.svg"
            fillMode: Image.PreserveAspectFit

            property bool showToolBar: false

            MouseArea {
                anchors.fill: parent
                onClicked: toolButton.showToolBar = !toolButton.showToolBar
            }

            Rectangle {
                id: toolsContainer
                visible: toolButton.showToolBar
                width: listWidget.hori ? (toolDelete.width + tools.spacing) * tools.children.length + tools.spacing * 4 : parent.width
                height: listWidget.hori ? parent.width : (toolDelete.height + tools.spacing) * tools.children.length + tools.spacing * 4
                anchors.top: listWidget.hori ? parent.top : parent.bottom
                anchors.left: listWidget.hori ? parent.right : parent.left
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
                        leftMargin: listWidget.hori ? 8 * ApplicationInfo.ratio : tools.leftMarginAmt
                        topMargin: listWidget.hori ? tools.topMarginAmt : 8 * ApplicationInfo.ratio
                    }
                    spacing: 4 * ApplicationInfo.ratio

                    Image {
                        id: toolDelete
                        state: "notSelected"
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        source: Activity.url + "deleteOn.svg"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                toolDelete.state = (toolDelete.state == "selected") ? "notSelected" : "selected"
                                Activity.toolDelete = !Activity.toolDelete
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
                        source: Activity.url + "info.svg"
                        width: minIconWidth
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                    Activity.displayInfo()
                                    hideToolbar()
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
                        source: Activity.url + "rotate.svg"
                        fillMode: Image.PreserveAspectFit
                        state: "CanNotBeSelected"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                    Activity.rotateLeft()
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
                        source: Activity.url + "rotate.svg"
                        fillMode: Image.PreserveAspectFit
                        mirror: true
                        state: "CanNotBeSelected"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                    Activity.rotateRight()
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
                        source: Activity.url + "zoomIn.svg"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Activity.zoomIn()
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
                        source: Activity.url + "zoomOut.svg"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Activity.zoomOut()
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
                         index <= (view.currentDisplayedGroup+1) * view.nbItemsByGroup-1

                onPressed: repeater.currentIndex = index
            }

            clip: true
            model: mymodel

            onModelChanged: repeater.currentIndex = -1
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
                        repeater.currentIndex = -1
                        if(previous.opacity == 1) {
                            view.setCurrentDisplayedGroup = view.currentDisplayedGroup - view.previousNavigation
                            view.refreshInputComponentsContainer()
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
                        repeater.currentIndex = -1
                        view.setCurrentDisplayedGroup = view.currentDisplayedGroup + view.nextNavigation
                        view.refreshInputComponentsContainer()
                    }
                }
            }
        }
    }
}
