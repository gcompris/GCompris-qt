/* GCompris - GradientToolSettings.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: gradientToolSettings
    visible: false

    property Item selectedModeButton: linearModeButton // NOTE init default value on start
    property alias modeIconOpacity: opacitySlider.value
    property int modeIconRotation: 0
    property bool modeIconMirror: false


    function loadOpacitySettings() {
        opacitySlider.value = gradientTool.selectedMode.toolOpacity
    }

    function setOpacitySettings() {
        gradientTool.selectedMode.toolOpacity = opacitySlider.value
    }

    function loadRadiusSettings() {
        if(gradientTool.selectedMode.defaultFocalRadius == null) {
            radiusSlider.visible = false
        } else {
            radiusSlider.visible = true
            radiusSlider.value = gradientTool.selectedMode.focalRadius
        }
    }

    function setRadiusSettings() {
        gradientTool.selectedMode.focalRadius = radiusSlider.value
    }

    function loadModeSettings() {
        loadOpacitySettings()
        loadRadiusSettings()
    }

    // Set selected mode on gradient tool
    function setToolMode() {
        gradientTool.selectedMode = selectedModeButton.gradientMode
        loadModeSettings()
    }

    // Save selected mode for current tool, then call setToolMode
    function selectMode(modeButton) {
        selectedModeButton = modeButton
        setToolMode()
    }

    // Reload default values for selected tool mode
    function reloadDefaultModeSettings() {
        gradientTool.selectedMode.toolOpacity = gradientTool.selectedMode.defaultToolOpacity
        if(gradientTool.selectedMode.defaultFocalRadius != null) {
            gradientTool.selectedMode.focalRadius = gradientTool.selectedMode.defaultFocalRadius
        }

        // then load again the settings to the panel
        loadModeSettings()
    }

    GCText {
        id: toolTitle
        text: qsTr("Gradient Tools")
        color: items.contentColor
        width: toolsPanel.settingsColumnWidth
        height: toolsPanel.settingsLineHeight
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        id: modeListArea
        width: toolsPanel.settingsColumnWidth
        anchors.top: toolTitle.bottom
        anchors.topMargin: items.baseMargins
        anchors.left: parent.left
        anchors.bottom: parent.bottom

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
                property Item gradientMode: gradientTool.linearGradient
                onButtonClicked: {
                    gradientToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // radial mode
                id: radialModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/radialGradient.svg"
                property Item gradientMode: gradientTool.radialGradient
                onButtonClicked: {
                    gradientToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // inverted radial mode
                id: invertedRadialModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/invertedRadialGradient.svg"
                property Item gradientMode: gradientTool.invertedRadialGradient
                onButtonClicked: {
                    gradientToolSettings.selectMode(self)
                }
            }
        }
    }

    Item {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: toolsPanel.settingsColumnWidth
        height: toolsPanel.settingsDoubleLineHeight

        GCText {
            id: resetToolTitle
            text: qsTr("Reset tool settings")
            color: items.contentColor
            height: toolsPanel.settingsLineHeight
            anchors.left: parent.left
            anchors.right: resetMode.left
            anchors.rightMargin: items.baseMargins
            anchors.verticalCenter: resetMode.verticalCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }

        ActionButton {
            id: resetMode
            buttonSize: Math.min(parent.height, toolsPanel.modeButtonsSize)
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/reload.svg"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            onButtonClicked: {
                gradientToolSettings.reloadDefaultModeSettings()
            }
        }
    }

    Rectangle {
        id: horizontalSpacer
        color: items.contentColor
        opacity: 0.5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: modeListArea.right
        anchors.leftMargin: items.baseMargins
        anchors.right: modeSettingsArea.left
        anchors.rightMargin: items.baseMargins
    }

    Item {
        id: modeSettingsArea
        width: toolsPanel.settingsColumnWidth
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right

        Column {
            anchors.fill: parent
            spacing: items.baseMargins

            SliderSettings {
                id: opacitySlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Opacity")
                from: 0.1
                to: 1
                stepSize: 0.1
                value: 1
                source: selectedModeButton.iconSource ? selectedModeButton.iconSource : ""
                useImageInfo: true
                onSliderMoved: {
                    gradientToolSettings.setOpacitySettings()
                }
            }

            SliderSettings {
                id: radiusSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Inner Circle Size")
                from: 1
                to: 300
                stepSize: 1
                value: 1
                onSliderMoved: {
                    gradientToolSettings.setRadiusSettings()
                }
            }
        }
    }

}
