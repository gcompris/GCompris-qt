/* GCompris - AnimalLevels.qml
*
* Copyright (C) 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
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

        x: animalImg.width / 2.5
        y: animalImg.height * 0.8
        visible: false

        source:"qrc:/gcompris/src/core/resource/star.png"
    }

    MultiPointTouchArea {
        id: touchArea
        anchors.centerIn: parent
        // Make the item big enough to be clicked easily
        width: Math.max(parent.width, 55 * ApplicationInfo.ratio)
        height: Math.max(parent.height, 55 * ApplicationInfo.ratio)
        touchPoints: [ TouchPoint { id: point1 } ]
        mouseEnabled: progressbar.value != progressbar.maximumValue && !items.bonus.isPlaying

        onPressed: {
            if(items.progressbar.value >= progressbar.maximumValue) {
                return
            }
            var questionTargetId = items.questionOrder[Activity.items.progressbar.value]
            Activity.items.instruction.visible = false
            if (Activity.items.score.currentSubLevel == 1) {
                audioVoices.play(animalImg.audio);
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
