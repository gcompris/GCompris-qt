/* GCompris - BalanceItem.qml
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
    // for goal in the editor, use 1.1 scale
    property alias imageScale: itemImage.scale

    signal beginContact(Item item, Item other)
    signal endContact(Item item, Item other)

    Image {
        id: itemImage
        width: item.width
        height: item.height
        sourceSize.width: width
        sourceSize.height: height
        source: item.imageSource
        anchors.centerIn: parent
        scale: 1
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
