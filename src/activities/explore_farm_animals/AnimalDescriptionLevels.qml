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
    radius: 15 * ApplicationInfo.ratio
    border.width: 3 * ApplicationInfo.ratio
    border.color: "#373737"

    MouseArea {
        anchors.fill: parent
        onPressed: parent.closeDescriptionPanel()
    }

    property alias title: heading.text
    property alias description: descriptionText.text
    property alias imageSource: animalImage.source
    property int baseMargins: 15 * ApplicationInfo.ratio

    property bool horizontalLayout: activityBackground.width >= activityBackground.height

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
        verticalAlignment: Text.AlignVCenter
        font.weight: Font.DemiBold
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: cancelButton.left
        anchors.margins: parent.baseMargins
        color: "#2a2a2a"
        height: cancelButton.height
        fontSizeMode: Text.Fit
    }

    Image {
        id: animalImage
        fillMode: Image.PreserveAspectFit
        anchors.margins: parent.baseMargins
        property bool zoomedOut: true

        MouseArea {
            anchors.fill: parent
            onClicked: parent.switchImageWithTextOrAlone()
        }

        states: [
            State {
                name: "zoomedIn"
                when: !animalImage.zoomedOut
                PropertyChanges {
                    animalImage {
                        width: rectangleDesc.width - 2 * rectangleDesc.baseMargins
                        height: rectangleDesc.height - heading.height - 3 * rectangleDesc.baseMargins
                    }
                }

                PropertyChanges {
                    descriptionText {
                        visible: false
                    }
                }

                AnchorChanges {
                    target: animalImage
                    anchors.top: heading.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            },
            State {
                name: "zoomedOutHorizontal"
                when: animalImage.zoomedOut && rectangleDesc.horizontalLayout
                PropertyChanges {
                    animalImage {
                        width: (rectangleDesc.width - 3 * rectangleDesc.baseMargins) * 0.5
                        height: rectangleDesc.height - heading.height - 3 * rectangleDesc.baseMargins
                    }
                }

                PropertyChanges {
                    descriptionText {
                        visible: true
                    }
                }

                AnchorChanges {
                    target: animalImage
                    anchors.top: heading.bottom
                    anchors.horizontalCenter: undefined
                    anchors.left: rectangleDesc.left
                }
                AnchorChanges {
                    target: descriptionText
                    anchors.left: animalImage.right
                }
            },
            State {
                name: "zoomedOutVertical"
                when: animalImage.zoomedOut && !rectangleDesc.horizontalLayout
                PropertyChanges {
                    animalImage {
                        width: rectangleDesc.width - 2 * rectangleDesc.baseMargins
                        height: (rectangleDesc.height - heading.height - 4 * rectangleDesc.baseMargins) * 0.5
                        anchors.leftMargin: 0
                    }
                }

                PropertyChanges {
                    descriptionText {
                        visible: true
                    }
                }

                AnchorChanges {
                    target: animalImage
                    anchors.top: descriptionText.bottom
                    anchors.horizontalCenter: rectangleDesc.horizontalCenter
                    anchors.left: undefined
                }
                AnchorChanges {
                    target: descriptionText
                    anchors.left: rectangleDesc.left
                }
            }
        ]

        // Transition to animate zoom-in and zoom-out
        transitions: [
            Transition {
                from: "zoomedOutVertical"
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
                to: "zoomedOutVertical"

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
            },
            Transition {
                from: "zoomedOutHorizontal"
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
                to: "zoomedOutHorizontal"

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
           zoomedOut = !zoomedOut
        }
    }

    GCText {
        id: descriptionText
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignJustify
        anchors.top: heading.bottom
        anchors.margins: parent.baseMargins
        color: "#2a2a2a"
        width: animalImage.width
        height: animalImage.height
        wrapMode: Text.WordWrap
    }

    // The close panel button
    GCButtonCancel {
        id: cancelButton
        onClose: parent.closeDescriptionPanel()
    }

    function close() {
        if(!animalImage.zoomedOut) {
            animalImage.zoomedOut = true;
        }
        descriptionPanelCloseAnimation.start();
        if (Activity.isComplete() && !items.descriptionBonusDone) {
            items.descriptionBonusDone = true;
            items.buttonsBlocked = true;
            items.bonus.good("flower");
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
