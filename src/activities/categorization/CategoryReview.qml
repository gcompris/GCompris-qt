/* GCompris - CategoryReview.qml
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "categorization.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core


Item {
    id: rootItem
    property alias score: score
    property alias categoryDataset: categoryDataset
    property alias categoryImage: categoryImage
    property bool isDropped: true
    property bool leftAreaContainsDrag: false
    property bool rightAreaContainsDrag: false
    property bool started: opacity == 1
    property bool horizontalLayout: categoryBackground.width >= categoryBackground.height
    property alias leftZone: leftZone.model
    property alias rightZone: rightZone.model
    property alias middleZone: middleZone.model
    property alias leftScreen: leftScreen
    property alias middleScreen: middleScreen
    property alias rightScreen: rightScreen
    property double screenWidth: width / 3
    property double zoneWidth: screenWidth - GCStyle.midBorder * 2 - GCStyle.halfMargins
    property double zoneHeight: height - GCStyle.midBorder * 2 - GCStyle.halfMargins * 3 - okButton.height
    property double itemWidth: Core.fitItems(zoneWidth, zoneHeight, 12) - GCStyle.halfMargins

    Loader {
        id: categoryDataset
        asynchronous: false
    }

    Image {
        id: categoryBackground
        source: "qrc:/gcompris/src/activities/categorization/resource/background.svg"
        anchors.fill: parent
        sourceSize.width: parent.width

        Rectangle {
            id: leftScreen
            width: rootItem.screenWidth
            height: parent.height
            anchors.top: parent.top
            anchors.left: parent.left
            color: leftAreaContainsDrag ? "#F9F8B4" : "#F9B4B4"
            border.width: GCStyle.midBorder
            border.color: "#EC1313"
            opacity: 0.5
        }

        Zone {
            id: leftZone
            anchors.top: leftScreen.top
            anchors.left: leftScreen.left
            anchors.margins: GCStyle.halfMargins + GCStyle.midBorder
            width: rootItem.zoneWidth
            height: rootItem.zoneHeight
            spacing: GCStyle.halfMargins
        }

        Rectangle {
            id: rightScreen
            width: rootItem.screenWidth
            height: parent.height
            anchors.top: parent.top
            anchors.right: parent.right
            color: rightAreaContainsDrag ? "#F9F8B4" : "#B4F9C5"
            border.width: GCStyle.midBorder
            border.color: "#13EC52"
            opacity: 0.5
        }

        Rectangle {
            id: categoryImageBg
            color: GCStyle.whiteBg
            radius: GCStyle.halfMargins
            anchors.fill: categoryImage
            anchors.margins: -GCStyle.halfMargins
            opacity: 0.5
            visible: categoryImage.visible
        }

        Image {
            id: categoryImage
            fillMode: Image.PreserveAspectFit
            source: items.details && items.details[bar.level-1] && items.details[bar.level-1].image ? items.details[bar.level-1].image : ""
            width: visible ? okButton.height : 0
            height: width
            sourceSize.width: width
            sourceSize.height: width
            visible: items.categoryImageChecked
            anchors {
                top: rightScreen.top
                horizontalCenter: rightScreen.horizontalCenter
                margins: items.categoryImageChecked ? GCStyle.halfMargins * 2 + GCStyle.midBorder : 0
            }
        }

        Zone {
            id: rightZone
            anchors.top: categoryImage.bottom
            anchors.left: rightScreen.left
            anchors.topMargin: items.categoryImageChecked ? GCStyle.baseMargins : GCStyle.halfMargins
            anchors.leftMargin: GCStyle.halfMargins + GCStyle.midBorder
            width: rootItem.zoneWidth
            height: rootItem.zoneHeight
            spacing: GCStyle.halfMargins
        }

        Item {
            id: middleScreen
            width: rootItem.screenWidth
            height: parent.height
            x: leftScreen.width
        }

        Zone {
            id: middleZone
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: rootItem.zoneWidth
            height: rootItem.zoneHeight
            spacing: GCStyle.halfMargins
        }

        Score {
            id: score
            visible: items.scoreChecked
            width: Math.min(70 * ApplicationInfo.ratio, okButton.width)
            height: Math.min(50 * ApplicationInfo.ratio, okButton.width)
            margins: GCStyle.halfMargins + GCStyle.midBorder
            anchors {
                top: undefined
                right: parent.horizontalCenter
                left: undefined
                bottom: undefined
                verticalCenter: okButton.verticalCenter
                rightMargin: GCStyle.halfMargins
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: Math.min(GCStyle.bigButtonHeight, (middleScreen.width -  3 * GCStyle.halfMargins) * 0.5)
            enabled: items.okEnabled
            anchors {
                left: parent.horizontalCenter
                bottom: parent.bottom
                leftMargin: GCStyle.halfMargins
                bottomMargin: GCStyle.halfMargins + GCStyle.midBorder
            }
            onClicked: {
                items.okEnabled = false;
                Activity.allPlaced();
            }
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: Math.min(parent.width * 0.8, 400 * ApplicationInfo.ratio)
            panelHeight: Math.min(parent.height * 0.5, 300 * ApplicationInfo.ratio)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.centerIn: parent
            textItem.text: items.mode !== "expert" && items.details && items.details[bar.level-1] && items.details[bar.level - 1].instructions ? items.details[bar.level - 1].instructions : qsTr("Place the majority category images to the right and other images to the left")
            visible: items.instructionsVisible
            textItem.fontSize: textItem.regularSize

            MouseArea {
                anchors.fill: parent
                enabled: instructionPanel.visible
                onClicked: {
                    items.instructionsVisible = false;
                }
            }
        }

        DropArea {
            id: rightArea
            anchors.fill: rightZone
        }

        DropArea {
            id: leftArea
            anchors.fill: leftZone
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
    }

    Keys.onEscapePressed: { Activity.launchMenuScreen(); }

    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Back) {
            event.accepted = true
            Activity.launchMenuScreen()
        }
    }

    function stop() {
        if(items.mode == "expert")
            items.menuScreen.iAmReady.visible = true
        focus = false
        rootItem.visible = false
    }

    function start() {
        focus = true
        rootItem.visible = true
    }
}
