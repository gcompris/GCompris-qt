/* GCompris - BalanceItem.qml
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
import Box2D 2.0
import QtGraphicalEffects 1.0

import "../../core"

Item {
    id: item

    z: 2  // above most

    property alias world: itemBody.world

    property alias imageSource: itemImage.source

    property alias body: itemBody
    property alias bodyType: itemBody.bodyType
    property alias linearDamping: itemBody.linearDamping
    
    property alias fixtures: itemBody.fixtures
    property alias sensor: itemFixture.sensor
    property alias categories: itemFixture.categories
    property alias collidesWith: itemFixture.collidesWith
    property alias density: itemFixture.density
    property alias friction: itemFixture.friction
    property alias restitution: itemFixture.restitution
    
    property alias shadow: itemShadow.visible
    property alias shadowHorizontalOffset: itemShadow.horizontalOffset
    property alias shadowVerticalOffset: itemShadow.verticalOffset

    signal beginContact(Item item, Item other)
    signal endContact(Item item, Item other)

    Image {
        id: itemImage
        
        width: item.width
        height: item.height
        source: item.imageSource
        anchors.centerIn: parent
    }

    DropShadow {
        id: itemShadow
        anchors.fill: itemImage
        cached: true
        visible: false  // note: dropping shadows for the walls is really expensive
                        // in terms of CPU usage!
        radius: 0
        samples: 16
        color: "#80000000"
        source: itemImage
    }

    Body {
        id: itemBody
        
        target: item
        bodyType: Body.Static
        sleepingAllowed: false
        fixedRotation: true
        linearDamping: 0

        fixtures: Circle {
            id: itemFixture

            radius: itemImage.width / 2

            onBeginContact: item.beginContact(getBody().target, other.getBody().target)
            onEndContact: item.endContact(getBody().target, other.getBody().target)
        }
    }
}
