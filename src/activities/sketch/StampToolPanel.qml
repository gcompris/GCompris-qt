/* GCompris - StampToolPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic
import "../../core"

Item {
    id: stampToolPanel
    visible: false
    anchors.fill: parent

    property Item selectedModeButton: modeList.currentItem
    readonly property string toolTitle: qsTr("Stamp Tool")

    onSelectedModeButtonChanged: {
        stampTool.selectedStampIndex = modeList.currentIndex;
    }

    // Triggered when selecting the tool
    function setToolMode() {
        toolsPanel.loadModeSettings();
    }

    GridView {
        id: modeList
        anchors.fill: parent
        anchors.bottomMargin: items.baseMargins
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
            onButtonClicked: modeList.currentIndex = index;
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
