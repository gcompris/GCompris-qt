/* GCompris - ChoiceTable.qml
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
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

// Creates a active button for making a table of days of weeks.
// Set different behaviours and animations on selecting a day from day table here.

import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.5
import "../../core"
import "calendar.js" as Activity

Rectangle {
    id: choiceBox
    property alias choices: choices
    color: "#AAFFFFFF"
    radius: 10
    anchors.margins: 30
    border.color: "#373737"
    border.width: 2

    function select() {
        if(Activity.dayOfWeekSelected === Activity.correctAnswer["dayOfWeek"]) {
            particles.burst(40)
            animWin.start()
            Activity.checkAnswer()
        }
        else {
            crossAnim.start()
        }
    }

    Image {
        id: cross
        z: 10
        source: "qrc:/gcompris/src/core/resource/cancel.svg"
        sourceSize.width: choiceBox.height
        sourceSize.height: choiceBox.height
        anchors.centerIn: parent
        height: 0
        width: cross.height
        opacity: 1
        property int size: parent.height
    }

    SequentialAnimation {
        id: crossAnim
        ParallelAnimation {
            PropertyAnimation {
                target: cross
                property: "height"
                duration: 300
                from: 0
                to: choiceBox.height
                easing.type: Easing.InOutQuad
            }
        }
        PauseAnimation { duration: 800 }
        ParallelAnimation {
            PropertyAnimation {
                target: cross
                property: "height"
                duration: 300
                from: choiceBox.height
                to: 0
                easing.type: Easing.InOutQuad
            }
        }
    }

    ParticleSystemStarLoader {
        id: particles
        clip: false
    }

    GCText {
        id: choices
        anchors.fill: parent
        anchors.leftMargin: choiceBox.border.width
        anchors.rightMargin: choiceBox.border.width
        fontSizeMode: Text.Fit
        font.bold: true
        color: "#373737"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(!questionDelay.running) {
                Activity.dayOfWeekSelected = dayIndex
                select()
                choiceBox.scale = 1
            }
        }
        hoverEnabled: true
        enabled: !crossAnim.running && !animWin.running
        onEntered: choiceBox.scale = 1.1
        onExited: choiceBox.scale = 1
    }

    SequentialAnimation {
        id: animWin
        running: false
        loops: 1
        NumberAnimation {
            target: choiceBox
            property: "rotation"
            from: 0; to: 360
            duration: 600
            easing.type: Easing.InOutQuad
        }
    }
}
