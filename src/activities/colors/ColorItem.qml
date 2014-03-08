import QtQuick 2.1
import QtQuick.Particles 2.0
import QtMultimedia 5.0
import "findit.js" as Activity
import GCompris 1.0

Image {
    id: item
    property Item main
    property Item bar
    property string audioSrc
    property string question

    Audio {
        id: audio
        source: audioSrc
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(question === Activity.getCurrentTextQuestion()) {
                clickedEmitter.pulse(500)
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

    ParticleSystem
    {
        id: clickedEffect
        anchors.fill: parent
        running: true
        Emitter {
            id: clickedEmitter
            anchors.fill: parent
            emitRate: 100
            lifeSpan: 100
            lifeSpanVariation: 50
            size: 48
            sizeVariation: 20
            system: clickedEffect
            enabled: false
        }
        ImageParticle {
            source: "qrc:/gcompris/src/activities/clickgame/resource/star.png"
            sizeTable: "qrc:/gcompris/src/activities/clickgame/resource/sizeTable.png"
            color: "white"
            blueVariation: 0.5
            greenVariation: 0.5
            redVariation: 0.5
        }
    }


}
