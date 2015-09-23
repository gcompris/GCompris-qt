/* GCompris - Hole.qml
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
    id: hole
    
    property alias body: itemBody
    property alias world: itemBody.world

    Image {
        id: holeImage
        
        width: hole.width
        height: hole.height
        source: Activity.baseUrl + "/button-normal.svg"
        anchors.centerIn: parent

    }

    Body {
        id: itemBody
        
        target: hole
        bodyType: Body.Static
        world: physicsWorld
        sleepingAllowed: false
        fixedRotation: true
        
        fixtures: Circle {
            id: holeFixture

            categories: Circle.Category3
            radius: holeImage.width / 2
            //x: 100
            //y: 100
            density: 0
            friction: 0
            restitution: 0
            sensor: true
            
            onBeginContact: {
//                /console.log("XXX hole begin contact with body cat" + body.target.objectName);
                Activity.holeContacts.push(hole);
                Activity.checkHoles(hole);
            }

            onEndContact: {
                var index = array.indexOf(hole);
                if (index > -1)
                    Activity.holeContacts.splice(index, 1);
            }
        }
    }

}
