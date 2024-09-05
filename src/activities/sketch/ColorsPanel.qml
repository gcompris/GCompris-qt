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

    onClose: {
        items.selectedTool.toolInit()
    }

    function selectColor(colorToSelect) {
        items.selectedForegroundColor = colorToSelect
        hueSelector.setValue(colorToSelect.hslHue)
        saturationSelector.setValue(colorToSelect.hslSaturation)
        lightnessSelector.setValue(colorToSelect.hslLightness)
    }

    function editSelectedColor(newColor) {
        // assign the color to items.selectedForegroundColor
        items.selectedForegroundColor = newColor
        // assign the color to the button
        colorButtonsGrid.currentItem.buttonColor = newColor
        // assign the color to the color in palette button
        paletteListView.currentItem.refreshColor(colorButtonsGrid.currentIndex, newColor)
    }

    function resetSelectedColor() {
        paletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex].r = defaultPaletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex].r
        paletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex].g = defaultPaletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex].g
        paletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex].b = defaultPaletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex].b
        loadPaletteToButtons(paletteListView.currentIndex)
        paletteListView.currentItem.reloadPaletteColors(paletteList[paletteListView.currentIndex])
        selectColor(colorButtonsGrid.currentItem.buttonColor)
    }

    function resetSelectedPalette() {
        // Reload all values for selected palette from defaultPaletteList
        // need to copy r/g/b values separately, as assigning Qt.rgba color directly makes a reference instead of copying value
        for(var i = 0; i < paletteList[paletteListView.currentIndex].length; i++) {
            paletteList[paletteListView.currentIndex][i].r = defaultPaletteList[paletteListView.currentIndex][i].r
            paletteList[paletteListView.currentIndex][i].g = defaultPaletteList[paletteListView.currentIndex][i].g
            paletteList[paletteListView.currentIndex][i].b = defaultPaletteList[paletteListView.currentIndex][i].b
        }
        loadPaletteToButtons(paletteListView.currentIndex)
        paletteListView.currentItem.reloadPaletteColors(paletteList[paletteListView.currentIndex])
        selectColor(colorButtonsGrid.currentItem.buttonColor)
    }

    function loadPaletteToButtons(paletteIndex) {
        // We need to manually assign again the colors as the color assignments when editing color break the bindings
        for(var i = 0; i < paletteList[paletteIndex].length; i++) {
            colorButtonsGrid.itemAtIndex(i).buttonColor = paletteList[paletteIndex][i]
        }
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
    property var defaultPaletteList: [
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
        color: items.selectedForegroundColor
    }

    Component {
        id: paletteItem
        Item {
            id: paletteItemContainer
            height: leftButton.height
            width: height

            function refreshColor(rectIndex, newColor) {
                paletteGrid.itemAtIndex(rectIndex).color = newColor
            }

            function reloadPaletteColors(palette) {
                for(var i = 0; i < palette.length; i++) {
                    paletteGrid.itemAtIndex(i).color = palette[i]
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
                    paletteSelector.selectPalette(index)
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
            if(paletteListView.currentIndex == 0)
                return
            selectPalette(paletteListView.currentIndex - 1)
        }

        function selectNextPalette() {
            if(paletteListView.currentIndex == paletteListView.count - 1)
                return
            selectPalette(paletteListView.currentIndex + 1)
        }

        function selectPalette(index) {
            paletteListView.currentIndex = index
            colorsPanel.loadPaletteToButtons(index)
            colorsPanel.selectColor(colorButtonsGrid.currentItem.buttonColor)
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
                    source: "qrc:/gcompris/src/activities/sketch/resource/empty.svg"
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
                        paletteSelector.selectPreviousPalette()
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
                    positionViewAtIndex(currentIndex, ListView.Contain)
                }
            }

            Item {
                id: rightButton
                height: leftButton.height
                width: height * 0.5

                Image {
                    id: rightButtonIcon
                    anchors.fill: parent
                    source: "qrc:/gcompris/src/activities/sketch/resource/empty.svg"
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
                        paletteSelector.selectNextPalette()
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

    Item {
        id: colorButtonsArea
        anchors.top: panelVerticalSpacer.bottom
        anchors.bottom: resetPaletteArea.top
        anchors.left: parent.left
        anchors.margins: items.baseMargins
        width: toolsPanel.settingsColumnWidth

        GCText {
            id: colorsTitle
            text: qsTr("Palette Colors")
            color: items.contentColor
            width: toolsPanel.settingsColumnWidth
            height: toolsPanel.settingsLineHeight
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
                    color: colorsPanel.paletteList[paletteListView.currentIndex][index]
                    border.color: items.contentColor
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        colorButtonsGrid.currentIndex = index
                        colorsPanel.selectColor(buttonRectangle.color)
                    }
                }
            }
        }

        Item {
            id: colorButtonsGridArea
            width: toolsPanel.settingsColumnWidth
            anchors.top: colorsTitle.bottom
            anchors.topMargin: items.baseMargins
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            property int colorButtonsWidth: (width - items.baseMargins * 2) * 0.33
            property int colorButtonsHeight: (height - items.baseMargins * 2) * 0.33

            GridView {
                id: colorButtonsGrid
                anchors.centerIn: parent
                width: colorButtonsGridArea.colorButtonsWidth * 3
                height: colorButtonsGridArea.colorButtonsHeight * 3
                cellWidth: colorButtonsGridArea.colorButtonsWidth
                cellHeight: colorButtonsGridArea.colorButtonsHeight
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
        width: toolsPanel.settingsColumnWidth
        height: toolsPanel.settingsDoubleLineHeight

        GCText {
            id: resetToolTitle
            text: qsTr("Reset palette")
            color: items.contentColor
            height: toolsPanel.settingsLineHeight
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
            buttonSize: Math.min(parent.height, toolsPanel.modeButtonsSize)
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/reload.svg"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            onButtonClicked: {
                colorsPanel.resetSelectedPalette()
            }
        }
    }

    Rectangle {
        id: horizontalSpacer
        color: items.contentColor
        opacity: 0.5
        anchors.top: panelVerticalSpacer.top
        anchors.bottom: parent.bottom
        anchors.left: colorButtonsArea.right
        anchors.margins: items.baseMargins
        width: ApplicationInfo.ratio
    }

    Item {
        id: colorControlsArea
        width: toolsPanel.settingsColumnWidth - 2 * items.baseMargins
        anchors.top: panelVerticalSpacer.bottom
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
                height: toolsPanel.settingsLineHeight
                fontSize: regularSize
                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: selectedColorRectangle
                width: parent.width * 0.6
                height: toolsPanel.settingsLineHeight
                radius: items.baseMargins
                color: items.selectedForegroundColor
                border.color: items.contentColor
                border.width: 2 * ApplicationInfo.ratio
                anchors.horizontalCenter: parent.horizontalCenter
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
                    var color = colorsPanel.paletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex]
                    color.hslHue = newValue
                    colorsPanel.editSelectedColor(color)
                }
            }

            SliderColor {
                //: Color saturation
                id: saturationSelector
                title: qsTr("Saturation", "color saturation")
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0    ; color: Qt.hsla(items.selectedForegroundColor.hslHue, 0, items.selectedForegroundColor.hslLightness) }
                    GradientStop { position: 1    ; color: Qt.hsla(items.selectedForegroundColor.hslHue, 1, items.selectedForegroundColor.hslLightness) }
                }
                onValueChanged: (newValue) => {
                    var color = colorsPanel.paletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex]
                    if(color.hslHue < 0) {
                        color.hslHue = 0
                    }
                    color.hslSaturation = newValue
                    colorsPanel.editSelectedColor(color)
                }
            }

            SliderColor {
                id: lightnessSelector
                //: Color lightness
                title: qsTr("Lightness", "color lightness")
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0    ; color: Qt.hsla(items.selectedForegroundColor.hslHue,
                        items.selectedForegroundColor.hslSaturation, 0) }
                        GradientStop { position: 1    ; color: Qt.hsla(items.selectedForegroundColor.hslHue,
                            items.selectedForegroundColor.hslSaturation, 1) }
                }
                onValueChanged: (newValue) => {
                    var color = colorsPanel.paletteList[paletteListView.currentIndex][colorButtonsGrid.currentIndex]
                    if(color.hslHue < 0) {
                        color.hslHue = 0
                    }
                    color.hslLightness = newValue
                    colorsPanel.editSelectedColor(color)
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
        width: toolsPanel.settingsColumnWidth
        height: toolsPanel.settingsDoubleLineHeight

        GCText {
            id: resetColorTitle
            //: Reload default color for selected slot
            text: qsTr("Reset Color")
            color: items.contentColor
            height: toolsPanel.settingsLineHeight
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
            buttonSize: Math.min(parent.height, toolsPanel.modeButtonsSize)
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/reload.svg"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            onButtonClicked: {
                colorsPanel.resetSelectedColor()
            }
        }
    }
}
