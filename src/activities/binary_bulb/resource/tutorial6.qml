/* GCompris - tutorial6.qml
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
        id: topBlock
        width: parent.width
        height: parent.height * 0.2
        
        GCText {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: "5 ="
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
            model: ["", "", "", "", "", "4", "+", "1"]
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
            model: ["off", "off", "off", "off", "off", "on", "off", "on"]
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
            model: ["0", "0", "0", "0", "0", "1", "0", "1"]
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
