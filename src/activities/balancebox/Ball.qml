/* GCompris - Ball.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
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
import GCompris 1.0
import Box2D 2.0

import "../../core"
import "balancebox.js" as Activity

Item {
    id: ball
    
    property alias body: itemBody
    property alias world: itemBody.world
    
    z: 1
    
    Image {
        id: ballImage
        
        width: ball.width
        height: ball.height
        source: Activity.baseUrl + "/ball.svg"
        anchors.centerIn: parent

    }

    Body {
        id: itemBody
        
        target: ball
        bodyType: Body.Dynamic
        world: physicsWorld
        sleepingAllowed: false
        fixedRotation: true
        bullet: true
        
        //onLinearVelocityChanged: {
        //    console.log("linVChanged: " + linearVelocity.x + "/" + linearVelocity.y)
        //}
        
        fixtures: Circle {
            id: circleFix

            radius: ballImage.width / 2
            //x: 100
            //y: 100
            categories: Circle.Category1
            collidesWith: Box.Category1 | Box.Category2 | Box.Category3
            density: 1
            friction: Activity.friction
            restitution: Activity.restitution
            
//            onBeginContact: {
//                var body = other.getBody();
//                console.log("XXX ball begin contact with body cat" + body.target.objectName);
//            }
        }
        
    }

}
