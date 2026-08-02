/* GCompris - SlideButton.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../core"
import "fifteen.js" as Activity

BarButton {
    id: slideButton
    required property int index
    source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
    width: buttonSize

    enabled: !items.buttonsBlocked

    required property int direction
    readonly property int leftDir: 0
    readonly property int rightDir: 1
    readonly property int bottomDir: 2
    readonly property int topDir: 3

    Rectangle {
        anchors.fill: parent
        radius: width * 0.5
        color: GCStyle.whiteBg
        border.color: "#000000"
        border.width: GCStyle.thinBorder
        opacity: 0.2
    }
    onClicked: {
        switch (slideButton.direction) {
            case slideButton.leftDir:
            Activity.leftAction(slideButton.index);
            break;
            case slideButton.rightDir:
            Activity.rightAction(slideButton.index);
            break;
            case slideButton.bottomDir:
            Activity.bottomAction(slideButton.index);
            break;
            case slideButton.topDir:
            Activity.topAction(slideButton.index);
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
}
