/* GCompris - Observe.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "photo_hunter.js" as Activity

Image {
    id: card

    width: background.vert ? Math.min((parent.height - 30 * ApplicationInfo.ratio - slider.height) * 0.5, parent.width - 20 * ApplicationInfo.ratio) :
                            Math.min((parent.width - 30 * ApplicationInfo.ratio) * 0.5, parent.height - 20 * ApplicationInfo.ratio - slider.height)
    height: width
    sourceSize.width: width
    sourceSize.height: width

    property GCSfx audioEffects: activity.audioEffects
    property alias repeater: repeater
    property alias circleRepeater: circleRepeater
    property int good: 0
    property bool show: false

    Behavior on anchors.horizontalCenterOffset {
        enabled: !background.vert
        NumberAnimation {
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on anchors.verticalCenterOffset {
        enabled: background.vert
        NumberAnimation {
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }


    Image {
        id: wrong
        source: Activity.url + "wrong.svg"
        width: 70
        height: 70
        opacity: 0
    }

    NumberAnimation {
        id: wrongAnim
        target: wrong
        property: "opacity"
        from: 0
        to: 1
        duration: 400
    }

    NumberAnimation {
        id: wrongAnim2
        target: wrong
        property: "opacity"
        from: 1
        to: 0
        duration: 400
    }

    MouseArea {
        id: big
        anchors.fill: parent
        enabled: !background.startedHelp
        onClicked: {
            audioEffects.play('qrc:/gcompris/src/core/resource/sounds/brick.wav')
            wrongAnim.start()
            wrong.x = mouseX - wrong.width/2
            wrong.y = mouseY - wrong.height/2
            wrongAnim2.start()
        }
    }

    Repeater {
        id: repeater

        model: items.model

        Image {
            id: photo
            property alias particleLoader: particleLoader
            property alias differenceAnimation: differenceAnimation
            property double widthScale: Activity.dataset[Activity.currentLevel].coordinates[index].w
            property double heightScale: Activity.dataset[Activity.currentLevel].coordinates[index].h

            sourceSize.width: Activity.dataset[Activity.currentLevel].coordinates[index].r * 200
            sourceSize.height: Activity.dataset[Activity.currentLevel].coordinates[index].r * 200

            width: card.width / 10 * widthScale
            height: card.height / 10 * heightScale

            source: Activity.url + "photo" + (Activity.currentLevel + 1) + "_" + (index + 1) + ".svg"
            opacity: card.show ? 1 : 0

            x: modelData[0] * card.width / 1200
            y: modelData[1] * card.height / 1700

            NumberAnimation {
                id: differenceAnimation
                target: photo
                property: "opacity"
                from: 0
                to: 1
                duration: 500
            }

            // Create a particle only for the strawberry
            Loader {
                id: particleLoader
                anchors.fill: parent
                active: true
                sourceComponent: particle
            }

            Component {
                id: particle
                ParticleSystemStarLoader {
                    id: particles
                    clip: false
                }
            }

            MouseArea {
                id: mouseArea
                anchors.centerIn: parent
                width: parent.width * 3
                height: parent.height * 3
                enabled: !background.startedHelp
                onClicked: {
                    Activity.photoClicked(card,index)
                    audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')
                }
            }
        }
    }

    Repeater {
        id: circleRepeater

        model: card.repeater.model

        Rectangle {
            id: circle
            color: "transparent"
            radius: width * 0.5
            border.color: card.show ? "blue" : "red"
            border.width: 6
            opacity: 0
            x: itemAt.x - width / 6
            y: itemAt.y - height / 6
            width: itemAt.width * 1.5
            height: itemAt.height * 1.5

            property alias scaleAnim: scaleAnim
            property var itemAt: card.repeater.itemAt(index) ? card.repeater.itemAt(index) : card

            NumberAnimation {
                id: scaleAnim
                target: circle
                property: "scale"
                from: 0
                to: circle.scale
                duration: 700
            }
        }
    }
}
