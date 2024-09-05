/* GCompris - GeometryToolSettings.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: geometryToolSettings
    visible: false

    property Item selectedModeButton: rectangleModeButton // NOTE init default value on start
    property alias modeIconOpacity: opacitySlider.value
    property int modeIconRotation: rotationSlider.visible ? rotationSlider.value : 0
    property bool modeIconMirror: false


    function loadOpacitySettings() {
        opacitySlider.value = geometryTool.selectedMode.toolOpacity
    }

    function setOpacitySettings() {
        geometryTool.selectedMode.toolOpacity = opacitySlider.value
    }

    function loadRadiusSettings() {
        if(geometryTool.selectedMode.defaultRadius == null) {
            radiusSlider.visible = false
        } else {
            radiusSlider.visible = true
            radiusSlider.value = geometryTool.selectedMode.radius
        }
    }

    function setRadiusSettings() {
        geometryTool.selectedMode.radius = radiusSlider.value
    }

    function loadRotationSettings() {
        if(geometryTool.selectedMode.defaultToolRotation == null) {
            rotationSlider.visible = false
        } else {
            rotationSlider.visible = true
            rotationSlider.value = geometryTool.selectedMode.toolRotation
        }
    }

    function setRotationSettings() {
        geometryTool.selectedMode.toolRotation = rotationSlider.value
    }

    function loadLineWidthSettings() {
        if(geometryTool.selectedMode.defaultLineWidth == null) {
            lineWidthSlider.visible = false
        } else {
            lineWidthSlider.visible = true
            lineWidthSlider.value = geometryTool.selectedMode.lineWidth
        }
    }

    function setLineWidthSettings() {
        geometryTool.selectedMode.lineWidth = lineWidthSlider.value
    }

    function loadModeSettings() {
        loadOpacitySettings()
        loadRadiusSettings()
        loadRotationSettings()
        loadLineWidthSettings()
    }

    // Set selected mode on geometry tool
    function setToolMode() {
        geometryTool.selectedMode = selectedModeButton.geometryMode
        loadModeSettings()
    }

    // Save selected mode for current tool, then call setToolMode
    function selectMode(modeButton) {
        selectedModeButton = modeButton
        setToolMode()
    }

    // Reload default values for selected tool mode
    function reloadDefaultModeSettings() {
        geometryTool.selectedMode.toolOpacity = geometryTool.selectedMode.defaultToolOpacity
        if(geometryTool.selectedMode.defaultRadius != null) {
            geometryTool.selectedMode.radius = geometryTool.selectedMode.defaultRadius
        }
        if(geometryTool.selectedMode.defaultToolRotation != null) {
            geometryTool.selectedMode.toolRotation = geometryTool.selectedMode.defaultToolRotation
        }
        if(geometryTool.selectedMode.defaultLineWidth != null) {
            geometryTool.selectedMode.lineWidth = geometryTool.selectedMode.defaultLineWidth
        }

        // then load again the settings to the panel
        loadModeSettings()
    }

    GCText {
        id: toolTitle
        text: qsTr("Geometry Tools")
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
                // rectangle mode
                id: rectangleModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/rectangleTool.svg"
                property Item geometryMode: geometryTool.rectangleMode
                onButtonClicked: {
                    geometryToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // square mode
                id: squareModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/squareTool.svg"
                property Item geometryMode: geometryTool.squareMode
                onButtonClicked: {
                    geometryToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // oval mode
                id: ovalModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/ovalTool.svg"
                property Item geometryMode: geometryTool.ovalMode
                onButtonClicked: {
                    geometryToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // circle mode
                id: circleModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/circleTool.svg"
                property Item geometryMode: geometryTool.circleMode
                onButtonClicked: {
                    geometryToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // freeLineMode mode
                id: freeLineModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/freeLineTool.svg"
                property Item geometryMode: geometryTool.freeLineMode
                onButtonClicked: {
                    geometryToolSettings.selectMode(self)
                }
            }
            SelectionButton {
                // hortoLine mode
                id: hortoLineModeButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/hortoLineTool.svg"
                property Item geometryMode: geometryTool.hortoLineMode
                onButtonClicked: {
                    geometryToolSettings.selectMode(self)
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
                geometryToolSettings.reloadDefaultModeSettings()
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
                value: 0.5
                source: selectedModeButton.iconSource ? selectedModeButton.iconSource : ""
                sourceRotation: geometryToolSettings.modeIconRotation
                useImageInfo: true
                onSliderMoved: {
                    geometryToolSettings.setOpacitySettings()
                }
            }

            SliderSettings {
                id: radiusSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Rounded Corners")
                from: 0
                to: 100
                stepSize: 1
                value: 0
                onSliderMoved: {
                    geometryToolSettings.setRadiusSettings()
                }
            }

            SliderSettings {
                id: rotationSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Rotation")
                from: 0
                to: 90
                stepSize: 5
                value: 0
                onSliderMoved: {
                    geometryToolSettings.setRotationSettings()
                }
            }

            SliderSettings {
                id: lineWidthSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Size")
                from: 1
                to: 50
                stepSize: 1
                value: 0
                onSliderMoved: {
                    geometryToolSettings.setLineWidthSettings()
                }
            }
        }
    }
}
