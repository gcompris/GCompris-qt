/* GCompris - StampToolSettings.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic
import "../../core"

Item {
    id: stampToolSettings
    visible: false

    property Item selectedModeButton: modeList.currentItem
    property alias modeIconOpacity: opacitySlider.value
    property alias modeIconRotation: rotationSlider.value
    property alias modeIconMirror: mirrorButton.checked
    property alias selectedStampIndex: modeList.currentIndex

    onSelectedStampIndexChanged: {
        setStampIndex()
    }

    function loadOpacitySettings() {
        opacitySlider.value = stampTool.toolOpacity
    }

    function setOpacitySettings() {
        stampTool.toolOpacity = opacitySlider.value
    }

    function loadRotationSettings() {
        rotationSlider.value = stampTool.toolRotation
    }

    function setRotationSettings() {
        stampTool.toolRotation = rotationSlider.value
    }

    function loadSizeSettings() {
        sizeSlider.value = stampTool.toolSize
    }

    function setMirrorSettings() {
        stampTool.toolMirror = mirrorButton.checked
    }

    function loadMirrorSettings() {
        mirrorButton.checked = stampTool.toolMirror
    }

    function setSizeSettings() {
        stampTool.toolSize = sizeSlider.value
    }

    function loadStampIndex() {
        modeList.currentIndex = stampTool.selectedStampIndex
    }

    function setStampIndex() {
        stampTool.selectedStampIndex = modeList.currentIndex
    }

    // Triggered when selecting the tool
    function setToolMode() {
        loadModeSettings()
    }

    function loadModeSettings() {
        loadStampIndex()
        loadOpacitySettings()
        loadRotationSettings()
        loadMirrorSettings()
        loadSizeSettings()
    }

    // Reload default settings values
    function reloadDefaultSettings() {
        stampTool.toolOpacity = stampTool.defaultToolOpacity
        stampTool.toolRotation = stampTool.defaultToolRotation
        stampTool.toolMirror = stampTool.defaultToolMirror
        stampTool.toolSize = stampTool.defaultToolSize

        // then load again the settings to the panel
        loadModeSettings()
    }

    GCText {
        id: toolTitle
        text: qsTr("Stamp Tool")
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

        GridView {
            id: modeList
            anchors.fill: parent
            cellHeight: toolsPanel.stampButtonsSize
            cellWidth: toolsPanel.stampButtonsSize
            currentIndex: 0
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: stampTool.stamps
            delegate: SelectionButton {
                buttonSize: toolsPanel.stampButtonsSize
                isButtonSelected: index == modeList.currentIndex
                iconSource: modelData
                onButtonClicked: modeList.currentIndex = index
                Rectangle {
                    z: -1
                    anchors.fill: parent
                    anchors.margins: items.baseMargins
                    color: items.contentColor
                    opacity: 0.3
                    radius: items.baseMargins
                }
            }
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }
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
                stampToolSettings.reloadDefaultSettings()
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
                source: stampTool.stamps[selectedStampIndex]
                sourceRotation: rotationSlider.value
                sourceMirror: mirrorButton.checked
                useImageInfo: true
                onSliderMoved: {
                    stampToolSettings.setOpacitySettings()
                }
            }

            SliderSettings {
                id: sizeSlider
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                controlsHeight: toolsPanel.settingsLineHeight
                labelText: qsTr("Size")
                from: 10
                to: 500
                stepSize: 10
                value: 100
                onSliderMoved: {
                    stampToolSettings.setSizeSettings()
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
                    stampToolSettings.setRotationSettings()
                }
            }

            DarkCheckBox {
                id: mirrorButton
                width: toolsPanel.settingsColumnWidth
                height: toolsPanel.settingsDoubleLineHeight
                checked: false
                text: qsTr("Mirror image")
                onCheckedChanged: {
                    stampToolSettings.setMirrorSettings()
                }
            }
        }
    }
}
