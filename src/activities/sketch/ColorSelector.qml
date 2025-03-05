/* GCompris - ColorSelector.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

Item {
    id: colorSelector

    property int columnWidth: 1
    property int lineHeight: 1
    property int doubleLineHeight: 2
    property int buttonSize: 1
    property list<color> palette: []
    property list<color> defaultPalette: []

    property alias selectedColor: selectedColorRectangle.color

    signal colorEdited(colorIndex: int, editedColor: color)
    signal resetSelectedPalette()

    function selectColor(newSelectedColor) {
        selectedColor = newSelectedColor;
        hueSelector.setValue(selectedColor.hslHue);
        saturationSelector.setValue(selectedColor.hslSaturation);
        lightnessSelector.setValue(selectedColor.hslLightness);
    }

    function editColor(colorIndex, editedColor) {
        selectedColor = editedColor;
        colorButtonsGrid.itemAtIndex(colorIndex).buttonColor = selectedColor;
        palette[colorIndex] = selectedColor;
        colorEdited(colorIndex, selectedColor);
    }

    function resetColor() {
        palette[colorButtonsGrid.currentIndex].r = defaultPalette[colorButtonsGrid.currentIndex].r;
        palette[colorButtonsGrid.currentIndex].g = defaultPalette[colorButtonsGrid.currentIndex].g;
        palette[colorButtonsGrid.currentIndex].b = defaultPalette[colorButtonsGrid.currentIndex].b;
        reloadPaletteToButtons();
        colorEdited(colorButtonsGrid.currentIndex, palette[colorButtonsGrid.currentIndex]);
    }

    function resetPalette() {
        for(var i = 0; i < palette.length; i++) {
            palette[i].r = defaultPalette[i].r;
            palette[i].g = defaultPalette[i].g;
            palette[i].b = defaultPalette[i].b;
        }
        reloadPaletteToButtons();
        resetSelectedPalette();
    }

    function reloadPaletteToButtons() {
        // We need to manually assign again the colors as the color assignments when editing color break the bindings
        for(var i = 0; i < palette.length; i++) {
            colorButtonsGrid.itemAtIndex(i).buttonColor = palette[i];
        }
        selectColor(colorButtonsGrid.currentItem.buttonColor);
    }

    Item {
        id: colorButtonsArea
        anchors.top: parent.top
        anchors.bottom: resetPaletteArea.top
        anchors.left: parent.left
        anchors.margins: items.baseMargins
        width: colorSelector.columnWidth

        GCText {
            id: colorsTitle
            text: qsTr("Palette Colors")
            color: items.contentColor
            width: parent.width
            height: colorSelector.lineHeight
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Component {
            id: colorButton

            Item {
                width: colorButtonsGridArea.colorButtonsWidth
                height: colorButtonsGridArea.colorButtonsHeight

                property alias buttonColor: buttonRectangle.color

                Rectangle {
                    id: buttonRectangle
                    width: colorButtonsGridArea.colorButtonsWidth - items.baseMargins * 2
                    height: colorButtonsGridArea.colorButtonsHeight - items.baseMargins * 2
                    radius: items.baseMargins
                    anchors.centerIn: parent
                    color: colorSelector.palette[index]
                    border.color: items.contentColor
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        colorButtonsGrid.currentIndex = index;
                        colorSelector.selectColor(buttonRectangle.color);
                    }
                }
            }
        }

        Item {
            id: colorButtonsGridArea
            width: parent.width
            anchors.top: colorsTitle.bottom
            anchors.topMargin: items.baseMargins
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            readonly property int colorButtonsWidth: (width - items.baseMargins * 2) * 0.33
            readonly property int colorButtonsHeight: (height - items.baseMargins * 2) * 0.33

            GridView {
                id: colorButtonsGrid
                anchors.centerIn: parent
                width: parent.colorButtonsWidth * 3
                height: parent.colorButtonsHeight * 3
                cellWidth: parent.colorButtonsWidth
                cellHeight: parent.colorButtonsHeight
                highlight: Rectangle {
                    width: colorButtonsGridArea.colorButtonsWidth
                    height: colorButtonsGridArea.colorButtonsHeight
                    radius: items.baseMargins
                    border.color: items.contentColor
                    border.width: 2 * ApplicationInfo.ratio
                    x: colorButtonsGrid.currentItem ? colorButtonsGrid.currentItem.x : 0
                    y: colorButtonsGrid.currentItem ? colorButtonsGrid.currentItem.y : 0
                }
                highlightFollowsCurrentItem: false
                interactive: false
                model: 9
                delegate: colorButton
                currentIndex: 0
            }
        }
    }

    Item {
        id: resetPaletteArea
        anchors.bottom: parent.bottom
        anchors.bottomMargin: items.baseMargins
        anchors.left: parent.left
        width: colorSelector.columnWidth
        height: colorSelector.doubleLineHeight

        GCText {
            id: resetToolTitle
            text: qsTr("Reset palette")
            color: items.contentColor
            height: colorSelector.lineHeight
            anchors.left: parent.left
            anchors.right: resetPaletteButton.left
            anchors.rightMargin: items.baseMargins
            anchors.verticalCenter: resetPaletteButton.verticalCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }

        ActionButton {
            id: resetPaletteButton
            buttonSize: Math.min(parent.height, colorSelector.buttonSize)
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/reload.svg"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            onButtonClicked: {
                colorSelector.resetPalette();
            }
        }
    }

    Rectangle {
        id: horizontalSpacer
        color: items.contentColor
        opacity: 0.5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: colorButtonsArea.right
        anchors.margins: items.baseMargins
        width: ApplicationInfo.ratio
    }

    Item {
        id: colorControlsArea
        width: colorSelector.columnWidth - 2 * items.baseMargins
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: horizontalSpacer.right
        anchors.leftMargin: items.baseMargins

        Column {
            anchors.fill: parent
            spacing: items.baseMargins

            GCText {
                id: selectedColorTitle
                text: qsTr("Selected Color")
                color: items.contentColor
                width: parent.width
                height: colorSelector.lineHeight
                fontSize: regularSize
                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: selectedColorRectangle
                width: parent.width * 0.6
                height: colorSelector.lineHeight
                radius: items.baseMargins
                border.color: items.contentColor
                border.width: 2 * ApplicationInfo.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                color: colorSelector.palette[0]
            }

            SliderColor {
                id: hueSelector
                //: Color hue
                title: qsTr("Hue", "color hue")
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0    ; color: Qt.hsla(0, 1, 0.5) }
                    GradientStop { position: 1 / 6; color: Qt.hsla(1 / 6, 1, 0.5) }
                    GradientStop { position: 2 / 6; color: Qt.hsla(2 / 6, 1, 0.5) }
                    GradientStop { position: 0.5  ; color: Qt.hsla(0.5, 1, 0.5) }
                    GradientStop { position: 4 / 6; color: Qt.hsla(4 / 6, 1, 0.5) }
                    GradientStop { position: 5 / 6; color: Qt.hsla(5 / 6, 1, 0.5) }
                    GradientStop { position: 1    ; color: Qt.hsla(1, 1, 0.5) }
                }
                onValueChanged: (newValue) => {
                    selectedColorRectangle.color.hslHue = newValue;
                    colorSelector.editColor(colorButtonsGrid.currentIndex, selectedColorRectangle.color);
                }
                Component.onCompleted: {
                    if(colorSelector.selectedColor.hslHue) {
                        setValue(colorSelector.selectedColor.hslHue);
                    } else {
                        setValue(0);
                    }
                }
            }

            SliderColor {
                id: saturationSelector
                //: Color saturation
                title: qsTr("Saturation", "color saturation")
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: Qt.hsla(colorSelector.selectedColor.hslHue, 0, colorSelector.selectedColor.hslLightness) }
                    GradientStop { position: 1; color: Qt.hsla(colorSelector.selectedColor.hslHue, 1, colorSelector.selectedColor.hslLightness) }
                }
                onValueChanged: (newValue) => {
                    if(selectedColorRectangle.color.hslHue < 0) {
                        selectedColorRectangle.color.hslHue = 0;
                    }
                    selectedColorRectangle.color.hslSaturation = newValue;
                    colorSelector.editColor(colorButtonsGrid.currentIndex, selectedColorRectangle.color);
                }
                Component.onCompleted: {
                    if(colorSelector.selectedColor.hslValue) {
                        setValue(colorSelector.selectedColor.hslValue);
                    } else {
                        setValue(0);
                    }
                }
            }

            SliderColor {
                id: lightnessSelector
                //: Color lightness
                title: qsTr("Lightness", "color lightness")
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: Qt.hsla(colorSelector.selectedColor.hslHue, colorSelector.selectedColor.hslSaturation, 0) }
                    GradientStop { position: 0.5; color: Qt.hsla(colorSelector.selectedColor.hslHue, colorSelector.selectedColor.hslSaturation, 0.5) }
                    GradientStop { position: 1; color: Qt.hsla(colorSelector.selectedColor.hslHue, colorSelector.selectedColor.hslSaturation, 1) }
                }
                onValueChanged: (newValue) => {
                    if(selectedColorRectangle.color.hslHue < 0) {
                        selectedColorRectangle.color.hslHue = 0;
                    }
                    selectedColorRectangle.color.hslLightness= newValue;
                    colorSelector.editColor(colorButtonsGrid.currentIndex, selectedColorRectangle.color);
                }
                Component.onCompleted: {
                    if(colorSelector.selectedColor.hslLightness) {
                        setValue(colorSelector.selectedColor.hslLightness);
                    } else {
                        setValue(0);
                    }
                }
            }
        }
    }

    Item {
        id: resetColorArea
        anchors.bottom: parent.bottom
        anchors.bottomMargin: items.baseMargins
        anchors.right: parent.right
        anchors.rightMargin: 2 * items.baseMargins
        width: colorSelector.columnWidth
        height: colorSelector.doubleLineHeight

        GCText {
            id: resetColorTitle
            //: Reload default color for selected slot
            text: qsTr("Reset Color")
            color: items.contentColor
            height: colorSelector.lineHeight
            anchors.left: parent.left
            anchors.right: resetColorButton.left
            anchors.rightMargin: items.baseMargins
            anchors.verticalCenter: resetColorButton.verticalCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }

        ActionButton {
            id: resetColorButton
            buttonSize: Math.min(parent.height, colorSelector.buttonSize)
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/reload.svg"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            onButtonClicked: {
                colorSelector.resetColor();
            }
        }
    }

}
