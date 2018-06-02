import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "paint.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: root
    property int tabWidth: background.width * 0.15
    property int tabHeight: background.height * 0.06
    property alias colorModel: colorModel

    function hideAllTabs() {
        menuTitle.visible = false
        toolsTitle.visible = false
        colorsTitle.visible = false
        toolsOptionTitle.visible = false
        //menuGrid.visible = false
        //colorGrid.visible = false
    }

    function showAllTabs() {
        menuTitle.visible = true
        toolsTitle.visible = true
        colorsTitle.visible = true
        toolsOptionTitle.visible = true
    }

    ListModel {
        id: menuModel
        ListElement { itemName: qsTr("Save")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/filesaveas.svg" }
        ListElement { itemName: qsTr("Load")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/fileopen.svg" }
        ListElement { itemName: qsTr("Undo")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/undo.svg" }
        ListElement { itemName: qsTr("Redo")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/redo.svg" }
        ListElement { itemName: qsTr("Erase all")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/empty.svg" }
        ListElement { itemName: qsTr("Background color")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/color_wheel.svg" }
        ListElement { itemName: qsTr("Export to PNG")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/empty.svg" }
    }

    ListModel {
        id: toolsModel
        ListElement { itemName: qsTr("Pencil")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/pen.svg" }
        ListElement { itemName: qsTr("Geometric")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/empty.svg" }
        ListElement { itemName: qsTr("Text")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/empty.svg" }
        ListElement { itemName: qsTr("Brush")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/brush_paint.png" }
        ListElement { itemName: qsTr("Eraser")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/erase.svg" }
        ListElement { itemName: qsTr("Bucket fill")
            imgSource: "qrc:/gcompris/src/activities/paint/resource/fill.svg" }
    }

    ListModel {
        id: colorModel
        ListElement {colorCode: "#ff0000"} ListElement {colorCode: "#00ff00"} ListElement {colorCode: "#0000ff"}
        ListElement {colorCode: "#ffff00"} ListElement {colorCode: "#00ffff"} ListElement {colorCode: "#ff00ff"}
        ListElement {colorCode: "#800000"} ListElement {colorCode: "#000080"} ListElement {colorCode: "#ff4500"}
        ListElement {colorCode: "#A0A0A0"} ListElement {colorCode: "#d2691e"} ListElement {colorCode: "#8b008b"}
    }

    ListModel {
        id: toolsOptionModels
        ListElement { itemName: qsTr("Modes") }
        ListElement { itemName: qsTr("Size") }
        ListElement { itemName: qsTr("More to be added") }
    }

    Rectangle {
        id: menuPanel
        anchors.leftMargin: 5
        width: background.width
        height: background.height / 2.4
        color: "#1A1A1A"
        y: -height
        //border.color: "white"

        property bool panelUnFolded: y >= -5
        //property alias

        NumberAnimation {
            id: foldAnimation
            target: menuPanel
            property: "y"
            to: - menuPanel.height
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            id: unfoldAnimation
            target: menuPanel
            property: "y"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }

        GridView {
            id: menuGrid
            width: parent.width * 0.75
            height: parent.height * 0.80
            anchors.centerIn: parent
            visible: false
            anchors.topMargin: 30
            cellWidth: width / 4
            cellHeight: height / 2.2
            model: menuModel
            delegate:Item {
                Image {
                    id: img
                    source: imgSource
                    sourceSize.width: menuGrid.cellWidth * 0.60
                    sourceSize.height: menuGrid.cellHeight * 0.60

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.scale = 1.1
                        onExited: parent.scale = 1.0
                        onClicked: {
                            console.log(itemName)
                            Activity.selectTool(itemName)
                            foldAnimation.start()
                        }
                    }
                }
                GCText {
                    text: itemName
                    anchors.horizontalCenter: img.horizontalCenter
                    anchors.top: img.bottom
                    fontSize: tinySize
                    color: "white"
                }
            }
        }

        GridView {
            id: colorGrid
            width: parent.width * 0.75
            height: parent.height * 0.80
            anchors.centerIn: parent
            anchors.topMargin: 10
            cellWidth: width / 4.7
            cellHeight: height / 3.6
            model: colorModel
            z: 1800
            delegate: Rectangle {
                id: root1
                radius: 8
                width: colorGrid.cellWidth * 0.80
                height: colorGrid.cellHeight * 0.90
                color: modelData
                border.width: 3
                border.color: modelData

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        parent.border.color = "grey"
                        root1.scale = 1.1
                    }
                    onExited: {
                        parent.border.color = modelData
                        root1.scale = 1
                    }

                    // choose other color:
                    onDoubleClicked: {
                        items.activeColorIndex = index
                        colorDialog.visible = true
                    }

                    // set this color as current paint color
                    onClicked: {
                        items.activeColorIndex = index
                        items.paintColor = root1.color
                        background.hideExpandedTools()
                        items.paintColor = color
                        background.reloadSelectedPen()
                        colorPalette.visible = false
                        foldAnimation.start()
                        root.showAllTabs()
                    }
                }

                Rectangle {
                    width: parent.width * 0.30
                    height: parent.height * 0.30
                    anchors.top: parent.top
                    anchors.right: parent.right
                    color: "transparent"

                    Image {
                        source: Activity.url + "color_wheel.svg"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            items.activeColorIndex = index
                            colorDialog.visible = true
                            console.log("Clicked on color picker!")
                        }
                    }
                }
            }
        }

        Rectangle {
            id: menuTitle
            width: root.tabWidth
            height: root.tabHeight
            radius: 10
            color: "#1A1A1A"
            border.color: "white"
            anchors.top: parent.bottom
            anchors.topMargin: -8
            z: parent.z - 1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorGrid.visible = false
                    menuGrid.visible = true
                    if(menuPanel.panelUnFolded) {
                        foldAnimation.start()
                        root.showAllTabs()
                    }
                    else {
                        root.hideAllTabs()
                        menuGrid.model = menuModel
                        menuTitle.visible = true
                        menuGrid.visible = true
                        unfoldAnimation.start()
                    }
                }
            }

            GCText {
                text: "Menu"
                fontSize: tinySize
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: "white"
            }
        }

        Rectangle {
            id: toolsTitle
            width: root.tabWidth
            height: root.tabHeight
            radius: 10
            color: "#1A1A1A"
            border.color: "white"
            anchors.top: parent.bottom
            anchors.left: menuTitle.right
            //x: width
            anchors.leftMargin: 2
            anchors.topMargin: -8
            z: parent.z - 1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorGrid.visible = false
                    menuGrid.visible = true
                    if(menuPanel.panelUnFolded) {
                        foldAnimation.start()
                        root.showAllTabs()
                    }
                    else {
                        root.hideAllTabs()
                        toolsTitle.visible = true
                        menuGrid.model = toolsModel
                        menuGrid.visible = true
                        unfoldAnimation.start()
                    }
                }
            }

            GCText {
                text: "Tools"
                fontSize: tinySize
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: "white"
            }
        }

        Rectangle {
            id: toolsOptionTitle
            width: root.tabWidth
            height: root.tabHeight
            radius: 10
            color: "#1A1A1A"
            border.color: "white"
            anchors.top: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.topMargin: -8
            z: parent.z - 1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    menuGrid.model = toolsModel
                    if(menuPanel.panelUnFolded) {
                        foldAnimation.start()
                        root.showAllTabs()
                    }
                    else {
                        root.hideAllTabs()
                        toolsTitle.visible = true
                        unfoldAnimation.start()
                    }
                }
            }

            GCText {
                text: "Tools Option"
                fontSize: tinySize
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: "white"
            }
        }

        Rectangle {
            id: colorsTitle
            width: root.tabWidth
            height: root.tabHeight
            radius: 10
            color: "#1A1A1A"
            border.color: "white"
            anchors.top: parent.bottom
            anchors.right: toolsOptionTitle.left
            anchors.rightMargin: 2
            anchors.topMargin: -8
            z: parent.z - 1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    menuGrid.visible = false
                    colorGrid.visible = true
                    if(menuPanel.panelUnFolded) {
                        foldAnimation.start()
                        root.showAllTabs()
                    }
                    else {
                        root.hideAllTabs()
                        colorsTitle.visible = true
                        unfoldAnimation.start()
                    }
                }
            }

            GCText {
                text: "Color"
                fontSize: tinySize
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: "white"
            }
        }
    }
}
