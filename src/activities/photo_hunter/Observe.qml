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
import QtQuick 2.12
import core 1.0

import "../../core"
import "photo_hunter.js" as Activity

Image {
    id: card

    width: activityBackground.isHorizontal ?
        Math.min(frame.height - slider.height, parent.width * 0.5) - GCStyle.baseMargins:
        Math.min(frame.width, parent.height * 0.5 - GCStyle.baseMargins)
    height: width
    sourceSize.width: width
    sourceSize.height: width

    property alias repeater: repeater
    property alias circleRepeater: circleRepeater
    property int good: 0
    property bool show: false
    property double minimumSize: 30 * ApplicationInfo.ratio

    Behavior on anchors.horizontalCenterOffset {
        enabled: activityBackground.isHorizontal
        NumberAnimation {
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on anchors.verticalCenterOffset {
        enabled: !activityBackground.isHorizontal
        NumberAnimation {
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }


    Image {
        id: wrong
        source: "qrc:/gcompris/src/activities/tic_tac_toe/resource/cross.svg"
        width: GCStyle.smallButtonHeight
        height: GCStyle.smallButtonHeight
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
        enabled: !activityBackground.startedHelp
        onClicked: {
            items.brickSound.play()
            wrongAnim.start()
            wrong.x = mouseX - wrong.width * 0.5
            wrong.y = mouseY - wrong.height * 0.5
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

            width: card.width * Activity.dataset[items.currentLevel].coordinates[index].w
            height: card.height * Activity.dataset[items.currentLevel].coordinates[index].h

            sourceSize.width: width
            fillMode: Image.PreserveAspectFit

            source: Activity.url + "photo" + (items.currentLevel + 1) + "_" + (index + 1) + ".svg"
            opacity: card.show ? 1 : 0

            x: modelData[0] * card.width
            y: modelData[1] * card.height

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
                width: Math.max(parent.width, card.minimumSize)
                height: Math.max(parent.height, card.minimumSize)
                enabled: !activityBackground.startedHelp
                onClicked: {
                    Activity.photoClicked(card,index)
                    items.bleepSound.play()
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
            border.color: card.show ? "#BF3535E8" : "#BFE83535" // blue : red
            border.width: GCStyle.thinBorder
            opacity: 0
            x: itemAt.x + (itemAt.width - width) * 0.5
            y: itemAt.y + (itemAt.height - height) * 0.5
            width: Math.max(itemAt.width, itemAt.height, card.minimumSize) * 1.5
            height: width

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
