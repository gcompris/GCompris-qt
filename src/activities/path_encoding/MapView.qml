/* GCompris - MapView.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core"
import "path.js" as Activity

Rectangle {
    id: mapView
    
    property int rows
    property int cols
    
    property double cellWidth: width / cols
    property double cellHeight: height / rows
    
    property bool touchEnabled: true
    
    signal init
    
    onInit: {
        selectedOverlay.visible = false
    }
    
    DelegateModel {
        id: delegateModel
        model: mapListModel
        delegate: Block {
            width: gridview.cellWidth
            height: gridview.cellHeight
            index: DelegateModel.itemsIndex
        }
    }
    
    GridView {
        id: gridview
        anchors.fill: parent
        interactive: false
        
        cellWidth: mapView.cellWidth 
        cellHeight: mapView.cellHeight
        
        model: delegateModel
    }
    
    MultiPointTouchArea {
        anchors.fill: parent
        maximumTouchPoints: 1
        onPressed: {
            checkTouchPoint(touchPoints);
        }
        onTouchUpdated: checkTouchPoint(touchPoints);
        onReleased: {
            if(selectedOverlay.visible && touchEnabled && !items.tux.isAnimationRunning) {
                var row = Math.floor(selectedOverlay.y / cellHeight)
                var col = Math.floor(selectedOverlay.x / cellWidth)
                Activity.processBlockClick([col, row])
            }
        }
    }
    
    Rectangle {
        id: selectedOverlay
        opacity: 0.35
        color: "pink"
        width: cellWidth
        height: cellHeight
        visible: false
    }
    
    function checkTouchPoint(touchPoints) {
        var touch = touchPoints[0]
        
        if(items.tux.isAnimationRunning || !touch || !touchEnabled)
            return
        
        var row = Math.floor(touch.y / cellHeight)
        var col = Math.floor(touch.x / cellWidth)
        
        if(row >= 0 && row < rows && col >= 0 && col < cols) {
            selectedOverlay.x = col * cellWidth
            selectedOverlay.y = row * cellHeight
            selectedOverlay.visible = true
        }
        else {
            selectedOverlay.visible = false
        }
    }
}
