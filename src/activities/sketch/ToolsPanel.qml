/* GCompris - ToolsPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

FoldablePanel {
    id: toolsPanel
    icon1Source: toolButtonsGrid.selectedButton.iconSource
    icon2Source: toolButtonsGrid.selectedButton.toolSettingsPanel.selectedModeButton.iconSource
    icon2Opacity: toolButtonsGrid.selectedButton.toolSettingsPanel.modeIconOpacity
    icon2Rotation: toolButtonsGrid.selectedButton.toolSettingsPanel.modeIconRotation
    icon2Mirror: toolButtonsGrid.selectedButton.toolSettingsPanel.modeIconMirror

    property int settingsColumnWidth: (settingsArea.width - ApplicationInfo.ratio - items.baseMargins * 2) * 0.5
    property int settingsLineHeight: (settingsArea.height - 6 * items.baseMargins) * 0.1
    property int settingsDoubleLineHeight: settingsLineHeight * 2
    property int modeButtonsSize: Math.min(
        (settingsColumnWidth - items.baseMargins * 2) * 0.33,
        (settingsArea.height - items.baseMargins * 3 - settingsLineHeight * 3) * 0.5)

    property int stampButtonsSize: (settingsColumnWidth - items.baseMargins * 2) * 0.25


    onClose: {
        textToolSettings.textEdit.focus = false
        canvasArea.init()
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

            function selectTool(buttonToSelect, toolToSelect, isEraserTool = false) {
                selectedButton.toolSettingsPanel.visible = false
                scrollSound.play()
                selectedButton = buttonToSelect
                items.selectedTool = null
                items.eraserMode = isEraserTool
                items.selectedTool = toolToSelect
                selectedButton.toolSettingsPanel.visible = true
                selectedButton.toolSettingsPanel.setToolMode()
            }

            SelectionButton {
                id: brushToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/brushTools.svg"
                property alias toolSettingsPanel: brushToolSettings
                onButtonClicked: {
                    parent.selectTool(self, brushTool)
                }
            }

            SelectionButton {
                id: geometryToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/geometryTools.svg"
                property alias toolSettingsPanel: geometryToolSettings
                onButtonClicked: {
                    parent.selectTool(self, geometryTool)
                }
            }

            SelectionButton {
                id: gradientToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/gradientTools.svg"
                property alias toolSettingsPanel: gradientToolSettings
                onButtonClicked: {
                    parent.selectTool(self, gradientTool)
                }
            }

            SelectionButton {
                id: stampToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/stampTools.svg"
                property alias toolSettingsPanel: stampToolSettings
                onButtonClicked: {
                    parent.selectTool(self, stampTool)
                }
            }

            SelectionButton {
                id: textToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/textTools.svg"
                property alias toolSettingsPanel: textToolSettings
                onButtonClicked: {
                    parent.selectTool(self, textTool)
                }
            }

            SelectionButton {
                id: eraserToolButton
                buttonSize: parent.height
                isButtonSelected: toolButtonsGrid.selectedButton == self
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/eraserTools.svg"
                property alias toolSettingsPanel: eraserToolSettings
                onButtonClicked: {
                    parent.selectTool(self, brushTool, true)
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

        BrushToolSettings {
            id: brushToolSettings
            visible: true // NOTE init default value on start
            anchors.fill: parent
        }

        GeometryToolSettings {
            id: geometryToolSettings
            anchors.fill: parent
        }

        GradientToolSettings {
            id: gradientToolSettings
            anchors.fill: parent
        }

        StampToolSettings {
            id: stampToolSettings
            anchors.fill: parent

        }

        TextToolSettings {
            id: textToolSettings
            anchors.fill: parent
        }

        BrushToolSettings {
            id: eraserToolSettings
            anchors.fill: parent
        }
    }
}


