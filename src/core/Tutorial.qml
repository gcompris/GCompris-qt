/* GCompris - Tutorial.qml
 *
 * SPDX-FileCopyrightText: 2017 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/*
 * A QML component for tutorial in activity in GCompris.
 *
 * Use Tutorial when you want to add a tutorial section which contains instructions and images.
 *
 * Contains the following basic layout elements: text (instructions), a Skip,
 * a Next and a Previous button to leave the tutorial or navigate through it.
 * The skipPressed, nextPressed, previousPressed signals are emitted when user clicks on skip, next and previous button respectively.
 *
 */

/* To use the component add:
 * Tutorial {
 * id: tutorialSection
 * source: "sourceForTutorialBackgroundImage"
 * tutorialDetails: Activity.tutorialInstructions
 * onSkipPressed: {
 *      Activity.initLevel()
 *   }
 * }
 */
import QtQuick 2.12
import GCompris 1.0
import "core.js" as Core

Item {
    id: tutorialSection
    anchors.fill: parent
    focus: true

    /* type: int
     * Counter for tutorial instructions
     */
    property int tutorialNumber: 0

    /* Container for all the tutorial instructions */
    property var tutorialDetails

    /* Do we use image or qml files for illustrations */
    property bool useImage: true

    // Emitted when skipButton is clicked
    signal skipPressed

    // Emitted when nextButton is clicked
    signal nextPressed

    // Emitted when previousButton is clicked
    signal previousPressed

    Keys.onPressed: {
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

    Keys.onEscapePressed: {
        skipButton.clicked();
        event.accepted = true;
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Back) {
            skipButton.clicked();
            event.accepted = true;
        }
    }

    // Tutorial instructions
    GCText {
        id: tutorialText
        anchors.verticalCenter: tutorialTextContainer.verticalCenter
        anchors.left: Core.isLeftToRightLocale(ApplicationSettings.locale) ? tutorialTextContainer.left : undefined
        anchors.right: Core.isLeftToRightLocale(ApplicationSettings.locale) ? undefined : tutorialTextContainer.right
        anchors.leftMargin: 10 * ApplicationInfo.ratio
        anchors.rightMargin: 10 * ApplicationInfo.ratio
        text: tutorialDetails ? tutorialDetails[tutorialNumber].instruction : ""
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        horizontalAlignment: Core.isLeftToRightLocale(ApplicationSettings.locale) ? Text.AlignLeft : Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        width: parent.width - 40 * ApplicationInfo.ratio
        height: 0.25 * parent.height
        wrapMode: Text.WordWrap
        z: 2
    }

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: tutorialTextContainer
        anchors.top: parent.top
        anchors.topMargin: 10 * ApplicationInfo.ratio
        anchors.horizontalCenter: parent.horizontalCenter
        width: tutorialText.paintedWidth + 20 * ApplicationInfo.ratio
        height: tutorialText.paintedHeight + 10 * ApplicationInfo.ratio
        opacity: 0.8
        radius: 10
        border.width: 6
        color: "white"
        border.color: "#87A6DD"
    }

    // previousButton: It emits skipPressed and navigates to previous tutorial when clicked
    IntroButton {
        id: previousButton
        width: parent.width / 4
        height: 90
        z: 5
        anchors.right: nextButton.left
        anchors.topMargin: 15
        anchors.rightMargin: 15
	    anchors.top: tutorialTextContainer.bottom
        visible: tutorialNumber != 0

        text: qsTr("Previous")

        onClicked: {
            --tutorialNumber
            previousPressed()
        }
    }

    // nextButton: It emits nextPressed which navigates to next tutorial when clicked
    IntroButton {
        id: nextButton
        width: parent.width / 4
        height: 90
        z: 5
        anchors.right: skipButton.left
        anchors.topMargin: 15
        anchors.rightMargin: 15
	    anchors.top: tutorialTextContainer.bottom
        visible: tutorialNumber != (tutorialDetails.length - 1)

        text: qsTr("Next")

        onClicked: {
	        ++tutorialNumber
            nextPressed()
        }
    }

    // skipButton: It emits the skipPressed signal which calls the initLevel to close the tutorial when clicked.
    IntroButton {
        id: skipButton
        width: parent.width / 4
        height: 90
        z: 5
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.topMargin: 15
	    anchors.top: tutorialTextContainer.bottom

        text: nextButton.visible ? qsTr("Skip") : qsTr("Start")

        onClicked: {
            tutorialSection.visible = false
	        skipPressed()
	    }
    }

    // Image component for tutorial instructions
    Image {
        id: tutorialImage
        visible: useImage
        width: parent.width * 0.8
        height: (parent.height - nextButton.height) * 0.48
        sourceSize.height: height
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        source: tutorialDetails && useImage ? tutorialDetails[tutorialNumber].instructionImage : ""
        anchors {
            top: previousButton.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }

    // Alternative QML component for tutorial instructions
    Loader {
        id: tutorialQml
        enabled: !tutorialImage.visible
        width: parent.width * 0.8
        height: (parent.height - nextButton.height) * 0.48
        source: tutorialDetails && !useImage ? tutorialDetails[tutorialNumber].instructionQml : ""
        anchors {
            top: previousButton.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }
}
