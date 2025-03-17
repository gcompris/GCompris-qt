/* GCompris - Animal.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "left_right_click.js" as Activity

Item {
    id: animal
    z: 10
    visible: !animalInvisible ? true : false
    property bool clicked: false
    height: width

    Rectangle {
        id: animalRect
        anchors.fill: parent
        color: "transparent"
        border.color: "transparent"
        border.width: GCStyle.thinBorder
        radius: GCStyle.halfMargins
        Image {
            width: parent.width - GCStyle.baseMargins
            height: height
            sourceSize.width: width
            source: imageSource
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            fillMode: Image.PreserveAspectFit
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
            to: GCStyle.lightBorder
            duration: 0
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            enabled: !animal.clicked
            onClicked: (mouse) => {
                // if left target animal is clicked with left click
                if((mouse.button === Qt.LeftButton) && (animalIdentifier === Activity.Position.left)) {
                    animal.clicked = true
                    animal.state = "toLeftTarget"
                    Activity.incrementCounter()
                    disappearAnimal.running = true
                }
                else if((mouse.button === Qt.RightButton) && (animalIdentifier === Activity.Position.right)) {
                    animal.clicked = true
                    animal.state = "toRightTarget"
                    Activity.incrementCounter()
                    disappearAnimal.running = true
                }
                else {
                    wrongClick()
                }
                triggerClick(mouse.button)
            }

            function triggerClick(mouseButton: int): void {
                if(mouseButton === Qt.LeftButton)
                    leftClickTrigger()
                else
                    rightClickTrigger()
            }

            hoverEnabled: enabled
            onEntered: {
                animalRect.border.color = GCStyle.lightBorder
            }
            onExited: {
                animalRect.border.color = "transparent"
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
                animal {
                    x: (leftArea.width - animal.width) * 0.5
                    y: (leftArea.height - animal.height) * 0.75
                }
            }
        },
        State {
            name: "toRightTarget"
            ParentChange {
                target: animal
                parent: rightArea
            }
            PropertyChanges {
                animal {
                    x: (leftArea.width - animal.width) * 0.5
                    y: (leftArea.height - animal.height) * 0.5
                }
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
