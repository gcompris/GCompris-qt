/* GCompris - MapView.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core"
import "deplacements.js" as Activity

Rectangle {
    id: mapView
    
    property int rows
    property int cols
    
    DelegateModel {
        id: delegateModel
        model: mapListModel
        delegate: Block {
            width: gridview.cellWidth
            height: gridview.cellHeight
        }
    }
    
    GridView {
        id: gridview
        anchors.fill: parent
        interactive: false
        
        cellWidth: width / cols
        cellHeight: height / rows
        
        model: delegateModel
    }
}
