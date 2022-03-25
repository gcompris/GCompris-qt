/* GCompris - Goal.qml
 *
 * SPDX-FileCopyrightText: 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
        
        width: goal.width * 1.1
        height: goal.height * 1.1
        sourceSize.height: height
        sourceSize.width: width
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
