/*GCompris-Qt IntroMessage.qml
*   Copyright (C) 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*
*   Siddhesh suthar <siddhesh.it@gmail.com>
*   Sagar Chand Agarwal <atomsagar@gmail.com>
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
import GCompris 1.0

/**
 * A QML component for multi activity introduction in GCompris.
 * The signal emitted named as introDone helps in the occurrence
 * of events to be followed in the start of the activity.
 * @ingroup components
 *
 * Contains the following basic layout elements: Introduction (intro_text), a skip
 * button (skipButton) and Iterate (or Go) button (button).
 *
 */

Item {
    id: message

    visible: index == -1 ? false : true

    /**
     * Emitted when the index of intro is equal to its length
     * or when skipButton is clicked.
     */
    signal introDone

    /**
     * The index of the intro array, set to -1 to hide the IntroMessage item.
     */
    property int index: 0

    /**
     * intro is the texts array used as introduction .
     * It has to be filled by the user when defining an IntroMessage item.
     */
    property variant intro;

    Rectangle {
        id: intro_textbg
        x: intro_text.x - 4
        y: intro_text.y - 4
        width: intro_text.width + 4
        height: intro_text.height + 4
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 2
        radius: 8
    }

    GCText {
        id: intro_text
        fontSize: regularSize
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: parent.top
            topMargin: 10 * ApplicationInfo.ratio
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            left: parent.left
            leftMargin: 5 * ApplicationInfo.ratio
        }
        width: parent.width
        wrapMode: Text.WordWrap
        text: parent.index == -1 ? "" : parent.intro[parent.index]
    }

    /* Inlined Button User Interface for Next (or Let's go). */

    Rectangle {
        id: button
        width: Math.max(skipText.width, nextText.width) * 1.2
        height: Math.max(skipText.height, nextText.height) * 1.4
        x: intro_textbg.x + (intro_textbg.width/2) + 20
        y: intro_textbg.y + intro_textbg.height - button.height - 5
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5

        anchors.top : intro_textbg.bottom
        anchors.topMargin: 10

        GCText {
            id: nextText
            anchors.centerIn: parent
            text: index != (intro.length - 1) ? qsTr("Next") : qsTr("Let's go")
        }

        MouseArea {
            id: button_area
            anchors.fill: button
            onClicked: {
                if(index <= (intro.length - 2))
                {
                    index++
                }
                else {
                    index = -1
                    message.introDone()
                }
            }
        }
    }

    /* Inlined Button User Interface for Skip . */

    Rectangle {
        id: skipButton
        width: button.width
        height: button.height
        x: intro_textbg.x + (intro_textbg.width/2) - 20 - skipButton.width
        y: intro_textbg.y + intro_textbg.height - skipButton.height - 5
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5

        anchors.top : intro_textbg.bottom
        anchors.topMargin: 10
        GCText {
            id: skipText
            anchors.centerIn: parent
            text: qsTr("Skip Instruction")
        }

        MouseArea {
            id: skipButton_area
            anchors.fill: parent
            onClicked: {
                index = -1
                message.introDone()
            }
        }
    }
}
