/* GCompris - FilesPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"
import "sketch.js" as Activity

FoldablePanel {
    id: filesPanel
    handleOffset: 0
    icon1Source: "qrc:/gcompris/src/activities/sketch/resource/filesMenu.svg"
    icon2Source: ""

    Column {
        id: panelLayout
        anchors.fill: parent
        anchors.margins: items.baseMargins
        spacing: items.baseMargins

        readonly property int lineHeight: height * 0.15
        readonly property int buttonSize: Math.min(lineHeight, ApplicationInfo.ratio * 60)

        Item {
            width: parent.width
            height: panelLayout.lineHeight

            SelectionButton {
                id: saveButton
                buttonSize: panelLayout.buttonSize
                isButtonSelected: false
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileSave.svg"
                onButtonClicked: {
                    Activity.saveImageDialog();
                }
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            GCText {
                id: saveImageLabel
                text: qsTr("Save your image")
                color: items.contentColor
                fontSize: regularSize
                fontSizeMode: Text.Fit
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: saveButton.left
                anchors.margins: items.baseMargins
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onPressed: saveButton.buttonPressed();
                    onReleased: saveButton.buttonReleased();
                    onClicked: saveButton.buttonClicked();
                }
            }
        }

        Item {
            width: parent.width
            height: panelLayout.lineHeight

            SelectionButton {
                id: openButton
                buttonSize: panelLayout.buttonSize
                isButtonSelected: false
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileOpen.svg"
                onButtonClicked: {
                    Activity.openImageDialog();
                }
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            GCText {
                id: openImageLabel
                text: qsTr("Open an image")
                color: items.contentColor
                fontSize: regularSize
                fontSizeMode: Text.Fit
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: openButton.left
                anchors.margins: items.baseMargins
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onPressed: openButton.buttonPressed();
                    onReleased: openButton.buttonReleased();
                    onClicked: openButton.buttonClicked();
                }
            }
        }

        Rectangle {
            id: verticalSpacer1
            color: items.contentColor
            opacity: 0.5
            width: parent.width
            height: ApplicationInfo.ratio
        }

        GCText {
            id: createImageLabel
            text: qsTr("New image settings")
            color: items.contentColor
            fontSize: regularSize
            fontSizeMode: Text.Fit
            height: panelLayout.lineHeight
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: items.baseMargins
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            width: parent.width
            height: panelLayout.lineHeight

            Rectangle {
                id: bgColorButton
                width: panelLayout.buttonSize
                height: panelLayout.buttonSize
                radius: items.baseMargins
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: backgroundColorSelector.newBackgroundColor
                border.color: items.contentColor
            }

            GCText {
                text: qsTr("Background color")
                color: items.contentColor
                fontSize: regularSize
                fontSizeMode: Text.Fit
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: bgColorButton.left
                anchors.margins: items.baseMargins
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    backgroundColorSelector.visible = true;
                    displayDialog(backgroundColorSelector);
                }
            }
        }

        Item {
            width: parent.width
            height: panelLayout.lineHeight

            Rectangle {
                id: bgImageButton
                width: panelLayout.buttonSize
                height: panelLayout.buttonSize
                radius: items.baseMargins
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                border.color: items.contentColor

                Image {
                    anchors.fill: parent
                    anchors.margins: items.baseMargins
                    fillMode: Image.PreserveAspectFit
                    source: items.backgroundToLoad
                }

            }

            GCText {
                text: qsTr("Background image")
                color: items.contentColor
                fontSize: regularSize
                fontSizeMode: Text.Fit
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: bgImageButton.left
                anchors.margins: items.baseMargins
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    backgroundSelector.visible = true;
                    displayDialog(backgroundSelector);
                }
            }
        }

        Item {
            width: parent.width
            height: panelLayout.lineHeight

            SelectionButton {
                id: newButton
                buttonSize: panelLayout.buttonSize
                isButtonSelected: false
                iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileNew.svg"
                onButtonClicked: {
                    Activity.requestNewImage();
                    filesPanel.forceClose();
                }
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            GCText {
                id: newImageLabel
                text: qsTr("Create a new image")
                color: items.contentColor
                fontSize: regularSize
                fontSizeMode: Text.Fit
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: newButton.left
                anchors.margins: items.baseMargins
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onPressed: newButton.buttonPressed();
                    onReleased: newButton.buttonReleased();
                    onClicked: newButton.buttonClicked();
                }
            }
        }
    }
}
