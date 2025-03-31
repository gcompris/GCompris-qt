/* GCompris - MapView.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0
import QtQml.Models 2.12

import "../../core"
import "path.js" as Activity

Item {
    id: mapView
    required property bool touchEnabled
    required property int rows
    required property int cols

    property double maxHeight: 1
    property double maxWidth: 1
    readonly property int cellSize: Math.min(maxHeight / rows, maxWidth / cols)

    height: cellSize * rows
    width: cellSize * cols

    signal init

    onInit: {
        selectedOverlay.visible = false
    }

    DelegateModel {
        id: delegateModel
        model: mapListModel
        delegate: Block {
            width: mapView.cellSize
            index: DelegateModel.itemsIndex
        }
    }

    GridView {
        id: gridview
        anchors.fill: parent
        interactive: false

        cellWidth: mapView.cellSize
        cellHeight: mapView.cellSize

        model: delegateModel
    }

    MultiPointTouchArea {
        anchors.fill: parent
        maximumTouchPoints: 1
        onPressed: (touchPoints) => {
            checkTouchPoint(touchPoints);
        }
        onTouchUpdated: (touchPoints) => checkTouchPoint(touchPoints);
        onReleased: (touchPoints) => {
            checkTouchPoint(touchPoints)
            if(selectedOverlay.visible && touchEnabled && !items.tux.isAnimationRunning) {
                var row = Math.floor(selectedOverlay.y / cellSize)
                var col = Math.floor(selectedOverlay.x / cellSize)
                Activity.processBlockClick([col, row])
            }
        }
    }

    Rectangle {
        id: selectedOverlay
        opacity: 0.5
        color: GCStyle.highlightColor
        width: cellSize - GCStyle.thinnestBorder
        height: width
        visible: false
    }

    function checkTouchPoint(touchPoints) {
        var touch = touchPoints[0]

        if(items.tux.isAnimationRunning || !touch || !touchEnabled)
            return

        var row = Math.floor(touch.y / cellSize)
        var col = Math.floor(touch.x / cellSize)

        if(row >= 0 && row < rows && col >= 0 && col < cols) {
            selectedOverlay.x = col * cellSize + GCStyle.thinnestBorder * 0.5
            selectedOverlay.y = row * cellSize + GCStyle.thinnestBorder * 0.5
            selectedOverlay.visible = true
        }
        else {
            selectedOverlay.visible = false
        }
    }
}
