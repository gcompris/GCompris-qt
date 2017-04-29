/* GCompris - ColorItem.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import "findit.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: item
    property GCAudio audioVoices
    property Item bar
    property string audioSrc
    property string question
    property bool playAudioOnError: false

    function select() {
        mouseArea.enabled = false
        if(Activity.hasWon) {
            return
        }

        if(question === Activity.getCurrentTextQuestion()) {
            particles.burst(40)
            animWin.start()
            Activity.nextQuestion()
        } else {
            if(audioSrc && item.playAudioOnError) {
                item.audioVoices.play(audioSrc)
            }
            crossAnim.start()
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: select()
    }

    SequentialAnimation {
          id: anim
          running: true
          loops: Animation.Infinite
          NumberAnimation {
              target: item
              property: "rotation"
              from: -10; to: 10
              duration: 400 + Math.floor(Math.random() * 400)
              easing.type: Easing.InOutQuad
          }
          NumberAnimation {
              target: item
              property: "rotation"
              from: 10; to: -10
              duration: 400 + Math.floor(Math.random() * 400)
              easing.type: Easing.InOutQuad
          }
    }

    SequentialAnimation {
          id: animWin
          running: false
          loops: 1
          NumberAnimation {
              target: item
              property: "rotation"
              from: 0; to: 360
              duration: 600
              easing.type: Easing.InOutQuad
          }
          onRunningChanged: {
              if (running == false) {
                  mouseArea.enabled = true
              }
          }
    }

    ParticleSystemStarLoader {
        id: particles
        clip: false
    }

    Image {
        id: cross
        source: Activity.url + "checkError.svg"
        sourceSize.width: 128 * ApplicationInfo.ratio
        anchors.centerIn: parent
        width: 0
        height: width
        opacity: 1

        property int size: Math.min(parent.width, parent.height)
    }

    SequentialAnimation {
        id: crossAnim
        PropertyAnimation {
            target: cross
            property: "width"
            duration: 300
            from: 0
            to: cross.size
            easing.type: Easing.InOutQuad
        }
        PauseAnimation { duration: 800 }
        PropertyAnimation {
            target: cross
            property: "width"
            duration: 300
            from: cross.size
            to: 0
            easing.type: Easing.InOutQuad
        }
        onRunningChanged: {
            if (running == false) {
                mouseArea.enabled = true
            }
        }
    }

}
