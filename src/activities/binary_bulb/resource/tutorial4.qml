/* GCompris - tutorial4.qml
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
        id: topBlock
        width: parent.width
        height: parent.height * 0.2
        
        GCText {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("0 to 255 with")
            fontSizeMode: Text.Fit
            minimumPixelSize: 15
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            width: 0.9 * parent.width
            height: 0.9 * parent.height
            wrapMode: Text.WordWrap
            z: 2
        }
    }
    
    Row {
        id: tableBlock1
        width: parent.width * 0.9
        height: parent.height * 0.2
        anchors.top: topBlock.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        Repeater {
            model: ["", "", "", "", "", "", "", ""]
            Item {
                id: item128
                width: parent.width / 8
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                GCText {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    text: modelData
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 15
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    width: 0.9 * parent.width
                    height: 0.9 * parent.height
                    wrapMode: Text.WordWrap
                    z: 2
                }
            }
        }
    }
    
    Row {
        id: bulbBlock
        width: parent.width * 0.9
        height: parent.height * 0.4
        anchors.top: tableBlock1.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        Repeater {
            model: ["off", "off", "off", "off", "off", "off", "off", "off"]
            Item {
                id: item128
                width: parent.width / 8
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    source: "bulb_" + modelData + ".svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    sourceSize.width: implicitWidth
                }
            }
        }
    }
    
    Row {
        width: parent.width * 0.9
        height: parent.height * 0.2
        anchors.top: bulbBlock.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        Repeater {
            model: ["0", "0", "0", "0", "0", "0", "0", "0"]
            Item {
                id: item128
                width: parent.width / 8
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                GCText {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    text: modelData
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 15
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    width: 0.9 * parent.width
                    height: 0.9 * parent.height
                    wrapMode: Text.WordWrap
                    z: 2
                }
            }
        }
    }
}
