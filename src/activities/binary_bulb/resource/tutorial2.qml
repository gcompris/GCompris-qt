/* GCompris - tutorial2.qml
 *
 * Copyright (C) 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0 

import "../../../core"

Rectangle {
    anchors.fill: parent
    color: "#80FFFFFF"
    
    Item {
        width: parent.width
        height: parent.height * 0.5
        
        Image {
            source: "transistor.svg"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            sourceSize.height: implicitHeight
        }
    }
    
    Item {
        width: parent.width * 0.2
        height: parent.height * 0.5
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        GCText {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: "0"
            font.pixelSize: parent.height * 0.5
            color: "black"
            horizontalAlignment: Text.AlignRight
            width: 0.9 * parent.width
            height: 0.9 * parent.height
            z: 2
        }
    }
    
    Item {
        width: parent.width * 0.3
        height: parent.height * 0.4
        anchors.bottom: parent.bottom
        anchors.right: parent.horizontalCenter
        anchors.bottomMargin: parent.height * 0.05
        
        Image {
            source: ""
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            sourceSize.width: implicitWidth
        }
        
    }
    
    Item {
        width: parent.width * 0.3
        height: parent.height * 0.4
        anchors.bottom: parent.bottom
        anchors.left: parent.horizontalCenter
        anchors.bottomMargin: parent.height * 0.05
        
        Image {
            source: ""
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            sourceSize.width: implicitWidth
        }
        
    }

    Item {
        width: parent.width * 0.2
        height: parent.height * 0.5
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        GCText {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            text: "1"
            font.pixelSize: parent.height * 0.5
            color: "black"
            horizontalAlignment: Text.AlignLeft
            width: 0.9 * parent.width
            height: 0.9 * parent.height
            z: 2
        }
    }
}
