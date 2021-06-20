/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core"
import "deplacements.js" as Activity

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
            source: "resource/right-arrow.png"
            rotation: -90
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
//             onClicked: items.fastMode = !items.fastMode
        }
        
        BarButton {
            id: downButton
            source: "resource/right-arrow.png"
            rotation: 90
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
//             onClicked: items.fastMode = !items.fastMode
        }
        
        BarButton {
            id: leftButton
            source: "resource/right-arrow.png"
            rotation: -180
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
//             onClicked: items.fastMode = !items.fastMode
        }
        
        BarButton {
            id: rightButton
            source: "resource/right-arrow.png"
            rotation: 0
            sourceSize.width: size
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
//             onClicked: items.fastMode = !items.fastMode
        }
    }
}
