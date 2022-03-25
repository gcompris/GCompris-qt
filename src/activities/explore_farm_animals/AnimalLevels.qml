/* GCompris - AnimalLevels.qml
*
* SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "explore-level.js" as Activity

Image {
    id: animalImg
    width: animalWidth
    height: animalHeight
    sourceSize.width: width
    sourceSize.height: height
    fillMode: Image.PreserveAspectFit

    property string name: name
    property alias starVisible: star.visible
    property int questionId
    property string title
    property string description
    property string imageSource
    property string question
    property string audio

    signal displayDescription(var animal)

    SequentialAnimation {
        id: anim
        running: true
        loops: 1

        NumberAnimation {
            target: animalImg
            property: "rotation"
            from: 0; to: 360
            duration: 400 + Math.floor(Math.random() * 400)
            easing.type: Easing.InOutQuad
        }
    }

    Image {
        id: star
        anchors.verticalCenter: animalImg.bottom
        anchors.horizontalCenter: animalImg.horizontalCenter
        width: background.playWidth * 0.05
        height: width
        visible: false
        source:"qrc:/gcompris/src/core/resource/star.png"
    }

    MultiPointTouchArea {
        id: touchArea
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        touchPoints: [ TouchPoint { id: point1 } ]
        mouseEnabled: progressbar.value != progressbar.maximumValue && !items.bonus.isPlaying

        onPressed: {
            if(items.progressbar.value >= progressbar.maximumValue) {
                return
            }
            var questionTargetId = items.questionOrder[Activity.items.progressbar.value]
            Activity.items.instruction.visible = false
            if (Activity.items.score.currentSubLevel === 1) {
                if(animalImg.audio) {
                    audioVoices.play(animalImg.audio);
                }
                displayDescription(animalImg)
                star.visible = true;
            } else {
                if (questionId === questionTargetId) {
                    animWin.start();
                    items.progressbar.value ++;
                    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/completetask.wav");
                    Activity.nextSubSubLevel();
                } else {
                    items.bonus.bad("smiley")
                }
            }
        }
    }

    SequentialAnimation {
        id: animWin
        running: false
        loops: 1
        NumberAnimation {
            target: animalImg
            property: "rotation"
            from: 0; to: 360
            duration: 600
            easing.type: Easing.InOutQuad
        }
    }
}
