/* GCompris - CategoryReview.qml
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "categorization.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core


Item {
    id: rootItem
    property alias score: score
    property alias categoryDataset: categoryDataset
    property alias instructionBox: instructionBox
    property alias categoryImage: categoryImage
    property bool isDropped: true
    property bool leftAreaContainsDrag: false
    property bool rightAreaContainsDrag: false
    property bool started: rootItem.opacity == 1
    property bool horizontalLayout: categoryBackground.width >= categoryBackground.height
    property alias leftZone: leftZone.model
    property alias rightZone: rightZone.model
    property alias middleZone: middleZone.model
    property alias leftScreen: leftScreen
    property alias middleScreen: middleScreen
    property alias rightScreen: rightScreen
    property int itemWidth: Core.fitItems(middleScreen.width * 0.95, middleScreen.height * 0.94, 12)
    property int zoneWidth: rootItem.width / 3
    property int zoneSpacing: 0.012 * middleScreen.width
    anchors.fill: parent

    Loader {
        id: categoryDataset
        asynchronous: false
    }

    Image {
        id: categoryBackground
        source: "qrc:/gcompris/src/activities/categorization/resource/background.svg"
        anchors.fill: parent
        sourceSize.width:parent.width

        Zone {
            id: leftZone
            anchors.centerIn: leftScreen
            width: zoneWidth - zoneSpacing * 2
            height: parent.height - zoneSpacing * 2
            z: 2
            spacing: zoneSpacing
        }

        Rectangle {
            id: leftScreen
            width: zoneWidth
            height: parent.height
            anchors.top: parent.top
            anchors.left: parent.left
            x: 0
            color: leftAreaContainsDrag ? "#F9F8B4" : "#F9B4B4"
            border.width: zoneSpacing
            border.color: "#EC1313"
            opacity: 0.5
        }

        Zone {
            id: rightZone
            width: zoneWidth - zoneSpacing * 2
            spacing: zoneSpacing
            z: 2
            anchors.top: rightScreen.top
            anchors.bottom: rightScreen.bottom
            anchors.left: rightScreen.left
            anchors.leftMargin: zoneSpacing
            anchors.topMargin: rootItem.categoryImage.height + zoneSpacing * 2
        }

        Rectangle {
            id: rightScreen
            width: zoneWidth
            height: parent.height
            anchors.top: parent.top
            anchors.right: parent.right
            color: rightAreaContainsDrag ? "#F9F8B4" : "#B4F9C5"
            border.width: zoneSpacing
            border.color: "#13EC52"
            opacity: 0.5
        }

        Rectangle {
            id: middleScreen
            width: zoneWidth
            height: parent.height
            x: leftScreen.width
            color: "#00FFFFFF"
        }

        Rectangle {
            id: instructionBox
            anchors.left: categoryBackground.left
            anchors.right: categoryImage.left
            anchors.leftMargin: 0.32 * parent.width
            anchors.rightMargin: 0.03 * parent.width
            color: "black"
            opacity: items.instructionsVisible ? 0.85 : 0
            z: 3
            radius: 10
            border.width: 2
            width: horizontalLayout ? parent.width/5 : parent.width/3
            height: horizontalLayout ? parent.height/6 : parent.height * 0.09
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
        }

        Zone {
            id: middleZone
            anchors.centerIn: middleScreen
            width: zoneWidth - zoneSpacing * 2
            height: parent.height - zoneSpacing * 2
            spacing: zoneSpacing
            z: 2
        }

        GCText {
            id: instructions
            text: items.mode !== "expert" && items.details && items.details[bar.level-1] && items.details[bar.level - 1].instructions ? items.details[bar.level - 1].instructions : qsTr("Place the majority category images to the right and other images to the left")
            visible: items.instructionsVisible
            anchors.fill: instructionBox
            anchors.bottom: instructionBox.bottom
            fontSizeMode: Text.Fit
            wrapMode: Text.Wrap
            z: 3
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Image {
            id: categoryImage
            fillMode: Image.PreserveAspectFit
            source: items.details && items.details[bar.level-1] && items.details[bar.level-1].image ? items.details[bar.level-1].image : ""
            sourceSize.width: itemWidth
            width: sourceSize.width
            height: sourceSize.width
            visible: items.categoryImageChecked
            anchors {
                top: rightScreen.top
                left: rightScreen.left
                topMargin: zoneSpacing
                leftMargin: zoneSpacing
            }
        }

        BarButton {
            id: validate
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: bar.height * 0.8
            height: width
            sourceSize.width: width
            sourceSize.height: height
            anchors {
                rightMargin: 14 * ApplicationInfo.ratio
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 14 * ApplicationInfo.ratio
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Activity.allPlaced();
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

        Score {
            id: score
            visible: items.scoreChecked
            width: rightZone.width * 0.4
            height: width * 0.6
            margins: 10 * ApplicationInfo.ratio
            anchors {
                top: parent.top
                right: parent.right
                left: undefined
                bottom: undefined
            }
        }
    }

    Keys.onEscapePressed: { Activity.launchMenuScreen(); }

    Keys.onReleased: {
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
