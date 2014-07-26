/* GCompris - ColorItem.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick 2.1
import QtMultimedia 5.0
import "findit.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: item
    property Item main
    property Item bar
    property string audioSrc
    property string question

    GCAudio {
        id: audio
        source: audioSrc
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(question === Activity.getCurrentTextQuestion()) {
                particles.emitter.burst(40)
                Activity.nextQuestion()
            } else {
                if(audioSrc) {
                    audio.play()
                }
                Activity.lost()
            }
        }
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
              easing.type: Easing.InOutQuad }
    }
    ParticleSystemStar {
        id: particles
        clip: false
    }
}
