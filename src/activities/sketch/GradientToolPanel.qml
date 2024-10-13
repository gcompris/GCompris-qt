/* GCompris - GradientToolPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: gradientToolPanel
    visible: false
    anchors.fill: parent

    property Item selectedModeButton: linearModeButton // NOTE init default value on start
    readonly property string toolTitle: qsTr("Gradient Tools")

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
            // linear mode
            id: linearModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/linearGradient.svg"
            property Item toolMode: gradientTool.linearGradient
            onButtonClicked: {
                gradientToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // radial mode
            id: radialModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/radialGradient.svg"
            property Item toolMode: gradientTool.radialGradient
            onButtonClicked: {
                gradientToolPanel.selectMode(self);
            }
        }
        SelectionButton {
            // inverted radial mode
            id: invertedRadialModeButton
            buttonSize: toolsPanel.modeButtonsSize
            isButtonSelected: selectedModeButton == self
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/invertedRadialGradient.svg"
            property Item toolMode: gradientTool.invertedRadialGradient
            onButtonClicked: {
                gradientToolPanel.selectMode(self);
            }
        }
    }
}
