/* GCompris - Animal.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "left_right_click.js" as Activity

Item {
    id: animal
    z: 10
    visible: !animalInvisible ? true : false
    Rectangle {
        id: animalRect
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.8
        height: parent.height * 0.8
        color: "white"
        opacity: 0.9
        border.color: "black"
        property color initialBorderColor: border.color
        border.width: 5
        radius: 10
        Image {
            width: parent.width * 0.9
            height: parent.height * 0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: imageSource
            fillMode: Image.Stretch
        }
        PropertyAnimation {
            id: disappearAnimal
            target: animal
            property: 'visible'
            to: false
            duration: 1000
        }
        PropertyAnimation {
            id: borderHighlight
            target: animalRect
            property: 'border.color'
            to: "yellow"
            duration: 0
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                // if left target animal is clicked with left click
                if((mouse.button === Qt.LeftButton) && (animalIdentifier === Activity.Position.left)) {
                    animal.state = "toLeftTarget"
                    Activity.incrementCounter()
                    disappearAnimal.running = true
                }
                else if((mouse.button === Qt.RightButton) && (animalIdentifier === Activity.Position.right)) {
                    animal.state = "toRightTarget"
                    Activity.incrementCounter()
                    disappearAnimal.running = true
                }
                else {
                    wrongClick()
                }
                triggerClick(mouse.button)
            }

            function triggerClick(mouseButton) {
                if(mouseButton === Qt.LeftButton)
                    leftClickTrigger()
                else
                    rightClickTrigger()
            }

            hoverEnabled: true
            onEntered: {
                animal.opacity = 1
                animalRect.border.color = "yellow"
            }
            onExited: {
                animal.opacity = 0.9
                animalRect.border.color = "initialBorderColor"
            }
        }
    }

    states: [
        State {
            name: "toLeftTarget"
            ParentChange {
                target: animal
                parent: leftArea
            }
            PropertyChanges {
                target: animal
                x: (leftArea.width - animal.width) * 0.5
                y: (leftArea.height - animal.height) * 0.5
            }
        },
        State {
            name: "toRightTarget"
            ParentChange {
                target: animal
                parent: rightArea
            }
            PropertyChanges {
                target: animal
                x: (leftArea.width - animal.width) * 0.5
                y: (leftArea.height - animal.height) * 0.5
            }
        }
    ]

    Behavior on x {
        PropertyAnimation { easing.type: Easing.OutQuad; duration: 1000 }
    }
    Behavior on y {
        PropertyAnimation { easing.type: Easing.OutQuad; duration: 1000 }
    }
}
