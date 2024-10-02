/* GCompris - BackgroundSelector.qml
 *
 * SPDX-FileCopyrightText: 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic
import "sketch.js" as Activity
import "../../core"

Rectangle {
    id: backgroundSelector
    color: items.panelColor
    visible: false
    z: 1000
    property bool isDialog: true
    signal close
    signal start
    signal stop

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Space || event.key === Qt.Key_Escape) {
            close();
        }
    }

    onStart: {
        backgroundSelector.forceActiveFocus();
        activity.Keys.enabled = false;
    }

    onClose: {
        activity.Keys.enabled = true;
    }

    GCText {
        id: colorsTitle
        text: qsTr("Background image")
        color: items.contentColor
        height: exitButton.height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: exitButton.left
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    GridView {
        id: gridView
        anchors.top: exitButton.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 2 * items.baseMargins
        cellWidth: items.isHorizontalLayout ? Math.floor(width * 0.2) : width * 0.33
        cellHeight: cellWidth
        model: Activity.backgroundImageSet
        clip: true

        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight
            Image {
                id: imageFromGrid
                source: modelData
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                sourceSize.width: width
                sourceSize.height: width
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(index != 0) {
                        items.backgroundToLoad = imageFromGrid.source;
                    } else {
                        items.backgroundToLoad = "";
                    }
                    backgroundSelector.close();
                }
            }
        }
    }

    GCButtonCancel {
        id: exitButton
        onClose: {
            backgroundSelector.close();
        }
    }
}
