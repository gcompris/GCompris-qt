/* GCompris - ColorItem.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
        if(items.objectSelected)
            return
        items.objectSelected = true
        if(Activity.hasWon) {
            return
        }

        if(question === Activity.getCurrentTextQuestion()) {
            particles.burst(40)
            animWin.start()
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
        enabled: !items.objectSelected
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
          NumberAnimation {
              target: item
              property: "rotation"
              from: 0; to: 360
              duration: 600
              easing.type: Easing.InOutQuad
          }
          ScriptAction { script: Activity.nextQuestion() }
          onRunningChanged: {
              if (running == false) {
                  items.objectSelected = false
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
                items.objectSelected = false
            }
        }
    }

}
