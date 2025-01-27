/*GCompris - IntroMessage.qml
*
*   SPDX-FileCopyrightText: 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*
*   Siddhesh suthar <siddhesh.it@gmail.com>
*   Sagar Chand Agarwal <atomsagar@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
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
 * To set a specific area for the text, set the customIntroArea item.
 *
 * @ingroup components
 * @inherit QtQuick.Item
 */

Item {
    id: message
    focus: true
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
    property var intro

    property Item customIntroArea: null

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Left && previousButton.visible) {
            previousButton.clicked();
        } else if(event.key === Qt.Key_Right && nextButton.visible) {
            nextButton.clicked();
        } else if(event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            skipButton.clicked();
        } else if(event.key === Qt.Key_Space) {
            if(nextButton.visible) {
                nextButton.clicked();
            } else {
                skipButton.clicked();
            }
        }
        event.accepted = true;
    }

    Keys.onEscapePressed: (event) => {
        skipButton.clicked();
        event.accepted = true;
    }

    Keys.onReleased: (event) => {
        if(event.key === Qt.Key_Back) {
            skipButton.clicked();
            event.accepted = true;
        }
    }

    Item {
        id: introArea
        x: customIntroArea ? customIntroArea.x : 10 * ApplicationInfo.ratio
        y: customIntroArea ? customIntroArea.y : 10 * ApplicationInfo.ratio
        width: customIntroArea ? customIntroArea.width : parent.width - 20 * ApplicationInfo.ratio
        height: customIntroArea ? customIntroArea.height : parent.height - 10 * ApplicationInfo.ratio - bar.height * 2
    }

    // to avoid clicking on the activity
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: introTextContainer
        width: introArea.width
        height: introArea.height - nextButton.height - 10 * ApplicationInfo.ratio
        anchors.top: introArea.top
        anchors.horizontalCenter: introArea.horizontalCenter
        color: "white"
        border.color: "#87A6DD"
        border.width: 3 * ApplicationInfo.ratio
        radius: 5 * ApplicationInfo.ratio
    }

    GCText {
        id: introText
        anchors.fill: introTextContainer
        anchors.margins: 10 * ApplicationInfo.ratio
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        minimumPixelSize: 7
        wrapMode: Text.WordWrap
        fontSizeMode: Text.Fit
        text: parent.index != -1 && parent.intro[parent.index] ? parent.intro[parent.index] : ""
    }

    IntroButton {
        id: previousButton
        width: nextButton.width
        height: nextButton.height
        z: 5
        anchors.left: introTextContainer.left
        anchors.top: introTextContainer.bottom
        anchors.topMargin: introText.anchors.margins
        visible: index != 0

        text: qsTr("Previous")

        onClicked: --index;
    }

    IntroButton {
        id: nextButton
        width: (introArea.width - 20 * ApplicationInfo.ratio) * 0.33
        height: Math.min(60 * ApplicationInfo.ratio, parent.height * 0.2)
        z: 5
        anchors.horizontalCenter: introTextContainer.horizontalCenter
        anchors.top: introTextContainer.bottom
        anchors.topMargin: introText.anchors.margins
        visible: index != (intro.length - 1)

        text: qsTr("Next")

        onClicked: index++;
    }

    IntroButton {
        id: skipButton
        width: nextButton.width
        height: nextButton.height
        z: 5
        anchors.right: introTextContainer.right
        anchors.top: introTextContainer.bottom
        anchors.topMargin: introText.anchors.margins

        text: nextButton.visible ? qsTr("Skip") : qsTr("Start")

        onClicked: {
            index = -1;
            message.introDone();
        }
    }
}
