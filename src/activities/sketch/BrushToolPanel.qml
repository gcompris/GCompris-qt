/* GCompris - BrushToolPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: brushToolPanel
    visible: false
    anchors.fill: parent

    property Item selectedModeButton: roundBrushButton // NOTE init default value on start
    readonly property string toolTitle: items.eraserMode ? qsTr("Eraser Tools") : qsTr("Drawing Tools")

    // Set selected mode on selected tool, and triggered when selecting the tool
    function setToolMode() {
        items.selectedTool.selectedMode = selectedModeButton.toolMode;
        toolsPanel.loadModeSettings();
    }

    // Save selected mode for current tool (brush or eraser), then call setToolMode
    function selectMode(modeButton) {
        selectedModeButton = modeButton;
        setToolMode();
    }

    Grid {
        id: modeList
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 3
        rows: 2
        spacing: items.baseMargins

        SelectionButton {
            // roundBrush
            id: roundBrushButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/roundBrush.svg"
            property Item toolMode: brushTool.roundBrush
            onButtonClicked: {
                brushToolPanel.selectMode(self);
            }
        }

        SelectionButton {
            // sketchBrush
            id: sketchBrushButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/sketchBrush.svg"
            property Item toolMode: brushTool.sketchBrush
            onButtonClicked: {
                brushToolPanel.selectMode(self);
            }
        }

        SelectionButton {
            // fillBrush
            id: fillBrushButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/fillBrush.svg"
            property Item toolMode: brushTool.fillBrush
            onButtonClicked: {
                brushToolPanel.selectMode(self);
            }
        }

        SelectionButton {
            // airBrush
            id: airBrushButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/airBrush.svg"
            property Item toolMode: brushTool.airBrush
            onButtonClicked: {
                brushToolPanel.selectMode(self);
            }
        }

        SelectionButton {
            // sprayBrush
            id: sprayBrushButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/sprayBrush.svg"
            property Item toolMode: brushTool.sprayBrush
            onButtonClicked: {
                brushToolPanel.selectMode(self);
            }
        }

        SelectionButton {
            // circlesBrush
            id: circlesBrushButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/circlesBrush.svg"
            property Item toolMode: brushTool.circlesBrush
            onButtonClicked: {
                brushToolPanel.selectMode(self);
            }
        }
    }
}
