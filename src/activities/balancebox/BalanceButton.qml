/* GCompris - Goal.qml
 *
 * Copyright (C) 2014-2015 Holger Kaelberer
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Box2D 2.0

import "../../core"
import "balancebox.js" as Activity

Item {
    id: goal
    
    property alias body: itemBody
    property alias world: itemBody.world

    Image {
        id: goalImage
        
        width: goal.width
        height: goal.height
        source: Activity.baseUrl + "/door.png"
        anchors.centerIn: parent

    }

    Body {
        id: itemBody
        
        target: goal
        bodyType: Body.Static
        world: physicsWorld
        sleepingAllowed: false
        fixedRotation: true
        
        fixtures: Circle {
            id: goalFixture

            categories: Circle.Category3
            radius: goalImage.width / 2
            density: 0
            friction: 0
            restitution: 0
            sensor: true            
        }
    }
}
