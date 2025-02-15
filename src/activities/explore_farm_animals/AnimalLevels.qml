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
import core 1.0

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
        width: activityBackground.playWidth * 0.05
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
        mouseEnabled: progressbar.currentSubLevel != progressbar.numberOfSubLevels && !items.buttonsBlocked

        onPressed: {
            if(items.progressbar.currentSubLevel >= progressbar.numberOfSubLevels) {
                return
            }
            var questionTargetId = items.questionOrder[Activity.items.progressbar.currentSubLevel]
            if (Activity.items.score.currentSubLevel === 1) {
                if(animalImg.audio) {
                    audioVoices.play(animalImg.audio);
                }
                displayDescription(animalImg)
                star.visible = true;
            } else {
                items.buttonsBlocked = true;
                if (questionId === questionTargetId) {
                    animWin.start();
                    items.progressbar.currentSubLevel ++;
                    items.progressbar.playWinAnimation();
                    items.goodAnswerSound.play();
                } else {
                    var errorPosition = activityBackground.mapFromItem(animalImg, animalImg.width * 0.5, animalImg.height * 0.5)
                    items.errorRectangle.x = errorPosition.x;
                    items.errorRectangle.y = errorPosition.y;
                    items.errorRectangle.startAnimation();
                    items.badAnswerSound.play();
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
