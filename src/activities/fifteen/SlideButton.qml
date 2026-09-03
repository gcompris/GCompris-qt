/* GCompris - SlideButton.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../core"
import "fifteen.js" as Activity

Item {
    id: slideButton
    required property int index
    property bool selected: items.selectedButton === slideButton
    width: buttonSize
    height: buttonSize
    enabled: !items.buttonsBlocked

    signal clicked

    required property int direction
    readonly property int leftDir: 0
    readonly property int rightDir: 1
    readonly property int bottomDir: 2
    readonly property int topDir: 3

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: slideButton.enabled
        onClicked: {
            items.selectedButton = null; // hide keyboard navigation after a click
            slideButton.clicked();
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: width
        color: "#33ffffff"
        border.color: slideButton.selected ? GCStyle.whiteBg : "#33000000"
        border.width: slideButton.selected ? GCStyle.midBorder : GCStyle.thinBorder
    }

    Image {
        id: arrowImage
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
    }

    onClicked: {
        switch (slideButton.direction) {
            case slideButton.leftDir:
                Activity.leftAction(slideButton.index, true);
                break;
            case slideButton.rightDir:
                Activity.rightAction(slideButton.index, true);
                break;
            case slideButton.bottomDir:
                Activity.bottomAction(slideButton.index, true);
                break;
            case slideButton.topDir:
                Activity.topAction(slideButton.index, true);
                break;
        }
        /* Check if success */
        if(Activity.isCorrectAnswer()) {
            items.buttonsBlocked = true
            items.bonus.good('flower')
        }
        else {
            items.flipSound.play()
        }
    }

    states: [
        State {
            name: "reset"
            when: !mouseArea.enabled
            PropertyChanges {
                arrowImage {
                    scale: 1.0
                }
            }
        },
        State {
            name: "notclicked"
            PropertyChanges {
                arrowImage {
                    scale: 1.0
                }
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                arrowImage {
                    scale: 0.9
                }
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                arrowImage {
                    scale: 1.1
                }
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
