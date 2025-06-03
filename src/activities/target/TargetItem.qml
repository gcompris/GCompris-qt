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
pragma ComponentBehavior: Bound
import QtQuick
import core 1.0

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
    property list<int> scores: []
    property string scoreText
    property int scoreTotal

    signal start
    signal stop
    signal attachArrow(Item arrow)
    signal targetReached

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
    function getRandomOffset(oldValue: real) : real {
        if(oldValue != 0 && Math.random() < 0.5)
            return 0
        var maxSize = targetModel.get(0).size * ApplicationInfo.ratio
        do {
            var newValue = Math.floor(Math.random() * maxSize) - maxSize / 2
        } while(oldValue == newValue)
        return newValue
    }

    onAttachArrow: (arrow) => {
        arrow.anchors.centerIn = undefined
        var coordArrow = parent.mapToItem(targetItem, arrow.x, arrow.y)
        var coordArrowContainer = parent.mapToItem(arrowContainer, arrow.x, arrow.y)
        arrow.parent = arrowContainer
        arrow.x = coordArrowContainer.x
        arrow.y = coordArrowContainer.y

        var arrowCenterX = coordArrow.x + arrow.width / 2
        var arrowCenterY = coordArrow.y + arrow.height / 2

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
        targetReached()
    }

    Behavior on anchors.horizontalCenterOffset {
        id: horizontal
        NumberAnimation {
            id: anim1
            duration: 3000
            easing.type: Easing.InOutQuad
            onRunningChanged: {
                if(!anim1.running) {
                    var newValue = targetItem.getRandomOffset(targetItem.anchors.horizontalCenterOffset)
                    if(!targetItem.stopMe)
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
                    var newValue = targetItem.getRandomOffset(targetItem.anchors.verticalCenterOffset)
                    if(!targetItem.stopMe)
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
            id: targetRectangle
            required property int size
            required property color circleColor
            required property int score
            anchors.centerIn: targetItem
            width: size * ApplicationInfo.ratio
            height: size * ApplicationInfo.ratio
            color: circleColor
            radius: width * 0.5
            border.width: GCStyle.thinnestBorder
            border.color: "#40000000"
            
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                width: targetModel.get(targetModel.count - 1).size * 0.5 * ApplicationInfo.ratio
                height: width
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 20
                minimumPointSize: 5
                fontSizeMode: Text.Fit
                text: targetRectangle.score
                color: "#A0000000"
            }
            
        }
    }

    Item {
        id: arrowContainer
        anchors.centerIn: targetItem
        width: targetModel.count ? targetModel.get(0).size * ApplicationInfo.ratio : 0
        height: width
    }
}
