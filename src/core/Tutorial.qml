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
import core 1.0
import "core.js" as Core

Item {
    id: tutorialSection
    anchors.fill: parent
    anchors.margins: GCStyle.baseMargins
    anchors.bottomMargin: bar.height * 1.2
    focus: true

    /* type: int
     * Counter for tutorial instructions
     */
    property int tutorialNumber: 0

    /* Container for all the tutorial instructions */
    property var tutorialDetails

    /* Do we use image or qml files for illustrations */
    property bool useImage: true

    /* Store if we have a LTR locale */
    readonly property bool isLeftToRightLocale: Core.isLeftToRightLocale(ApplicationSettings.locale)

    /* Used to access the tutoriaQml item if needed */
    property Item tutorialQml: tutorialQml.item

    // Emitted when skipButton is clicked
    signal skipPressed

    // Emitted when nextButton is clicked
    signal nextPressed

    // Emitted when previousButton is clicked
    signal previousPressed

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

    Rectangle {
        id: tutorialTextContainer
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: tutorialImage.source == "" && tutorialQml.source == "" ? parent.height * 0.5 : parent.height * 0.25
        color: GCStyle.whiteBg
        radius: GCStyle.halfMargins
        border.width: GCStyle.midBorder
        border.color: GCStyle.blueBorder
    }

    // Tutorial instructions
    GCText {
        id: tutorialText
        anchors.fill: tutorialTextContainer
        anchors.topMargin: GCStyle.halfMargins
        anchors.bottomMargin: GCStyle.halfMargins
        anchors.leftMargin: GCStyle.baseMargins
        anchors.rightMargin: GCStyle.baseMargins
        text: tutorialDetails ? tutorialDetails[tutorialNumber].instruction : ""
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        horizontalAlignment: isLeftToRightLocale ? Text.AlignLeft : Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        readonly property bool isLeftToRightLocale: Core.isLeftToRightLocale(ApplicationSettings.locale)
    }

    MouseArea {
        anchors.fill: parent
    }

    // previousButton: It emits skipPressed and navigates to previous tutorial when clicked
    IntroButton {
        id: previousButton
        width: (parent.width - 2 * GCStyle.baseMargins) * 0.33
        height: Math.min(45 * ApplicationInfo.ratio, parent.height * 0.2)
        anchors.left: parent.left
        anchors.top: tutorialTextContainer.bottom
        anchors.topMargin: GCStyle.baseMargins
        visible: tutorialSection.tutorialNumber != 0
        text: qsTr("Previous")

        onClicked: {
            --tutorialSection.tutorialNumber
            previousPressed()
        }
    }

    // nextButton: It emits nextPressed which navigates to next tutorial when clicked
    IntroButton {
        id: nextButton
        width: previousButton.width
        height: previousButton.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: tutorialTextContainer.bottom
        anchors.topMargin: GCStyle.baseMargins
        visible: tutorialSection.tutorialNumber != (tutorialSection.tutorialDetails.length - 1)

        text: qsTr("Next")

        onClicked: {
            ++tutorialSection.tutorialNumber
            nextPressed()
        }
    }

    // skipButton: It emits the skipPressed signal which calls the initLevel to close the tutorial when clicked.
    IntroButton {
        id: skipButton
        width: previousButton.width
        height: previousButton.height
        anchors.right: parent.right
        anchors.top: tutorialTextContainer.bottom
        anchors.topMargin: GCStyle.baseMargins

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
        sourceSize.height: height
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        source: tutorialSection.tutorialDetails && useImage ? tutorialSection.tutorialDetails[tutorialSection.tutorialNumber].instructionImage : ""
        anchors {
            top: skipButton.bottom
            topMargin: GCStyle.baseMargins
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    // Alternative QML component for tutorial instructions
    Loader {
        id: tutorialQml
        enabled: !tutorialImage.visible
        source: tutorialSection.tutorialDetails && !useImage ? tutorialSection.tutorialDetails[tutorialSection.tutorialNumber].instructionQml : ""
        anchors {
            top: skipButton.bottom
            topMargin: GCStyle.baseMargins
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
