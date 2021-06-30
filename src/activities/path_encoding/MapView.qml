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
}
