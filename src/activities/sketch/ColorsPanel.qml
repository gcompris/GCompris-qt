/* GCompris - ColorsPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

FoldablePanel {
    id: colorsPanel
    icon1Source: "qrc:/gcompris/src/activities/sketch/resource/palette.svg"
    icon2Source: "qrc:/gcompris/src/activities/sketch/resource/empty.svg"

    property alias selectedColor: colorSelector.selectedColor

    onClose: {
        items.selectedTool.toolInit();
    }

    property var paletteList: [
        // Default palette
        ["#000000","#e87836","#e8ba36","#75d11c","#1cd1d1","#1c8cd1","#cc78d6","#e07070","#ffffff"],
        // Gray palette
        ["#1a1a1a","#333333","#4d4d4d","#666666","#808080","#999999","#b3b3b3","#cccccc","#e6e6e6"],
        // Red
        ["#730c0c","#991010","#be1515","#ea1313","#ee3939","#f26161","#f88585","#faadad","#fcd7d7"],
        // Orange
        ["#73330c","#994710","#be5915","#ea6913","#ee7d39","#f29b61","#f8b385","#faccad","#fce6d7"],
        // Yellow
        ["#735c0c","#997d10","#be9c15","#eabf13","#eec639","#f2d561","#f8e185","#faebad","#fcf4d7"],
        // Green (yellowish)
        ["#35730c","#479910","#5dbe15","#69ea13","#81ee39","#9bf261","#b6f885","#ccfaad","#e6fcd7"],
        // Green (bluish)
        ["#0c7333","#109944","#15be59","#13ea64","#39ee81","#61f298","#85f8b3","#adfacc","#d7fce6"],
        // Blue (sky)
        ["#0c5e73","#107d99","#15a0be","#13bfea","#39caee","#61d5f2","#85e1f8","#adebfa","#d7f5fc"],
        // Blue (marine)
        ["#0c3573","#104799","#155dbe","#1369ea","#3981ee","#619bf2","#85b6f8","#adccfa","#d7e6fc"],
        // Purple (bluish)
        ["#330c73","#471099","#5915be","#6913ea","#7d39ee","#9b61f2","#b385f8","#ccadfa","#e5d7fc"],
        // Purple (redish)
        ["#5c0c73","#7a1099","#9c15be","#ba13ea","#c639ee","#d161f2","#de85f8","#e9adfa","#f4d7fc"],
        // Pink
        ["#730c35","#991047","#be155d","#ea1369","#ee3981","#f2619b","#f885b3","#faadcc","#fcd7e6"]
    ]

    // Copy of paletteList to restore edited values
    readonly property var defaultPaletteList: [
        // Default palette
        ["#000000","#e87836","#e8ba36","#75d11c","#1cd1d1","#1c8cd1","#cc78d6","#e07070","#ffffff"],
        // Gray palette
        ["#1a1a1a","#333333","#4d4d4d","#666666","#808080","#999999","#b3b3b3","#cccccc","#e6e6e6"],
        // Red
        ["#730c0c","#991010","#be1515","#ea1313","#ee3939","#f26161","#f88585","#faadad","#fcd7d7"],
        // Orange
        ["#73330c","#994710","#be5915","#ea6913","#ee7d39","#f29b61","#f8b385","#faccad","#fce6d7"],
        // Yellow
        ["#735c0c","#997d10","#be9c15","#eabf13","#eec639","#f2d561","#f8e185","#faebad","#fcf4d7"],
        // Green (yellowish)
        ["#35730c","#479910","#5dbe15","#69ea13","#81ee39","#9bf261","#b6f885","#ccfaad","#e6fcd7"],
        // Green (bluish)
        ["#0c7333","#109944","#15be59","#13ea64","#39ee81","#61f298","#85f8b3","#adfacc","#d7fce6"],
        // Blue (sky)
        ["#0c5e73","#107d99","#15a0be","#13bfea","#39caee","#61d5f2","#85e1f8","#adebfa","#d7f5fc"],
        // Blue (marine)
        ["#0c3573","#104799","#155dbe","#1369ea","#3981ee","#619bf2","#85b6f8","#adccfa","#d7e6fc"],
        // Purple (bluish)
        ["#330c73","#471099","#5915be","#6913ea","#7d39ee","#9b61f2","#b385f8","#ccadfa","#e5d7fc"],
        // Purple (redish)
        ["#5c0c73","#7a1099","#9c15be","#ba13ea","#c639ee","#d161f2","#de85f8","#e9adfa","#f4d7fc"],
        // Pink
        ["#730c35","#991047","#be155d","#ea1369","#ee3981","#f2619b","#f885b3","#faadcc","#fcd7e6"]
    ]

    Rectangle {
        id: handleColorDisplay
        parent: icon2
        anchors.fill: parent
        anchors.margins: ApplicationInfo.ratio
        z: -1
        radius: width * 0.5
        color: colorSelector.selectedColor
    }

    Component {
        id: paletteItem
        Item {
            id: paletteItemContainer
            height: leftButton.height
            width: height

            function refreshColor(rectIndex, newColor) {
                paletteGrid.itemAtIndex(rectIndex).color = newColor;
            }

            function reloadPaletteColors(palette) {
                for(var i = 0; i < palette.length; i++) {
                    paletteGrid.itemAtIndex(i).color = palette[i];
                }
            }

            GridView {
                id: paletteGrid
                width: parent.width - items.baseMargins * 2
                height: width
                cellWidth: width * 0.33
                cellHeight: cellWidth
                anchors.centerIn: parent
                model: modelData
                delegate: Rectangle {
                    width: paletteGrid.cellWidth
                    height: paletteGrid.cellHeight
                    color: paletteGrid.model[index]
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    paletteSelector.selectPalette(index);
                }
            }
        }
    }

    Item {
        id: paletteSelector
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: items.baseMargins
        height: 50 * ApplicationInfo.ratio

        function selectPreviousPalette() {
            if(paletteListView.currentIndex == 0) {
                return;
            }
            selectPalette(paletteListView.currentIndex - 1);
        }

        function selectNextPalette() {
            if(paletteListView.currentIndex == paletteListView.count - 1) {
                return;
            }
            selectPalette(paletteListView.currentIndex + 1);
        }

        function selectPalette(index) {
            paletteListView.currentIndex = index;
            colorSelector.reloadPaletteToButtons();
        }

        GCText {
            id: palettesLabel
            text: qsTr("Palettes")
            color: items.contentColor
            width: parent.width * 0.25
            height: parent.height
            fontSize: regularSize
            fontSizeMode: Text.Fit
            anchors.left: parent.left
            anchors.bottom:parent.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Row {
            anchors.left: palettesLabel.right
            anchors.right: parent.right
            spacing: items.baseMargins

            Item {
                id: leftButton
                height: paletteSelector.height
                width: height * 0.5

                Image {
                    id: leftButtonIcon
                    anchors.fill: parent
                    source: "qrc:/gcompris/src/activities/sketch/resource/arrow.svg"
                    sourceSize.width: width
                    sourceSize.height: height
                    opacity: paletteListView.currentIndex == 0 ? 0.5 : 1
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: leftButtonIcon.scale = 0.9
                    onReleased: leftButtonIcon.scale = 1
                    enabled: leftButtonIcon.opacity == 1
                    onClicked: {
                        paletteSelector.selectPreviousPalette();
                    }
                }
            }

            ListView {
                id: paletteListView
                width: parent.width - leftButton.width - rightButton.width - items.baseMargins * 2
                height: leftButton.height
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                highlight: Rectangle {
                    height: leftButton.height
                    width: height
                    color: "transparent"
                    border.color: items.contentColor
                    border.width: 2 * ApplicationInfo.ratio
                    x: paletteListView.currentItem.x
                    y: paletteListView.currentItem.y
                }
                highlightFollowsCurrentItem: false
                clip: true
                model: paletteList
                delegate: paletteItem
                currentIndex: 0
                onCurrentIndexChanged: {
                    positionViewAtIndex(currentIndex, ListView.Contain);
                }
            }

            Item {
                id: rightButton
                height: leftButton.height
                width: height * 0.5

                Image {
                    id: rightButtonIcon
                    anchors.fill: parent
                    source: "qrc:/gcompris/src/activities/sketch/resource/arrow.svg"
                    mirror: true
                    sourceSize.width: items.buttonSize
                    sourceSize.height: items.buttonSize
                    opacity: paletteListView.currentIndex == paletteListView.count - 1 ? 0.5 : 1
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: rightButtonIcon.scale = 0.9
                    onReleased: rightButtonIcon.scale = 1
                    enabled: rightButtonIcon.opacity == 1
                    onClicked: {
                        paletteSelector.selectNextPalette();
                    }
                }
            }
        }
    }

    Rectangle {
        id: panelVerticalSpacer
        color: items.contentColor
        opacity: 0.5
        height: ApplicationInfo.ratio
        anchors.top: paletteSelector.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: items.baseMargins
    }

    ColorSelector {
        id: colorSelector
        anchors.top: panelVerticalSpacer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        columnWidth: toolsPanel.settingsColumnWidth
        lineHeight: toolsPanel.settingsLineHeight
        doubleLineHeight: toolsPanel.settingsDoubleLineHeight
        buttonSize: toolsPanel.modeButtonsSize

        palette: colorsPanel.paletteList[paletteListView.currentIndex]
        defaultPalette: colorsPanel.defaultPaletteList[paletteListView.currentIndex]

        // save edited colors to palette lists and refresh paletteListView
        onColorEdited: (colorIndex, editedColor) => {
           colorsPanel.paletteList[paletteListView.currentIndex][colorIndex] = editedColor;
           paletteListView.currentItem.refreshColor(colorIndex, editedColor);
        }
        onResetSelectedPalette: {
            for(var i = 0; i < palette.length; i++) {
                colorsPanel.paletteList[paletteListView.currentIndex][i] = palette[i];
            }
            paletteListView.currentItem.reloadPaletteColors(colorsPanel.paletteList[paletteListView.currentIndex]);
        }
    }
}
