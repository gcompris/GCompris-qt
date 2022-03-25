/* GCompris - AnimalDescriptionLevels.qml
*
* SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "explore-level.js" as Activity

Rectangle {
    id: rectangleDesc
    radius: 30
    border.width: 5
    border.color: "black"

    MouseArea {
        anchors.fill: parent
        onPressed: parent.closeDescriptionPanel()
    }

    property alias title: heading.text
    property alias description: descriptionText.text
    property alias imageSource: animalImage.source

    property bool horizontalLayout: background.width >= background.height

    signal showDescriptionPanel
    signal closeDescriptionPanel

    onShowDescriptionPanel: {
        descriptionPanelCloseAnimation.stop()
        descriptionPanelAppearAnimation.start()
    }

    onCloseDescriptionPanel: {
        descriptionPanelAppearAnimation.stop()
        close()
    }

    // animation for appearance of the description panel
    NumberAnimation {
        id: descriptionPanelAppearAnimation
        target: descriptionPanel
        property: "x"
        from: -width
        to: 0
        duration: 1200
        easing.type: Easing.OutBack
    }

    GCText {
        id: heading
        fontSize: largeSize
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        anchors.top: parent.top
        color: "#2a2a2a"
        width: parent.width - cancelButton.width
        wrapMode: Text.WordWrap
    }

    Image {
        id: animalImage
        width: rectangleDesc.horizontalLayout ? parent.width / 2 : parent.width * 0.9
        height: rectangleDesc.horizontalLayout ?
                    parent.height * 0.8 :
                    (parent.height - heading.height - descriptionText.height) * 0.9
        fillMode: Image.PreserveAspectFit
        anchors {
            top: rectangleDesc.horizontalLayout ? heading.bottom : descriptionText.bottom
            horizontalCenter: rectangleDesc.horizontalLayout ? undefined : parent.horizontalCenter
            left: rectangleDesc.horizontalLayout ? parent.left : undefined
            leftMargin: rectangleDesc.horizontalLayout ? 30 * ApplicationInfo.ratio : 0
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.switchImageWithTextOrAlone()
        }

        state: "zoomedOut"

        // Relative width and height of the image is changed on zooming-in and zooming-out keeping original binding intact
        states: [
            State {
                name: "zoomedIn"
                PropertyChanges {
                    target: animalImage
                    width: rectangleDesc.width / 1.2
                    height: rectangleDesc.height / 1.2
                }

                PropertyChanges {
                    target: descriptionText
                    visible: false
                }

                AnchorChanges {
                    target: animalImage
                    anchors.top: heading.bottom
                }
            },
            State {
                name: "zoomedOut"
                PropertyChanges {
                    target: animalImage
                    width: rectangleDesc.horizontalLayout ? parent.width / 2 : parent.width * 0.9
                    height: rectangleDesc.horizontalLayout ?
                                       parent.height * 0.8 :
                                       (parent.height - heading.height - descriptionText.height) * 0.9
                }

                PropertyChanges {
                    target: descriptionText
                    visible: true
                }

                AnchorChanges {
                    target: animalImage
                    anchors.top: rectangleDesc.horizontalLayout ? heading.bottom : descriptionText.bottom
                }
            }
        ]

        // Transition to animate zoom-in and zoom-out
        transitions: [
            Transition {
                from: "zoomedOut"
                to: "zoomedIn"

                NumberAnimation {
                    target: animalImage
                    properties: "width, height"
                    easing.type: Easing.OutBack
                    duration: 500
                }

                AnchorAnimation { duration: 250 }
            },
            Transition {
                from: "zoomedIn"
                to: "zoomedOut"

                NumberAnimation {
                    target: animalImage
                    properties: "width, height"
                    duration: 250
                }

                PropertyAnimation {
                    target: descriptionText
                    property: "visible"
                }

                AnchorAnimation { duration: 250 }
            }
        ]

        // Changes the state of the image
        function switchImageWithTextOrAlone() {
           if(state === "zoomedOut") {
              state = "zoomedIn";
           }
           else {
              state = "zoomedOut";
           }
        }
    }

    GCText {
        id: descriptionText
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignJustify
        anchors {
            top: (heading.height > cancelButton.height) ? heading.bottom : cancelButton.bottom
            right: parent.right
            rightMargin: 30 * ApplicationInfo.ratio
            left: rectangleDesc.horizontalLayout ? animalImage.right : parent.left
            leftMargin: 30 * ApplicationInfo.ratio
        }
        color: "#2a2a2a"
        width: rectangleDesc.horizontalLayout ? parent.width * 0.45 : parent.width
        height: rectangleDesc.horizontalLayout ? parent.height * 0.5 : parent.height * 0.3
        wrapMode: Text.WordWrap
    }

    // The close panel button
    GCButtonCancel {
        id: cancelButton
        onClose: parent.closeDescriptionPanel()
    }

    function close() {
        if(animalImage.state === "zoomedIn") {
            animalImage.state = "zoomedOut";
        }
        descriptionPanelCloseAnimation.start();
        if (Activity.isComplete()) {
            Activity.items.bonus.good("flower");
            Activity.nextLevel();
        }
    }

    SequentialAnimation {
        id: descriptionPanelCloseAnimation

        NumberAnimation {
            id: slideBackDescriptionPanel
            target: descriptionPanel
            property: "x"
            to: -width
            duration: 1200
            easing.type: Easing.InSine
        }

        PropertyAnimation {
            id: switchDescriptionPanelInvisible
            target: descriptionPanel
            property: "visible"
            to: false
        }
   }

}
