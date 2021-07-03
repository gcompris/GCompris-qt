/* GCompris - MoveBar.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core" as Core
import "path.js" as Activity

Rectangle {
    id: moveBar
    color: "lightblue"
    border.color: "white"
    border.width: 0.01 * width
    radius: ApplicationInfo.ratio * 10
    
    DelegateModel {
        id: delegateModel
        model: movesListModel
        delegate: Rectangle {
            width: Math.min(ApplicationInfo.ratio * 50, moveBar.width / 4.5)
            height: width
            
            color: (active) ? "green" : (faded) ? "gray" : "pink"
            border.color: "black"
            border.width: 2
            radius: width / 2
            
            Image {
                source: "qrc:/gcompris/src/activities/path_encoding/resource/right-arrow-plain.png"
                width: 0.6 * parent.width
                height: width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                rotation: ["RIGHT", "DOWN", "LEFT", "UP"].indexOf(direction) * 90
            }
        }
    }
    
    Flickable {
        id: flick
        width: parent.width - 2 * anchors.leftMargin
        height: parent.height - 2 * anchors.topMargin
        
        anchors {
            left: parent.left
            leftMargin: moveBar.border.width
            top: parent.top
            topMargin: moveBar.border.width
        }
        
        clip: true
        flickableDirection: Flickable.VerticalFlick 
        contentWidth: flow.width + 4 * anchors.leftMargin
        contentHeight: flow.height + 4 * anchors.topMargin
        
        Flow {
            id: flow
            
            width: moveBar.width * 0.96
            spacing: 0.02 * moveBar.width
            anchors {
                top: flick.contentItem.top
                left: flick.contentItem.left
                margins: 0.02 * moveBar.width
            }
            
            Repeater {
                model: delegateModel
            }
        }
    }
}
