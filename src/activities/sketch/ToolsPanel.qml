/* GCompris - ToolsPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

FoldablePanel {
    id: toolsPanel
    icon1Source: toolButtonsGrid.selectedButton.iconSource
    icon2Source: activeToolPanel.selectedModeButton.iconSource
    icon2Opacity: opacitySlider.value
    icon2Rotation: rotationSlider.visible ? rotationSlider.value : 0
    icon2Mirror: mirrorButton.visible ? mirrorButton.checked : false

    readonly property int settingsColumnWidth: (settingsArea.width - ApplicationInfo.ratio - items.baseMargins * 2) * 0.5
    readonly property int settingsLineHeight: (settingsArea.height - 6 * items.baseMargins) * 0.1
    readonly property int settingsDoubleLineHeight: settingsLineHeight * 2
    readonly property int modeButtonsSize: Math.min(
        (settingsColumnWidth - items.baseMargins * 2) * 0.33,
        (settingsArea.height - items.baseMargins * 3 - settingsLineHeight * 3) * 0.5)

    readonly property int stampButtonsSize: (settingsColumnWidth - items.baseMargins * 2) * 0.25

    property Item activeToolPanel: brushToolPanel

    MouseArea {
        anchors.fill: parent
        onClicked: textToolPanel.textEdit.focus = false;
    }

    onClose: {
        textToolPanel.textEdit.focus = false;
        canvasArea.init();
    }

    // NOTE: check eraserMode only in functions related to settings used in brush/eraser tools

    function loadOpacitySettings() {
        // All tools have opacity setting
        if(items.eraserMode) {
            opacitySlider.value = items.selectedTool.selectedMode.eraserOpacity;
        } else {
            opacitySlider.value = items.selectedTool.selectedMode.toolOpacity;
        }
    }

    function loadSizeSettings() {
        if(items.selectedTool.selectedMode.toolSize == null) {
            sizeSlider.visible = false;
        } else {
            sizeSlider.visible = true;
            sizeSlider.from = items.selectedTool.selectedMode.minToolSize;
            sizeSlider.to = items.selectedTool.selectedMode.maxToolSize;
            sizeSlider.stepSize = items.selectedTool.selectedMode.sizeSliderStepSize;
            if(items.eraserMode) {
                sizeSlider.value = items.selectedTool.selectedMode.eraserSize;
            } else {
                sizeSlider.value = items.selectedTool.selectedMode.toolSize;
            }
        }
    }

    function loadSpeedSettings() {
        if(items.selectedTool.selectedMode.toolSpeed == null) {
            speedSlider.visible = false;
        } else {
            speedSlider.visible = true;
            if(items.eraserMode) {
                speedSlider.value = items.selectedTool.selectedMode.eraserSpeed;
            } else {
                speedSlider.value = items.selectedTool.selectedMode.toolSpeed;
            }
        }
    }

    function loadDensitySettings() {
        if(items.selectedTool.selectedMode.toolDensity == null) {
            densitySlider.visible = false;
        } else {
            densitySlider.visible = true;
            if(items.eraserMode) {
                densitySlider.value = items.selectedTool.selectedMode.eraserDensity;
            } else {
                densitySlider.value = items.selectedTool.selectedMode.toolDensity;
            }
        }
    }


    function loadDotsSizeSettings() {
        if(items.selectedTool.selectedMode.dotsSize == null) {
            dotsSizeSlider.visible = false;
        } else {
            dotsSizeSlider.visible = true;
            if(items.eraserMode) {
                dotsSizeSlider.value = items.selectedTool.selectedMode.eraserDotsSize;
            } else {
                dotsSizeSlider.value = items.selectedTool.selectedMode.dotsSize;
            }
        }
    }


    function loadSmoothingSettings() {
        if(items.selectedTool.selectedMode.toolSmoothing == null) {
            smoothingSlider.visible = false;
        } else {
            smoothingSlider.visible = true;
            if(items.eraserMode) {
                smoothingSlider.value = items.selectedTool.selectedMode.eraserSmoothing;
            } else {
                smoothingSlider.value = items.selectedTool.selectedMode.toolSmoothing;
            }
        }
    }


    function loadPatternSettings() {
        if(items.selectedTool.selectedMode.toolPattern == null) {
            patternSelector.visible = false;
        } else {
            patternSelector.visible = true;
            if(items.eraserMode) {
                patternSelector.value = items.selectedTool.selectedMode.eraserPattern;
            } else {
                patternSelector.value = items.selectedTool.selectedMode.toolPattern;
            }
        }
    }

    function loadRadiusSettings() {
        if(items.selectedTool.selectedMode.toolRadius == null) {
            radiusSlider.visible = false;
        } else {
            radiusSlider.visible = true;
            radiusSlider.to = items.selectedTool.selectedMode.maxToolRadius;
            radiusSlider.labelText = items.selectedTool.radiusString;
            radiusSlider.value = items.selectedTool.selectedMode.toolRadius;
        }
    }

    function loadRotationSettings() {
        if(items.selectedTool.selectedMode.toolRotation == null) {
            rotationSlider.visible = false;
        } else {
            rotationSlider.visible = true;
            rotationSlider.to = items.selectedTool.selectedMode.maxToolRotation;
            rotationSlider.stepSize = items.selectedTool.selectedMode.rotationSliderStepSize;
            rotationSlider.value = items.selectedTool.selectedMode.toolRotation;
        }
    }

    function loadMirrorSettings() {
        if(items.selectedTool.selectedMode.toolMirror == null) {
            mirrorButton.visible = false;
        } else {
            mirrorButton.visible = true;
            mirrorButton.checked = items.selectedTool.selectedMode.toolMirror;
        }
    }

    // Load all settings from selected tool mode
    function loadModeSettings() {
        loadOpacitySettings();
        loadSizeSettings();
        loadSpeedSettings();
        loadDensitySettings();
        loadDotsSizeSettings();
        loadSmoothingSettings();
        loadPatternSettings();
        loadRadiusSettings();
        loadRotationSettings();
        loadMirrorSettings();
    }

    // Reload default values for selected tool mode
    function reloadDefaultModeSettings() {
        if(items.eraserMode) {
            items.selectedTool.selectedMode.eraserOpacity = items.selectedTool.selectedMode.defaultEraserOpacity;
            items.selectedTool.selectedMode.eraserSize = items.selectedTool.selectedMode.defaultEraserSize;
            if(items.selectedTool.selectedMode.eraserSpeed != null) {
                items.selectedTool.selectedMode.eraserSpeed = items.selectedTool.selectedMode.defaultEraserSpeed;
            }
            if(items.selectedTool.selectedMode.eraserDensity != null) {
                items.selectedTool.selectedMode.eraserDensity = items.selectedTool.selectedMode.defaultEraserDensity;
            }
            if(items.selectedTool.selectedMode.eraserDotsSize != null) {
                items.selectedTool.selectedMode.eraserDotsSize = items.selectedTool.selectedMode.defaultEraserDotsSize;
            }
            if(items.selectedTool.selectedMode.eraserSmoothing != null) {
                items.selectedTool.selectedMode.eraserSmoothing = items.selectedTool.selectedMode.defaultEraserSmoothing;
            }
            if(items.selectedTool.selectedMode.eraserPattern != null) {
                items.selectedTool.selectedMode.eraserPattern = items.selectedTool.selectedMode.defaultEraserPattern;
            }
        } else {
            items.selectedTool.selectedMode.toolOpacity = items.selectedTool.selectedMode.defaultToolOpacity;
            if(items.selectedTool.selectedMode.toolSize != null) {
                items.selectedTool.selectedMode.toolSize = items.selectedTool.selectedMode.defaultToolSize;
            }
            if(items.selectedTool.selectedMode.toolSpeed != null) {
                items.selectedTool.selectedMode.toolSpeed = items.selectedTool.selectedMode.defaultToolSpeed;
            }
            if(items.selectedTool.selectedMode.toolDensity != null) {
                items.selectedTool.selectedMode.toolDensity = items.selectedTool.selectedMode.defaultToolDensity;
            }
            if(items.selectedTool.selectedMode.dotsSize != null) {
                items.selectedTool.selectedMode.dotsSize = items.selectedTool.selectedMode.defaultDotsSize;
            }
            if(items.selectedTool.selectedMode.toolSmoothing != null) {
                items.selectedTool.selectedMode.toolSmoothing = items.selectedTool.selectedMode.defaultToolSmoothing;
            }
            if(items.selectedTool.selectedMode.toolPattern != null) {
                items.selectedTool.selectedMode.toolPattern = items.selectedTool.selectedMode.defaultToolPattern;
            }
            if(items.selectedTool.selectedMode.toolRadius!= null) {
                items.selectedTool.selectedMode.toolRadius = items.selectedTool.selectedMode.defaultToolRadius;
            }
            if(items.selectedTool.selectedMode.toolRotation != null) {
                items.selectedTool.selectedMode.toolRotation = items.selectedTool.selectedMode.defaultToolRotation;
            }
            if(items.selectedTool.selectedMode.toolMirror != null) {
                items.selectedTool.selectedMode.toolMirror = false;
            }
            if(items.selectedTool == textTool) {
                textToolPanel.textEdit.text = "";
            }
        }

        // then load again the settings to the panel
        loadModeSettings();
    }



    Item {
        id: toolsArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: items.baseMargins
        height: toolButtonsSize

        property int toolButtonsSize: Math.min((toolButtonsGrid.width - items.baseMargins * 5) * 0.16,
                                               60 * ApplicationInfo.ratio)

        GCText {
            id: toolsLabel
            text: qsTr("Tools")
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

        Grid {
            id: toolButtonsGrid
            spacing: items.baseMargins
            columns: 6
            rows: 1
            height: parent.height
            width: parent.width * 0.75 - items.baseMargins
            anchors.left: toolsLabel.right
            anchors.leftMargin: items.baseMargins

            property Item selectedButton: brushToolButton // NOTE init default value on start

            function selectTool(buttonToSelect, toolPanelToSelect, toolToSelect, isEraserTool = false) {
                toolsPanel.activeToolPanel.visible = false;
                scrollSound.play();
                selectedButton = buttonToSelect;
                items.selectedTool = null;
                items.eraserMode = isEraserTool;
                items.selectedTool = toolToSelect;
                toolsPanel.activeToolPanel = toolPanelToSelect;
                toolsPanel.activeToolPanel.visible = true;
                toolsPanel.activeToolPanel.setToolMode();
            }

            SelectionButton {
                id: brushToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/brushTools.svg"
                onButtonClicked: {
                    parent.selectTool(self, brushToolPanel, brushTool);
                }
            }

            SelectionButton {
                id: geometryToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/geometryTools.svg"
                onButtonClicked: {
                    parent.selectTool(self, geometryToolPanel, geometryTool);
                }
            }

            SelectionButton {
                id: gradientToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/gradientTools.svg"
                onButtonClicked: {
                    parent.selectTool(self, gradientToolPanel, gradientTool);
                }
            }

            SelectionButton {
                id: stampToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/stampTools.svg"
                onButtonClicked: {
                    parent.selectTool(self, stampToolPanel, stampTool);
                }
            }

            SelectionButton {
                id: textToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/textTools.svg"
                onButtonClicked: {
                    parent.selectTool(self, textToolPanel, textTool);
                }
            }

            SelectionButton {
                id: eraserToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/eraserTools.svg"
                onButtonClicked: {
                    parent.selectTool(self, eraserToolPanel, brushTool, true);
                }
            }
        }
    }

    Rectangle {
        id: panelVerticalSpacer
        color: items.contentColor
        opacity: 0.5
        height: ApplicationInfo.ratio
        anchors.top: toolsArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: items.baseMargins
    }

    Item {
        id: settingsArea
        anchors.top: panelVerticalSpacer.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: items.baseMargins

        GCText {
            id: toolTitle
            text: toolsPanel.activeToolPanel.toolTitle
            color: items.contentColor
            width: toolsPanel.settingsColumnWidth
            height: toolsPanel.settingsLineHeight
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: toolPanelArea
            width: toolsPanel.settingsColumnWidth
            anchors.top: toolTitle.bottom
            anchors.topMargin: items.baseMargins
            anchors.left: parent.left
            anchors.bottom: resetButtonArea.top

            BrushToolPanel {
                id: brushToolPanel
                visible: true // NOTE init default value on start
            }

            GeometryToolPanel {
                id: geometryToolPanel
            }

            GradientToolPanel{
                id: gradientToolPanel
            }

            StampToolPanel {
                id: stampToolPanel
            }

            TextToolPanel {
                id: textToolPanel
            }

            BrushToolPanel {
                id: eraserToolPanel
                anchors.fill: parent
            }

        }

        Item {
            id: resetButtonArea
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
                    toolsPanel.reloadDefaultModeSettings();
                }
            }
        }

        Rectangle {
            id: horizontalSpacer
            color: items.contentColor
            opacity: 0.5
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: toolPanelArea.right
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

                // Not more than 5 settings visible for a tool; current max. is 4
                // visible values on start set according to roundBrush drawing tool
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
                    source: toolsPanel.activeToolPanel.selectedModeButton.iconSource ? toolsPanel.activeToolPanel.selectedModeButton.iconSource : ""
                    sourceRotation: toolsPanel.icon2Rotation
                    sourceMirror: toolsPanel.icon2Mirror
                    useImageInfo: true
                    onSliderMoved: {
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserOpacity = value;
                        } else {
                            items.selectedTool.selectedMode.toolOpacity = value;
                        }
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
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserSize = value;
                        } else {
                            items.selectedTool.selectedMode.toolSize = value;
                        }
                    }
                }

                SliderSettings {
                    id: speedSlider
                    visible: false // NOTE init default values on start
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsDoubleLineHeight
                    controlsHeight: toolsPanel.settingsLineHeight
                    labelText: qsTr("Speed")
                    from: 1
                    to: 10
                    stepSize: 1
                    value: 6
                    onSliderMoved: {
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserSpeed = value;
                        } else {
                            items.selectedTool.selectedMode.toolSpeed = value;
                        }
                    }
                }

                SliderSettings {
                    id: densitySlider
                    visible: false // NOTE init default values on start
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsDoubleLineHeight
                    controlsHeight: toolsPanel.settingsLineHeight
                    labelText: qsTr("Density")
                    from: 1
                    to: 10
                    stepSize: 1
                    value: 5
                    onSliderMoved: {
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserDensity = value;
                        } else {
                            items.selectedTool.selectedMode.toolDensity = value;
                        }
                    }
                }

                SliderSettings {
                    id: dotsSizeSlider
                    visible: false // NOTE init default values on start
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsDoubleLineHeight
                    controlsHeight: toolsPanel.settingsLineHeight
                    labelText: qsTr("Dots Size")
                    from: 1
                    to: 10
                    stepSize: 1
                    value: 2
                    onSliderMoved: {
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserDotsSize = value;
                        } else {
                            items.selectedTool.selectedMode.dotsSize = value;
                        }
                    }
                }

                SliderSettings {
                    id: smoothingSlider
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsDoubleLineHeight
                    controlsHeight: toolsPanel.settingsLineHeight
                    labelText: qsTr("Smoothing")
                    from: 0
                    to: 5
                    stepSize: 1
                    value: ApplicationInfo.isMobile ? 0 : 1 // NOTE init default values on start (value; others are fixed anyway)
                    onSliderMoved: {
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserSmoothing = value;
                        } else {
                            items.selectedTool.selectedMode.toolSmoothing = value;
                        }
                    }
                }

                // Takes 1.5 height compared to Sliders...
                GCText {
                    id: patternLabel
                    visible: patternSelector.visible
                    text: "Pattern"
                    color: items.contentColor
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsLineHeight
                    fontSize: regularSize
                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignBottom
                }
                PatternSelector {
                    id: patternSelector
                    width: toolsPanel.settingsColumnWidth
                    value: 0 // NOTE init default values on start
                    onPatternClicked: {
                        if(items.eraserMode) {
                            items.selectedTool.selectedMode.eraserPattern = value;
                        } else {
                            items.selectedTool.selectedMode.toolPattern = value;
                        }
                    }
                }
                //

                SliderSettings {
                    id: radiusSlider
                    visible: false // NOTE init default values on start
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsDoubleLineHeight
                    controlsHeight: toolsPanel.settingsLineHeight
                    from: 0
                    to: 100
                    stepSize: 5
                    value: 0
                    onSliderMoved: {
                        items.selectedTool.selectedMode.toolRadius = value;
                    }
                }

                SliderSettings {
                    id: rotationSlider
                    visible: false // NOTE init default values on start
                    width: toolsPanel.settingsColumnWidth
                    height: toolsPanel.settingsDoubleLineHeight
                    controlsHeight: toolsPanel.settingsLineHeight
                    labelText: qsTr("Rotation")
                    from: 0
                    to: 180
                    stepSize: 5
                    value: 0
                    onSliderMoved: {
                        items.selectedTool.selectedMode.toolRotation = value;
                    }
                }

                DarkCheckBox {
                    id: mirrorButton
                    visible: false // NOTE init default values on start
                    width: toolsPanel.settingsColumnWidth
                    height: Math.min(toolsPanel.modeButtonsSize, toolsPanel.settingsDoubleLineHeight)
                    checked: false
                    labelText: qsTr("Mirror image")
                    onCheckedChanged: {
                        items.selectedTool.selectedMode.toolMirror = checked;
                    }
                }
            }
        }
    }
}


