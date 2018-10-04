/* GCompris - Wall.qml
 *
 * Copyright (C) 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0
import Box2D 2.0
import QtGraphicalEffects 1.0
import "balancebox.js" as Activity

Item {
    id: item
    
    transformOrigin: Item.TopLeft
    property alias body: itemBody
    property alias world: itemBody.world
    property alias categories: itemFixture.categories 
    property alias shadow: itemShadow.visible
    //property bool shadow: false //itemShadow.visible
    property alias shadowHorizontalOffset: itemShadow.horizontalOffset
    property alias shadowVerticalOffset: itemShadow.verticalOffset

    Body {
        id: itemBody
        target: item
        world: physicsWorld
        active: item.visible
        
        fixtures: Box {
            id: itemFixture
            width: item.width
            height: item.height
            friction: 0.0
            density: 1
            restitution: Activity.restitution
            categories: Box.Category2
            collidesWith: Box.Category1
        }
    }

    Rectangle {
        id: itemRectangle
        anchors.fill: parent
        width: parent.width
        height: parent.height
        radius: height / 2
        color: "#B38B56"
        z: 2
    }

    DropShadow {
        id: itemShadow
        anchors.fill: itemRectangle
        cached: true
        visible: false  // note: dropping shadows for the walls is really expensive
                        // in terms of CPU usage!
        radius: 0
        samples: 16
        color: "#80000000"
        source: itemRectangle
        z: 1
    }

}
