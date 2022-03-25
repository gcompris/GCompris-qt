/* GCompris - DragTile.qml
 *
 * SPDX-FileCopyrightText: 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"

Item {
    id: root
    property string type
    property int length: root.children.length
    function createDynamicObject() {
        var component = Qt.createComponent('Tile.qml')
        component.createObject(root)
    }
    Loader {
        active: type == "operands" ? true : false
        sourceComponent: Tile {
            id: tile
        }
    }
    Component.onCompleted: {
        if(type == "operators")
            createDynamicObject()
    }
    onChildrenChanged: {
        if(type == "operators") {
            if(root.children.length-1 == 0)
                createDynamicObject()
        }
    }
}
