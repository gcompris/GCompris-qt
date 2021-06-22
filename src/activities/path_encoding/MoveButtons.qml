/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core"
import "path.js" as Activity

Item {
    id: moveButtons
    
    property double size: Math.min(width/4, 55 * ApplicationInfo.ratio)
    
    Flow {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 15 * ApplicationInfo.ratio
        
        BarButton {
            id: upButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/right-arrow.png"
            rotation: -90
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
            onClicked: Activity.moveTowards('UP')
        }
        
        BarButton {
            id: downButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/right-arrow.png"
            rotation: 90
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
            onClicked: Activity.moveTowards('DOWN')
        }
        
        BarButton {
            id: leftButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/right-arrow.png"
            rotation: -180
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
            onClicked: Activity.moveTowards('LEFT')
        }
        
        BarButton {
            id: rightButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/right-arrow.png"
            rotation: 0
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
            onClicked: Activity.moveTowards('RIGHT')
        }
    }
}
