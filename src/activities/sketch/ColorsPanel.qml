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

    Rectangle {
        id: handleColorDisplay
        parent: icon2
        anchors.fill: parent
        anchors.margins: GCStyle.thinnestBorder
        z: -1
        radius: width * 0.5
        color: colorSelector.selectedColor
    }


    PaletteSelector {
        id: paletteSelector
        onPaletteSelected: {
            colorSelector.reloadPaletteToButtons();
        }
    }

    Rectangle {
        id: panelVerticalSpacer
        color: GCStyle.contentColor
        opacity: 0.5
        height: GCStyle.thinnestBorder
        anchors.top: paletteSelector.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: GCStyle.halfMargins
    }

    ColorSelector {
        id: colorSelector
        anchors.top: panelVerticalSpacer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        palette: paletteSelector.currentPalette.modelData
        defaultPalette: paletteSelector.defaultPaletteList[paletteSelector.currentIndex]

        // save edited colors to palette lists and refresh paletteListView
        onColorEdited: (colorIndex, editedColor) => {
           paletteSelector.currentPalette.modelData[colorIndex] = editedColor;
           paletteSelector.currentPalette.refreshColor(colorIndex, editedColor);
        }
        onResetSelectedPalette: {
            for(var i = 0; i < palette.length; i++) {
                 paletteSelector.currentPalette.modelData[i] = palette[i];
            }
            paletteSelector.currentPalette.reloadPaletteColors(paletteSelector.paletteList[paletteSelector.currentIndex]);
        }
    }
}
