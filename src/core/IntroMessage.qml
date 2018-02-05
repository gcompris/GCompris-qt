/*GCompris - IntroMessage.qml
*
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

import QtQuick 2.6
import GCompris 1.0

/**
 * A QML component for multi activity introduction in GCompris.
 *
 * Use IntroMessage when you want to present an introductory message to the
 * user, that provides background information or gameplay hints.
 *
 * Contains the following basic layout elements: Introduction text (intro), a
 * skip and an @c Next button to leave the introduction or navigate through it.
 * The introDone signal is emitted when the introduction has finished and can
 * be used to prepare the start of the activity.
 *
 * @ingroup components
 * @inherit QtQuick.Item
 */

Item {
    id: message

    anchors.fill: parent
    visible: index == -1 ? false : true

    /**
     * Emitted when the index of intro is equal to its length
     * or when skipButton is clicked.
     */
    signal introDone

    /**
     * The index of the intro array.
     *
     * Set to -1 to hide the IntroMessage item.
     */
    property int index: 0

    /**
     * The texts array used as introduction.
     *
     * It has to be filled by the user when defining an IntroMessage item.
     */
    property var intro;

    property int textContainerWidth: 0.9 * parent.width
    property int textContainerHeight: 0.75 * parent.height - nextButton.height

    // to avoid clicking on the activity
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: introTextContainer
        width: introText.width + 20
        height: introText.height + 2
        anchors.top: introText.top
        anchors.horizontalCenter: introText.horizontalCenter
        opacity: 0.9
        color: "white"
        border.color: "#87A6DD"
        border.width: 6
        radius: 10
    }

    GCText {
        id: introText
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 10
        }
        width: textContainerWidth
        height: textContainerHeight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "black"
        minimumPixelSize: 10
        wrapMode: Text.WordWrap
        fontSizeMode: Text.Fit
        text: parent.index == -1 ? "" : parent.intro[parent.index]
    }

    IntroButton {
        id: previousButton
        width: parent.width / 4
        height: 90
        z: 5
        anchors.right: nextButton.left
        anchors.topMargin: 15
        anchors.rightMargin: 15
	    anchors.top: introTextContainer.bottom
        visible: index != 0

        text: qsTr("Previous")

        onClicked: --index
    }

    IntroButton {
        id: nextButton
        width: parent.width / 4
        height: 90
        z: 5
        anchors.right: skipButton.left
        anchors.topMargin: 15
        anchors.rightMargin: 15
	    anchors.top: introTextContainer.bottom
        visible: index != (intro.length - 1)

        text: qsTr("Next")

        onClicked: index++
    }

    IntroButton {
        id: skipButton
        width: parent.width / 4
        height: 90
        z: 5
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.topMargin: 15
	    anchors.top: introTextContainer.bottom

        text: qsTr("Skip")

        onClicked: {
            index = -1
            message.introDone()
	    }
    }
}
