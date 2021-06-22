/* GCompris - Block.qml
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
    id: block
    visible: !invisible
    
    Rectangle {
        anchors.fill: parent
        color: "#4DA849"
        border.color: "black"
        border.width: 1
        //opacity: 0.5
        
        MouseArea {
            anchors.fill: parent
            
            onClicked: {
                // send a response
            }
        }
    }
    
    Image {
        width: 0.7 * parent.width
        height: 0.7 * parent.height
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 0.15 * parent.width
            topMargin: 0.15 * parent.height
        }
        source:
            (stone) ? "qrc:/gcompris/src/activities/path_encoding/resource/stone.png" :
            (tree) ? "qrc:/gcompris/src/activities/path_encoding/resource/tree.png" :
            (bush) ? "qrc:/gcompris/src/activities/path_encoding/resource/bush.png" :
            (grass) ? "qrc:/gcompris/src/activities/path_encoding/resource/grass.png" :
            (water) ? "qrc:/gcompris/src/activities/path_encoding/resource/pond.png" :
            ""
        fillMode: Image.PreserveAspectFit
    }
    
    Image {
        width: 0.7 * parent.width
        height: 0.7 * parent.height
        visible: path
        anchors.fill: parent
        source:"qrc:/gcompris/src/activities/path_encoding/resource/mud.jpg"
        fillMode: Image.PreserveAspectFit
    }
    
    Image {
        width: 0.7 * parent.width
        height: 0.7 * parent.height
        visible: flag
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 0.15 * parent.width
            topMargin: 0.15 * parent.height
        }
        source:"qrc:/gcompris/src/activities/path_encoding/resource/finish.png"
        fillMode: Image.PreserveAspectFit
    }
}
