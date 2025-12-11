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

    readonly property int maxColumnWidth: width - GCStyle.baseMargins
    readonly property int lineHeight: Math.min(50 * ApplicationInfo.ratio, height * 0.14)

    Column {
        id: panelColumn1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.margins: GCStyle.halfMargins
        spacing: GCStyle.halfMargins

        GCLabelButton {
            id: saveButton
            maxWidth: filesPanel.maxColumnWidth
            height: filesPanel.lineHeight
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileSave.svg"
            text: qsTr("Save your image")
            textColor: GCStyle.contentColor

            onClicked: Activity.saveImageDialog();
        }

        GCLabelButton {
            id: openButton
            maxWidth: filesPanel.maxColumnWidth
            height: filesPanel.lineHeight
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileOpen.svg"
            text: qsTr("Open an image")
            textColor: GCStyle.contentColor

            onClicked: Activity.openImageDialog();
        }
    }

    Rectangle {
        id: verticalSpacer1
        color: GCStyle.contentColor
        opacity: 0.5
        width: filesPanel.maxColumnWidth
        height: GCStyle.thinnestBorder
        anchors.top: panelColumn1.bottom
        anchors.topMargin: GCStyle.halfMargins
    }

    GCText {
        id: createImageLabel
        text: qsTr("New image settings")
        color: GCStyle.contentColor
        fontSize: regularSize
        fontSizeMode: Text.Fit
        height: filesPanel.lineHeight
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: verticalSpacer1.bottom
        anchors.margins: GCStyle.halfMargins
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Column {
        id: panelColumn2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: createImageLabel.bottom
        anchors.margins: GCStyle.halfMargins
        spacing: GCStyle.halfMargins

        GCLabelButton {
            id: bgColorButton
            maxWidth: filesPanel.maxColumnWidth
            height: filesPanel.lineHeight
            iconSource: ""
            text: qsTr("Background color")
            textColor: GCStyle.contentColor

            onClicked: {
                backgroundColorSelector.visible = true;
                displayDialog(backgroundColorSelector);
            }

            Rectangle {
                id: bgColorRect
                width: filesPanel.lineHeight
                height: filesPanel.lineHeight
                x: bgColorButton.buttonIcon.x
                scale: bgColorButton.buttonIcon.scale
                radius: GCStyle.halfMargins
                color: backgroundColorSelector.newBackgroundColor
                border.color: GCStyle.contentColor
            }
        }

        GCLabelButton {
            id: bgImageButton
            maxWidth: filesPanel.maxColumnWidth
            height: filesPanel.lineHeight
            iconSource: ""
            text: qsTr("Background image")
            textColor: GCStyle.contentColor

            onClicked: {
                backgroundSelector.visible = true;
                displayDialog(backgroundSelector);
            }
            Rectangle {
                id: bgImageRect
                width: filesPanel.lineHeight
                height: filesPanel.lineHeight
                x: bgColorButton.buttonIcon.x
                scale: bgImageButton.buttonIcon.scale
                radius: GCStyle.halfMargins
                color: "transparent"
                border.width: GCStyle.thinBorder
                border.color: GCStyle.contentColor

                Image {
                    anchors.fill: parent
                    anchors.margins: GCStyle.halfMargins
                    fillMode: Image.PreserveAspectFit
                    source: items.backgroundToLoad
                }

            }
        }

        GCLabelButton {
            id: newButton
            maxWidth: filesPanel.maxColumnWidth
            height: filesPanel.lineHeight
            iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileNew.svg"
            text: qsTr("Create a new image")
            textColor: GCStyle.contentColor

            onClicked: {
                Activity.requestNewImage();
                filesPanel.forceClose();
            }
        }
    }
}
