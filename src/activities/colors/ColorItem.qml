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
