/* GCompris - DragTile.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <PASCAL GEORGES> (V13.11)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "../../core"

Item {
    id: root
    property string type
    property int length: root.children.length

    function createDynamicObject(){
        var component = Qt.createComponent('Tile.qml')
        component.createObject(root)

    }
    Loader {
        active: type == "operands" ? true : false
        sourceComponent: Tile{
            id: tile
        }
    }

    Component.onCompleted: {
        if(type == "operators")
            createDynamicObject()
    }
    onChildrenChanged: {
        if(type == "operators"){
            if(root.children.length == 0)
                createDynamicObject()
            else if(root.children.length == 3)
                root.children[0].destroy()
        }

    }

}
