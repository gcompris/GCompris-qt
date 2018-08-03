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
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import "../../core"
import "drawing.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: root
    property int tabWidth: background.width * 0.15
    property int tabHeight: background.height * 0.06
    property alias colorModel: colorModel
    property alias mainPanel: mainPanel
    property alias foldAnimation: foldAnimation
    property string activePanel: "null"
    property alias toolsMode: toolsMode
    property color panelColor: "#1A1A1B"
    property string activeToolIconSource: "qrc:/gcompris/src/activities/drawing/resource/pen.svg"

    ListModel {
        id: menuModel
        ListElement { itemName: qsTr("Save")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/filesaveas.svg" }
        ListElement { itemName: qsTr("Load")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/fileopen.svg" }
        ListElement { itemName: qsTr("Undo")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/undo.svg" }
        ListElement { itemName: qsTr("Redo")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/redo.svg" }
        ListElement { itemName: qsTr("Erase all")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/empty.svg" }
        ListElement { itemName: qsTr("Background color")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/color_wheel.svg" }
        ListElement { itemName: qsTr("Export to PNG")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/empty.svg" }
    }

    ListModel {
        id: toolsModel
        //        ListElement { itemName: qsTr("Pencil")
        //            imgSource: "qrc:/gcompris/src/activities/drawing/resource/pen.svg" }
        ListElement { itemName: qsTr("Brush")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/brush_paint.png" }
        ListElement { itemName: qsTr("Geometric")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/empty.svg" }
        ListElement { itemName: qsTr("Text")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/empty.svg" }
        ListElement { itemName: qsTr("Eraser")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/erase.svg" }
        ListElement { itemName: qsTr("Bucket fill")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/fill.svg" }
        ListElement { itemName: qsTr("Stamp")
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/empty.svg" }
    }

    ListModel {
        id: colorModel
        ListElement {colorCode: "#ff0000"} ListElement {colorCode: "#000000"} ListElement {colorCode: "#0000ff"}
        ListElement {colorCode: "#ffff00"} ListElement {colorCode: "#00ffff"} ListElement {colorCode: "#ff00ff"}
        ListElement {colorCode: "#800000"} ListElement {colorCode: "#000080"} ListElement {colorCode: "#ff4500"}
        ListElement {colorCode: "#A0A0A0"} ListElement {colorCode: "#d2691e"} ListElement {colorCode: "#8b008b"}
    }

    Rectangle {
        id: menuTitle
        width: root.tabWidth
        height: root.tabHeight
        radius: 10
        color: panelColor
        border.color: "white"
        y: -7
        MouseArea {
            anchors.fill: parent
            enabled: (mainPanel.y < -5 && activePanel != "mainPanel") || (mainPanel.y > -5 && activePanel === "mainPanel")
            onClicked: {
                animTarget = menuTitle
                colorGrid.visible = false
                menuGrid.visible = true
                root.activePanel = "mainPanel"
                if(mainPanel.panelUnFolded) {
                    foldAnimation.start()
                }
                else {
                    menuGrid.model = menuModel
                    menuTitle.visible = true
                    menuGrid.visible = true
                    unfoldAnimation.start()
                }
            }
        }

        GCText {
            text: qsTr("Menu")
            fontSize: tinySize
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            color: "white"
        }
    }

    Rectangle {
        id: toolsTitle
        width: root.tabWidth
        height: root.tabHeight
        radius: 10
        color: panelColor
        border.color: "white"
        x: width + 2
        y: -7

        MouseArea {
            anchors.fill: parent
            enabled: (mainPanel.y < -5 && activePanel != "toolsPanel") || (mainPanel.y > -5 && activePanel === "toolsPanel")
            onClicked: {
                animTarget = toolsTitle
                colorGrid.visible = false
                menuGrid.visible = true
                root.activePanel = "toolsPanel"
                if(mainPanel.panelUnFolded) {
                    foldAnimation.start()
                }
                else {
                    toolsTitle.visible = true
                    menuGrid.model = toolsModel
                    menuGrid.visible = true
                    unfoldAnimation.start()
                }
            }
        }

        GCText {
            text: qsTr("Tools")
            fontSize: tinySize
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            color: "white"
        }
    }

    Rectangle {
        id: colorsTitle
        width: root.tabWidth
        height: root.tabHeight
        radius: 10
        color: panelColor
        border.color: "white"
        x: background.width - 2 * width - 2
        y: -7
        z: mainPanel.z - 1
        MouseArea {
            anchors.fill: parent
            enabled: (mainPanel.y < -5 && activePanel != "colorPanel") || (mainPanel.y > -5 && activePanel === "colorPanel")
            onClicked: {
                animTarget = colorsTitle
                menuGrid.visible = false
                colorGrid.visible = true
                root.activePanel = "colorPanel"
                if(mainPanel.panelUnFolded) {
                    foldAnimation.start()
                }
                else {
                    colorsTitle.visible = true
                    unfoldAnimation.start()
                }
            }
        }

        GCText {
            text: qsTr("Color")
            fontSize: tinySize
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            color: "white"
        }
    }

    Rectangle {
        id: toolsOptionTitle
        width: root.tabWidth
        height: root.tabHeight
        radius: 10
        color: panelColor
        border.color: "white"
        x: background.width - width
        y: -7

        MouseArea {
            anchors.fill: parent
            enabled: (mainPanel.y < -5 && activePanel != "toolOptions") || (mainPanel.y > -5 && activePanel === "toolOptions")
            onClicked: {
                animTarget = toolsOptionTitle
                root.activePanel = "toolOptions"
                menuGrid.visible = false
                colorGrid.visible = false
                if(mainPanel.panelUnFolded) {
                    foldAnimation.start()
                }
                else {
                    toolsOptionTitle.visible = true
                    unfoldAnimation.start()
                }
            }
        }

        GCText {
            text: qsTr("Tool Options")
            fontSize: tinySize
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            color: "white"
        }
    }

    Rectangle {
        id: activeConfiguration
        width: background.width > background.height ? root.tabWidth * 1.3 : root.tabWidth * 2
        height: background.width > background.height ? root.tabHeight * 1.3 : root.tabHeight * 1.2
        radius: 10
        color: "grey"
        border.color: "white"
        x: toolsTitle.x + toolsTitle.width + (background.width > background.height ? width / 2 : width / 6)
        y: -7
        z: mainPanel.z - 1

        Image {
            id: undo
            source: "qrc:/gcompris/src/activities/drawing/resource/undo.svg"
            height: activeConfiguration.height * 0.60//background.width > background.height ? parent.height * 0.75 : parent.height * 0.60
            width: activeConfiguration.width / 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.08
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: undo.scale = 1.1
                onExited: undo.scale = 1
                onClicked: {
                    Activity.selectTool("Undo")
                    activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                }
            }
        }

        Rectangle {
            id: activeColor
            height: undo.height - 4
            width: activeConfiguration.width / 5
            color: items.paintColor
            radius: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: undo.right
            anchors.leftMargin: 5
            border.width: 2
            border.color: "white"
        }

        Image {
            id: activeTool
            source: activeToolIconSource
            height: undo.height
            width: activeConfiguration.width / 5
            fillMode: Image.PreserveAspectFit
            anchors.left: activeColor.right
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            id: redo
            source: "qrc:/gcompris/src/activities/drawing/resource/redo.svg"
            height: undo.height
            width: activeConfiguration.width / 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: activeTool.right
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: redo.scale = 1.1
                onExited: redo.scale = 1
                onClicked: {
                    Activity.selectTool("Redo")
                    activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                }
            }
        }
    }

    property var animTarget: menuTitle

    NumberAnimation {
        id: unfoldTitle
        target: animTarget
        property: "y"
        to: mainPanel.height - 7
        duration: 200
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: foldTitle
        target: animTarget
        property: "y"
        to: -7
        duration: 200
        easing.type: Easing.InOutQuad
        onStopped: root.activePanel = "null"
    }

    Rectangle {
        id: mainPanel
        anchors.leftMargin: 5
        width: background.width
        height: background.height / 2.4
        color: panelColor
        y: -height
        border.color: "white"
        property bool panelUnFolded: y >= -5

        NumberAnimation {
            id: foldAnimation
            target: mainPanel
            property: "y"
            to: - mainPanel.height
            duration: 200
            easing.type: Easing.InOutQuad
            onStarted: {
                foldTitle.start()
                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
            }
        }

        // This mouseArea overrides the canvas region and avoid drawing through panel.
        MouseArea {
            anchors.fill: parent
        }

        NumberAnimation {
            id: unfoldAnimation
            target: mainPanel
            property: "y"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
            onStarted: {
                unfoldTitle.start()
                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
            }
        }

        GridView {
            id: menuGrid
            width: parent.width * 0.75
            height: parent.height * 0.80
            anchors.centerIn: parent
            visible: root.activePanel == "mainPanel" || root.activePanel == "toolsPanel"
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
                            activeToolIconSource = img.source
                            Activity.selectTool(itemName)
                            foldAnimation.start()
                        }
                    }
                }
                GCText {
                    text: itemName
                    width: root.tabWidth
                    anchors.horizontalCenter: img.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: img.bottom
                    wrapMode: Text.WordWrap
                    fontSize: tinySize
                    color: "white"
                }
            }
        }

        GridView {
            id: colorGrid
            width: parent.width * 0.75
            height: parent.height * 0.80
            anchors.left: selectedColor.right
            anchors.verticalCenter: mainPanel.verticalCenter
            anchors.leftMargin: 30
            anchors.rightMargin: 10
            anchors.topMargin: 10
            cellWidth: width / 4.7
            cellHeight: height / 3.6
            interactive: false
            model: colorModel
            visible: root.activePanel == "colorPanel"
            z: 1800
            delegate: Rectangle {
                id: root1
                radius: 8
                width: colorGrid.cellWidth * 0.80
                height: colorGrid.cellHeight * 0.90
                color: modelData
                border.width: 3
                border.color: items.activeColorIndex === index ? "grey" : "transparent"
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if(items.activeColorIndex != index) {
                            parent.border.color = "grey"
                            root1.scale = 1.1
                        }
                    }
                    onExited: {
                        if(items.activeColorIndex != index) {
                            root1.scale = 1
                            parent.border.color = modelData
                        }
                    }

                    // set this color as current paint color
                    onClicked: {
                        var lastActiveIndex = items.activeColorIndex
                        var lastActiveColor = items.paintColor
                        root.colorModel.remove(lastActiveIndex)
                        root.colorModel.insert(lastActiveIndex, {colorCode: lastActiveColor.toString()})
                        items.activeColorIndex = index
                        items.paintColor = root1.color
                        items.lastActiveColor = items.paintColor
                        background.hideExpandedTools()
                        items.paintColor = color
                        background.reloadSelectedPen()
                        colorPicker.updateColor((items.paintColor).toString())
                        foldAnimation.start()
                    }
                }
            }
        }

        ColorDialog {
            id: colorPicker
            anchors.left: mainPanel.left
            anchors.verticalCenter: mainPanel.verticalCenter
            visible: colorGrid.visible
            anchors.leftMargin: 20
        }

        Rectangle {
            id: selectedColor
            width: mainPanel.width * 0.08
            height: mainPanel.height * 0.30
            visible: colorGrid.visible
            radius: 8
            border.width: 3
            z: colorGrid.z
            anchors.left: colorPicker.right
            anchors.leftMargin: 10
            anchors.bottom: colorGrid.bottom
            anchors.bottomMargin: 30
            color: colorPicker.currentColorCode
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    items.paintColor = selectedColor.color
                    animTarget = colorsTitle
                    foldAnimation.start()
                }
            }
        }

        Button {
            style: GCButtonStyle { theme: "light" }
            text: qsTr("Save")
            width: selectedColor.width
            anchors.left: selectedColor.left
            anchors.bottomMargin: 30
            visible: colorGrid.visible
            anchors.bottom: selectedColor.top
            onClicked: {
                root.colorModel.remove(items.activeColorIndex)
                root.colorModel.insert(items.activeColorIndex, {colorCode: (colorPicker.currentColor()).toString()})
                items.paintColor = (colorPicker.currentColor()).toString()
                foldAnimation.start()
            }
        }

        ToolsMode {
            id: toolsMode
            visible: root.activePanel == "toolOptions"
        }
    }

    Rectangle {
        width: root.tabWidth
        height: 8
        x: animTarget.x
        y: animTarget.y
        color: panelColor
    }
}
