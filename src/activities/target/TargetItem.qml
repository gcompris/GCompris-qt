/* GCompris - TargetItem.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "target.js" as Activity

Image {
    id: targetItem
    fillMode: Image.PreserveAspectCrop
    source: Activity.url + "target_background.svg"
    width: parent.width * zoom
    height: parent.height * zoom
    sourceSize.width: width
    sourceSize.height: height
    anchors.centerIn: parent

    property int zoom: 2
    property alias model: targetModel
    property bool stopMe: false
    property var scores: []
    property string scoreText
    property int scoreTotal

    signal start
    signal stop
    signal attachArrow(Item arrow)

    onStart: {
        scores = []
        scoreText = ""
        scoreTotal = 0
        stopMe = false
        targetItem.anchors.horizontalCenterOffset = getRandomOffset(0)
        targetItem.anchors.verticalCenterOffset = getRandomOffset(0)
    }
    onStop: {
        stopMe = true
        targetItem.anchors.horizontalCenterOffset = 0
        targetItem.anchors.verticalCenterOffset = 0
    }

    // Avoid taking the same value or the animation won't restart
    function getRandomOffset(oldValue) {
        if(oldValue != 0 && Math.random() < 0.5)
            return 0
        var maxSize = targetModel.get(0).size * ApplicationInfo.ratio
        do {
            var newValue = Math.floor(Math.random() * maxSize) - maxSize / 2
        } while(oldValue == newValue)
        return newValue
    }

    onAttachArrow: {
        arrow.anchors.centerIn = undefined
        var coordArrow = parent.mapToItem(targetItem, arrow.x, arrow.y)
        arrow.parent = targetItem
        arrow.x = coordArrow.x
        arrow.y = coordArrow.y

        var arrowCenterX = arrow.x + arrow.width / 2
        var arrowCenterY = arrow.y + arrow.height / 2

        var centerX = targetItem.width / 2
        var centerY = targetItem.height / 2

        // Calc the arrow score
        var dist = Math.sqrt(Math.pow(arrowCenterX - centerX, 2) +
                             Math.pow(arrowCenterY - centerY, 2))
        dist *= zoom / ApplicationInfo.ratio
        var score = 0
        for(var i = targetModel.count - 1; i >= 0; --i) {
            if(dist < targetModel.get(i).size) {
                score = targetModel.get(i).score
                break
            }
        }
        scores.push(score)
        scoreTotal += score
        scoreText = scores.join(" + ")
        parent.targetReached()
    }

    Behavior on anchors.horizontalCenterOffset {
        id: horizontal
        NumberAnimation {
            id: anim1
            duration: 3000
            easing.type: Easing.InOutQuad
            onRunningChanged: {
                if(!anim1.running) {
                    var newValue = getRandomOffset(targetItem.anchors.horizontalCenterOffset)
                    if(!stopMe)
                        targetItem.anchors.horizontalCenterOffset =  newValue
                }
            }
        }
    }
    Behavior on anchors.verticalCenterOffset {
        id: vertical
        NumberAnimation {
            id: anim2
            duration: 3000
            easing.type: Easing.InOutQuad
            onRunningChanged: {
                if(!anim2.running) {
                    var newValue = getRandomOffset(targetItem.anchors.verticalCenterOffset)
                    if(!stopMe)
                        targetItem.anchors.verticalCenterOffset =  newValue
                }
            }
        }
    }
    
    ListModel {
        id: targetModel
    }

    Repeater {
        id: repeater
        model: targetModel
        
        Rectangle {
            anchors.centerIn: targetItem
            width: size * ApplicationInfo.ratio
            height: size * ApplicationInfo.ratio
            color: model.color
            radius: width / 2
            border.width: 1 * ApplicationInfo.ratio
            border.color: "#40000000"
            
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                width: ApplicationInfo.ratio * 30
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 20
                minimumPointSize: 5
                fontSizeMode: Text.Fit
                text: score
                color: "#A0000000"
            }
            
        }
    }
}
