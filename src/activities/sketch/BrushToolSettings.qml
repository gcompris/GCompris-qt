/* GCompris - BrushToolSettings.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: brushToolSettings
    visible: false

    property Item selectedModeButton: roundBrushButton // NOTE init default value on start
    property alias modeIconOpacity: opacitySlider.value
    property int modeIconRotation: 0
    property bool modeIconMirror: false

    // Load opacity settings from selected brush mode
    function loadOpacitySettings() {
        if(items.eraserMode)
            opacitySlider.value = brushTool.selectedMode.eraserBrushOpacity
        else
            opacitySlider.value = brushTool.selectedMode.brushOpacity
    }

    // Set opacity setting to selected brush mode
    function setOpacitySettings() {
        if(items.eraserMode)
            brushTool.selectedMode.eraserBrushOpacity = opacitySlider.value
        else
            brushTool.selectedMode.brushOpacity = opacitySlider.value
    }

    // Load size settings from selected brush mode
    function loadSizeSettings() {
        sizeSlider.from = brushTool.selectedMode.minBrushSize
        sizeSlider.to = brushTool.selectedMode.maxBrushSize
        sizeSlider.stepSize = brushTool.selectedMode.sizeSliderStepSize
        if(items.eraserMode)
            sizeSlider.value = brushTool.selectedMode.eraserBrushSize
        else
            sizeSlider.value = brushTool.selectedMode.brushSize
    }

    // Set size setting to selected brush mode
    function setSizeSettings() {
        if(items.eraserMode)
            brushTool.selectedMode.eraserBrushSize = sizeSlider.value
        else
            brushTool.selectedMode.brushSize = sizeSlider.value
    }

    // Load speed settings from selected brush mode
    function loadSpeedSettings() {
        if(brushTool.selectedMode.speed == null) {
            speedSlider.visible = false
        } else {
            speedSlider.visible = true
            if(items.eraserMode)
                speedSlider.value = brushTool.selectedMode.eraserSpeed
            else
                speedSlider.value = brushTool.selectedMode.speed
        }
    }

    // Set speed setting to selected brush mode
    function setSpeedSettings() {
        if(brushTool.selectedMode.speed == null)
            return
        if(items.eraserMode)
            brushTool.selectedMode.eraserSpeed = speedSlider.value
        else
            brushTool.selectedMode.speed = speedSlider.value
    }

    // Load density settings from selected brush mode
    function loadDensitySettings() {
        if(brushTool.selectedMode.density == null) {
            densitySlider.visible = false
        } else {
            densitySlider.visible = true
            if(items.eraserMode)
                densitySlider.value = brushTool.selectedMode.eraserDensity
            else
                densitySlider.value = brushTool.selectedMode.brushDensity
        }
    }

    // Set speed setting to selected brush mode
    function setDensitySettings() {
        if(brushTool.selectedMode.density == null)
            return
        if(items.eraserMode)
            brushTool.selectedMode.eraserDensity = densitySlider.value
        else
            brushTool.selectedMode.brushDensity = densitySlider.value
    }

    // Load dotsSize settings from selected brush mode
    function loadDotsSizeSettings() {
        if(brushTool.selectedMode.dotsSize == null) {
            dotsSizeSlider.visible = false
        } else {
            dotsSizeSlider.visible = true
            if(items.eraserMode)
                dotsSizeSlider.value = brushTool.selectedMode.eraserDotsSize
            else
                dotsSizeSlider.value = brushTool.selectedMode.dotsSize
        }
    }

    // Set dotsSize setting to selected brush mode
    function setDotsSizeSettings() {
        if(brushTool.selectedMode.dotsSize == null)
            return
        if(items.eraserMode)
            brushTool.selectedMode.eraserDotsSize = dotsSizeSlider.value
        else
            brushTool.selectedMode.dotsSize = dotsSizeSlider.value
    }

    // Load smoothing settings from selected brush mode
    function loadSmoothingSettings() {
        if(brushTool.selectedMode.brushSmoothing == null) {
            smoothingSlider.visible = false
        } else {
            smoothingSlider.visible = true
            if(items.eraserMode)
                smoothingSlider.value = brushTool.selectedMode.eraserSmoothing
            else
                smoothingSlider.value = brushTool.selectedMode.brushSmoothing
        }
    }

    // Set dotsSize setting to selected brush mode
    function setSmoothingSettings() {
        if(brushTool.selectedMode.brushSmoothing == null)
            return
        if(items.eraserMode)
            brushTool.selectedMode.eraserSmoothing = smoothingSlider.value
        else
            brushTool.selectedMode.brushSmoothing = smoothingSlider.value
    }

    // Load pattern settings from selected brush mode
    function loadPatternSettings() {
        if(brushTool.selectedMode.brushPattern == null) {
            patternSelector.visible = false
        } else {
            patternSelector.visible = true
            if(items.eraserMode)
                patternSelector.value = brushTool.selectedMode.eraserPattern
            else
                patternSelector.value = brushTool.selectedMode.brushPattern
        }
    }

    // Set pattern setting to selected brush mode
    function setPatternSettings() {
        if(brushTool.selectedMode.brushPattern == null)
            return
        if(items.eraserMode)
            brushTool.selectedMode.eraserPattern = patternSelector.value
        else
            brushTool.selectedMode.brushPattern = patternSelector.value
    }

    // Load all settings from selected brush mode
    function loadModeSettings() {
        loadOpacitySettings()
        loadSizeSettings()
        loadSpeedSettings()
        loadDensitySettings()
        loadDotsSizeSettings()
        loadSmoothingSettings()
        loadPatternSettings()
    }

    // Set selected mode on brush tool
    function setToolMode() {
        brushTool.selectedMode = selectedModeButton.brushMode
        loadModeSettings()
    }

    // Save selected mode for current tool (brush or eraser), then call setToolMode
    function selectMode(modeButton) {
        selectedModeButton = modeButton
        setToolMode()
    }

    // Reload default values for selected tool mode
    function reloadDefaultModeSettings() {
        // opacity, size
        if(items.eraserMode) {
            brushTool.selectedMode.eraserBrushOpacity = brushTool.selectedMode.defaultEraserBrushOpacity
            brushTool.selectedMode.eraserBrushSize = brushTool.selectedMode.defaultEraserBrushSize
            if(brushTool.selectedMode.eraserSpeed != null)
                brushTool.selectedMode.eraserSpeed = brushTool.selectedMode.defaultEraserSpeed
            if(brushTool.selectedMode.eraserDensity != null)
                brushTool.selectedMode.eraserDensity = brushTool.selectedMode.defaultEraserDensity
            if(brushTool.selectedMode.eraserDotsSize != null)
                brushTool.selectedMode.eraserDotsSize = brushTool.selectedMode.defaultEraserDotsSize
            if(brushTool.selectedMode.eraserSmoothing != null)
                brushTool.selectedMode.eraserSmoothing = brushTool.selectedMode.defaultEraserSmoothing
            if(brushTool.selectedMode.eraserPattern != null)
                brushTool.selectedMode.eraserPattern = brushTool.selectedMode.defaultEraserPattern
        } else {
            brushTool.selectedMode.brushOpacity = brushTool.selectedMode.defaultBrushOpacity
            brushTool.selectedMode.brushSize = brushTool.selectedMode.defaultBrushSize
            if(brushTool.selectedMode.speed != null)
                brushTool.selectedMode.speed = brushTool.selectedMode.defaultSpeed
            if(brushTool.selectedMode.brushDensity != null)
                brushTool.selectedMode.brushDensity = brushTool.selectedMode.defaultBrushDensity
            if(brushTool.selectedMode.dotsSize != null)
                brushTool.selectedMode.dotsSize = brushTool.selectedMode.defaultDotsSize
            if(brushTool.selectedMode.brushSmoothing != null)
                brushTool.selectedMode.brushSmoothing = brushTool.selectedMode.defaultBrushSmoothing
            if(brushTool.selectedMode.brushPattern != null)
                brushTool.selectedMode.brushPattern = brushTool.selectedMode.defaultBrushPattern
        }

        // then load again the settings to the panel
        loadModeSettings()
    }

    GCText {
        id: toolTitle
        text: items.eraserMode ? qsTr("Eraser Tools") : qsTr("Drawing Tools")
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
                // roundBrush
                id: roundBrushButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/roundBrush.svg"
                property Item brushMode: brushTool.roundBrush
                onButtonClicked: {
                    brushToolSettings.selectMode(self)
                }
            }

            SelectionButton {
                // sketchBrush
                id: sketchBrushButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/sketchBrush.svg"
                property Item brushMode: brushTool.sketchBrush
                onButtonClicked: {
                    brushToolSettings.selectMode(self)
                }
            }

            SelectionButton {
                // fillBrush
                id: fillBrushButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/fillBrush.svg"
                property Item brushMode: brushTool.fillBrush
                onButtonClicked: {
                    brushToolSettings.selectMode(self)
                }
            }

            SelectionButton {
                // airBrush
                id: airBrushButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/airBrush.svg"
                property Item brushMode: brushTool.airBrush
                onButtonClicked: {
                    brushToolSettings.selectMode(self)
                }
            }

            SelectionButton {
                // sprayBrush
                id: sprayBrushButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/sprayBrush.svg"
                property Item brushMode: brushTool.sprayBrush
                onButtonClicked: {
                    brushToolSettings.selectMode(self)
                }
            }

            SelectionButton {
                // circlesBrush
                id: circlesBrushButton
                buttonSize: toolsPanel.modeButtonsSize
                isButtonSelected: selectedModeButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/circlesBrush.svg"
                property Item brushMode: brushTool.circlesBrush
                onButtonClicked: {
                    brushToolSettings.selectMode(self)
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
                brushToolSettings.reloadDefaultModeSettings()
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
                value: 0.5 // NOTE init default values on start (value; others are fixed anyway)
                source: selectedModeButton.iconSource ? selectedModeButton.iconSource : ""
                useImageInfo: true
                onSliderMoved: {
                    brushToolSettings.setOpacitySettings()
                }
            }

            SliderSettings {
                id: sizeSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Size")
                from: 1 // NOTE init default values on start (from, to, stepSize, value)
                to: 100
                stepSize: 1
                value: 5
                onSliderMoved: {
                    brushToolSettings.setSizeSettings()
                }
            }

            SliderSettings {
                id: speedSlider
                visible: false // NOTE init default values on start (roundBrush doesn't have speed setting)
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Speed")
                from: 1
                to: 10
                stepSize: 1
                value: 6
                onSliderMoved: {
                    brushToolSettings.setSpeedSettings()
                }
            }

            SliderSettings {
                id: densitySlider
                visible: false // NOTE init default values on start (roundBrush doesn't have speed setting)
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Density")
                from: 1
                to: 10
                stepSize: 1
                value: 5
                onSliderMoved: {
                    brushToolSettings.setDensitySettings()
                }
            }

            SliderSettings {
                id: dotsSizeSlider
                visible: false // NOTE init default values on start (roundBrush doesn't have dotsSize setting)
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Dots Size")
                from: 1
                to: 10
                stepSize: 1
                value: 2
                onSliderMoved: {
                    brushToolSettings.setDotsSizeSettings()
                }
            }

            SliderSettings {
                id: smoothingSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Smoothing")
                from: 1
                to: 5
                stepSize: 1
                value: 2 // NOTE init default values on start (value; others are fixed anyway)
                onSliderMoved: {
                    brushToolSettings.setSmoothingSettings()
                }
            }

            PatternSelector {
                id: patternSelector
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                value: 0
                onPatternClicked: {
                    brushToolSettings.setPatternSettings()
                }
            }
        }
    }
}
