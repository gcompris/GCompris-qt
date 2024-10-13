/* GCompris - GeometryToolPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: geometryToolPanel
    visible: false
    anchors.fill: parent

    property Item selectedModeButton: rectangleModeButton // NOTE init default value on start
    readonly property string toolTitle: qsTr("Geometry Tools")

    // Set selected mode on selected tool, and triggered when selecting the tool
    function setToolMode() {
        items.selectedTool.selectedMode = selectedModeButton.toolMode;
        toolsPanel.loadModeSettings();
    }

    // Save selected mode for current tool, then call setToolMode
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
            // rectangle mode
            id: rectangleModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/rectangleTool.svg"
            property Item toolMode: geometryTool.rectangleMode
            onButtonClicked: {
                geometryToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // square mode
            id: squareModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/squareTool.svg"
            property Item toolMode: geometryTool.squareMode
            onButtonClicked: {
                geometryToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // oval mode
            id: ovalModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/ovalTool.svg"
            property Item toolMode: geometryTool.ovalMode
            onButtonClicked: {
                geometryToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // circle mode
            id: circleModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/circleTool.svg"
            property Item toolMode: geometryTool.circleMode
            onButtonClicked: {
                geometryToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // freeLineMode mode
            id: freeLineModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/freeLineTool.svg"
            property Item toolMode: geometryTool.freeLineMode
            onButtonClicked: {
                geometryToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // hortoLine mode
            id: hortoLineModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/hortoLineTool.svg"
            property Item toolMode: geometryTool.hortoLineMode
            onButtonClicked: {
                geometryToolPanel.selectMode(self);
            }
        }
    }
}
