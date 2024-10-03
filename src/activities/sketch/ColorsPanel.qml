/* GCompris - ColorsPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
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
        // Test Palette 1
        [Qt.rgba(0, 0, 0, 1), Qt.rgba(0.91, 0.47, 0.21, 1), Qt.rgba(0.91, 0.73, 0.21, 1),
        Qt.rgba(0.46, 0.82, 0.11, 1), Qt.rgba(0.11, 0.82, 0.82, 1), Qt.rgba(0.11, 0.55, 0.82, 1),
        Qt.rgba(0.8, 0.47, 0.84, 1), Qt.rgba(0.88, 0.44, 0.44, 1), Qt.rgba(1, 1, 1, 1)],
        // Gray Palette
        [Qt.rgba(0.1, 0.1, 0.1, 1), Qt.rgba(0.2, 0.2, 0.2, 1), Qt.rgba(0.3, 0.3, 0.3, 1),
        Qt.rgba(0.4, 0.4, 0.4, 1), Qt.rgba(0.5, 0.5, 0.5, 1), Qt.rgba(0.6, 0.6, 0.6, 1),
        Qt.rgba(0.7, 0.7, 0.7, 1), Qt.rgba(0.8, 0.8, 0.8, 1), Qt.rgba(0.9, 0.9, 0.9, 1)]
    ]

    // Copy of paletteList to restore edited values
    readonly property var defaultPaletteList: [
        // Test Palette 1
        [Qt.rgba(0, 0, 0, 1), Qt.rgba(0.91, 0.47, 0.21, 1), Qt.rgba(0.91, 0.73, 0.21, 1),
        Qt.rgba(0.46, 0.82, 0.11, 1), Qt.rgba(0.11, 0.82, 0.82, 1), Qt.rgba(0.11, 0.55, 0.82, 1),
        Qt.rgba(0.8, 0.47, 0.84, 1), Qt.rgba(0.88, 0.44, 0.44, 1), Qt.rgba(1, 1, 1, 1)],
        // Gray Palette
        [Qt.rgba(0.1, 0.1, 0.1, 1), Qt.rgba(0.2, 0.2, 0.2, 1), Qt.rgba(0.3, 0.3, 0.3, 1),
        Qt.rgba(0.4, 0.4, 0.4, 1), Qt.rgba(0.5, 0.5, 0.5, 1), Qt.rgba(0.6, 0.6, 0.6, 1),
        Qt.rgba(0.7, 0.7, 0.7, 1), Qt.rgba(0.8, 0.8, 0.8, 1), Qt.rgba(0.9, 0.9, 0.9, 1)]
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
