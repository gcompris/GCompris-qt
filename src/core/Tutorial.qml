/* GCompris - Tutorial.qml
 *
 * Copyright (C) 2017 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
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
import QtQuick 2.6
import GCompris 1.0

Item {
    id: tutorialSection
    anchors.fill: parent

    /* type: int
     * Counter for tutorial instructions
     */
    property int tutorialNumber: 0

    /* Container for all the tutorial instructions */
    property var tutorialDetails

    // Emitted when skipButton is clicked
    signal skipPressed

    // Emitted when nextButton is clicked
    signal nextPressed

    // Emitted when previousButton is clicked
    signal previousPressed

    // Tutorial instructions
    GCText {
        id: tutorialText
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 10
        }
        text: tutorialDetails ? tutorialDetails[tutorialNumber].instruction : ""
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        color: "black"
        horizontalAlignment: Text.AlignHLeft
        width: Math.min(implicitWidth, 0.8 * parent.width)
        height: Math.min(implicitHeight, 0.25 * parent.height)
        wrapMode: TextEdit.WordWrap
        z: 2
    }

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: tutorialTextContainer
        anchors.top: tutorialText.top
        anchors.horizontalCenter: tutorialText.horizontalCenter
        width: tutorialText.width + 20
        height: tutorialText.height + 2
        opacity: 0.8
        radius: 10
        border.width: 6
        color: "white"
        border.color: "#87A6DD"
    }

    // previousButton: It emits skipPressed and navigates to previous tutorial when clicked
    Rectangle {
        id: previousButton
        width: 180
        height: 90
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5
        anchors.right: nextButton.left
        anchors.topMargin: 15
        anchors.rightMargin: 15
	    anchors.top: tutorialTextContainer.bottom
        visible: tutorialNumber != 0

        GCText {
            id: previousButtonText
            anchors.centerIn: parent
            text: qsTr("Previous")
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: previousButtonArea
            anchors.fill: parent
            onClicked: {
                --tutorialNumber
                previousPressed()
            }
        }
        states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: previousButton
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: previousButtonArea.pressed
            PropertyChanges {
                target: previousButton
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: previousButtonArea.containsMouse
            PropertyChanges {
                target: previousButton
                scale: 1.1
            }
        }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
    }

    // nextButton: It emits nextPressed which navigates to next tutorial when clicked
    Rectangle {
        id: nextButton
        width: 150
        height: 90
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5
        anchors.right: skipButton.left
        anchors.topMargin: 15
        anchors.rightMargin: 15
	    anchors.top: tutorialTextContainer.bottom
        visible: tutorialNumber != (tutorialDetails.length - 1)

        GCText {
            id: nextButtonText
            anchors.centerIn: parent
            text: qsTr("Next")
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: nextButtonArea
            anchors.fill: parent
            onClicked: {
	            ++tutorialNumber
                nextPressed()
            }
        }
        states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: nextButton
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: button_area.pressed
            PropertyChanges {
                target: nextButton
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: nextButtonArea.containsMouse
            PropertyChanges {
                target: nextButton
                scale: 1.1
            }
        }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
    }

    // skipButton: It emits the skipPressed signal which calls the initLevel to close the tutorial when clicked.
    Rectangle {
        id: skipButton
        width: 150
        height: 90
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.topMargin: 15
	    anchors.top: tutorialTextContainer.bottom

        GCText {
            id: skipButtonText
            anchors.centerIn: parent
            text: qsTr("Skip")
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: skipButtonArea
            anchors.fill: parent
            onClicked: {
                tutorialSection.visible = false
	            skipPressed()
	        }
        }
        states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: skipButton
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: skipButtonArea.pressed
            PropertyChanges {
                target: skipButton
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: skipButtonArea.containsMouse
            PropertyChanges {
                target: skipButton
                scale: 1.1
            }
        }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
    }

    // Image component for tutorial instructions
    Image {
        id: tutorialImage
        width: parent.width * 0.8
        height: (parent.height - nextButton.height) * 0.6
        fillMode: Image.PreserveAspectFit
        source: tutorialDetails ? tutorialDetails[tutorialNumber].instructionImage : ""
        anchors {
            top: previousButton.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }
}
