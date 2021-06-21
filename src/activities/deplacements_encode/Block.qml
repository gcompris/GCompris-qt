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
    visible: !invisible
    
    // true if the path is going through this block
    // property bool path    
    
    Rectangle {
        anchors.fill: parent
        color: (path) ? "pink" : "white"
        border.color: "black"
        border.width: 1
        opacity: 0.5
        
        MouseArea {
            anchors.fill: parent
            
            onClicked: {
                // send a response
            }
        }
    }
    
    Image {
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/deplacements_encode/resource/blank.jpg"
        fillMode: Image.PreserveAspectFit
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
            (stone) ? "qrc:/gcompris/src/activities/deplacements_encode/resource/stone.png" :
            (tree) ? "qrc:/gcompris/src/activities/deplacements_encode/resource/tree.png" :
            (bush) ? "qrc:/gcompris/src/activities/deplacements_encode/resource/bush.png" :
            (grass) ? "qrc:/gcompris/src/activities/deplacements_encode/resource/grass.png" :
            (water) ? "qrc:/gcompris/src/activities/deplacements_encode/resource/pond.png" :
            "qrc:/gcompris/src/activities/deplacements_encode/resource/blank.jpg"
        fillMode: Image.PreserveAspectFit
    }
    
    Image {
        width: 0.7 * parent.width
        height: 0.7 * parent.height
        visible: path
        anchors.fill: parent
        source:"qrc:/gcompris/src/activities/deplacements_encode/resource/mud.jpg"
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
        source:"qrc:/gcompris/src/activities/deplacements_encode/resource/finish.png"
        fillMode: Image.PreserveAspectFit
    }
}
