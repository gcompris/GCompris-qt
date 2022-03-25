/* GCompris - tutorial2.qml
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
