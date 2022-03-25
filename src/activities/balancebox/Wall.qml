/* GCompris - Wall.qml
 *
 * SPDX-FileCopyrightText: 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
