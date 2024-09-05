/* GCompris - TextToolSettings.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: textToolSettings
    visible: false

    property Item selectedModeButton: Item { property string iconSource: "qrc:/gcompris/src/activities/sketch/resource/textMode.svg" }
    property alias modeIconOpacity: opacitySlider.value
    property alias modeIconRotation: rotationSlider.value
    property bool modeIconMirror: false
    property alias textString: textEdit.text
    property alias textEdit: textEdit

    onTextStringChanged: {
        setTextSource()
    }

    function loadOpacitySettings() {
        opacitySlider.value = textTool.toolOpacity
    }

    function setOpacitySettings() {
        textTool.toolOpacity = opacitySlider.value
    }

    function loadRotationSettings() {
        rotationSlider.value = textTool.toolRotation
    }

    function setRotationSettings() {
        textTool.toolRotation = rotationSlider.value
    }

    function loadSizeSettings() {
        sizeSlider.value = textTool.toolSize
    }

    function setSizeSettings() {
        textTool.toolSize = sizeSlider.value
    }

    function loadTextSource() {
        textString = textTool.textString
    }

    function setTextSource() {
        textTool.textString = textString
    }

    // Triggered when selecting the tool
    function setToolMode() {
        loadModeSettings()
    }

    function loadModeSettings() {
        loadTextSource()
        loadOpacitySettings()
        loadRotationSettings()
        loadSizeSettings()
    }

    // Reload default settings values
    function reloadDefaultSettings() {
        textTool.toolOpacity = textTool.defaultToolOpacity
        textTool.toolRotation = textTool.defaultToolRotation
        textTool.toolSize = textTool.defaultToolSize
        textTool.textString = ""

        // then load again the settings to the panel
        loadModeSettings()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: textEdit.focus = false
    }

    GCText {
        id: toolTitle
        text: qsTr("Text Tool")
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
        anchors.bottom: resetToolArea.top
        anchors.bottomMargin: items.baseMargins

        GCText {
            id: textInputTitle
            text: qsTr("Type your text here")
            color: items.contentColor
            width: parent.width
            height: toolsPanel.settingsLineHeight
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignBottom
        }

        Rectangle {
            anchors.top: textInputTitle.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: items.baseMargins
            color: "#20FFFFFF"
            radius: items.baseMargins

            TextEdit {
                id: textEdit
                anchors.fill: parent
                anchors.margins: items.baseMargins
                wrapMode: TextEdit.Wrap
                font.pointSize: 20
                color: items.contentColor
                selectionColor: items.panelColor
            }
        }
    }

    Item {
        id: resetToolArea
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
                textToolSettings.reloadDefaultSettings()
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
                source: "qrc:/gcompris/src/activities/sketch/resource/textMode.svg"
                sourceRotation: rotationSlider.value
                useImageInfo: true
                onSliderMoved: {
                    textToolSettings.setOpacitySettings()
                }
            }

            SliderSettings {
                id: sizeSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Size")
                from: 10
                to: 100
                stepSize: 1
                value: 100
                onSliderMoved: {
                    textToolSettings.setSizeSettings()
                }
            }

            SliderSettings {
                id: rotationSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Rotation")
                from: 0
                to: 360
                stepSize: 15
                value: 1
                onSliderMoved: {
                    textToolSettings.setRotationSettings()
                }
            }
        }
    }
}

