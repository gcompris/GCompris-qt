/* GCompris - Block.qml
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
    id: block
    
    // true if the path is going through this block
    // property bool path
    
    // true if the player is currenty on this block
    // property bool player
    
    Rectangle {
        anchors.fill: parent
        color: (path) ? "pink" : "yellow"
        border.color: "black"
        border.width: 1
        opacity: 0.5
        
        MouseArea {
            anchors.fill: parent
            
            onClicked: {
                console.log(path, player)
                console.log(parent.width, parent.height)
            }
        }
    }
    
}
