/* GCompris - Goal.qml
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

import "../../core"
import "balancebox.js" as Activity

Item {
    id: goal
    
    property alias world: itemBody.world
    property alias imageSource: goalImage.source
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

    signal beginContact(Item item, Item other)
    signal endContact(Item item, Item other)

    Image {
        id: goalImage
        
        width: goal.width
        height: goal.height
        source: Activity.baseUrl + "/door_closed.svg"
        anchors.centerIn: parent
    }

    Body {
        id: itemBody
        
        target: goal
        bodyType: Body.Static
        world: physicsWorld
        sleepingAllowed: false
        fixedRotation: true
        linearDamping: 0

        fixtures: Box {
            id: itemFixture

            categories: Circle.Category4
            width: goal.width
            height: goal.height
            density: 0
            friction: 0
            restitution: 0
            sensor: true            
        }
    }
}
