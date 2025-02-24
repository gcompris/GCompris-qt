/* GCompris - MenuScreen.qml
*
* Copyright (C) Divyam Madaan <divyam3897@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0
import QtQuick.Effects

import "../../core"
import "categorization.js" as Activity

Image {
    id: menuScreen
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
    sourceSize.width: width
    sourceSize.height: height
    opacity: 0

    property alias menuModel: menuModel
    property alias iAmReady: iAmReady
    property bool keyboardMode: false
    property bool started: opacity == 1

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    visible: opacity != 0

    function start() {
        focus = true
        forceActiveFocus()
        opacity = 1
    }

    function stop() {
        focus = false
        opacity = 0
    }

    function startCurrentItem() {
        if(menuGrid.currentIndex >= 0)
            menuGrid.currentItem.selectCurrentItem()
    }

    Keys.onEscapePressed: {
        home()
    }

    Keys.enabled: (items.mode == "expert") ? false : true
    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Space) {
            startCurrentItem()
            event.accepted = true
        }
        if(event.key === Qt.Key_Enter) {
            startCurrentItem()
            event.accepted = true
        }
        if(event.key === Qt.Key_Return) {
            startCurrentItem()
            event.accepted = true
        }
        if(event.key === Qt.Key_Left) {
            menuGrid.moveCurrentIndexLeft()
            event.accepted = true
        }
        if(event.key === Qt.Key_Right) {
            menuGrid.moveCurrentIndexRight()
            event.accepted = true
        }
        if(event.key === Qt.Key_Up) {
            menuGrid.moveCurrentIndexUp()
            event.accepted = true
        }
        if(event.key === Qt.Key_Down) {
            menuGrid.moveCurrentIndexDown()
            event.accepted = true
        }
    }

    Keys.onReleased: (event) => {
        keyboardMode = true
        event.accepted = false
    }

    // sections
    property int iconWidth: 180 * ApplicationInfo.ratio
    property int iconHeight: 180 * ApplicationInfo.ratio

    property int levelCellWidth: menuGrid.width / Math.max(1, Math.floor(activityBackground.width / iconWidth ))
    property int levelCellHeight: iconHeight * 1.2

    ListModel {
        id: menuModel
    }

    Rectangle{
        id: menuMask
        visible: false
        layer.enabled: true
        anchors.fill: menuGrid
        // Dynamic position of the gradient used for OpacityMask
        // If the hidden bottom part of the grid is > to the maximum height of the gradient,
        // we use the maximum height.
        // Else we set the gradient start position proportionnally to the hidden bottom part,
        // until it disappears.
        // And if using useSoftwareRenderer, the mask is disabled, so we save the calculation and set it to 1
        property real gradientStartValue:
        !ApplicationInfo.useSoftwareRenderer ?
        (menuGrid.hiddenBottom > menuGrid.height * 0.08 ?
        0.92 : 1 - (menuGrid.hiddenBottom / menuGrid.height)) :
        1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFFFF" }
            GradientStop { position: menuMask.gradientStartValue; color: "#FFFFFFFF" }
            GradientStop { position: menuMask.gradientStartValue + 0.04; color:"#00FFFFFF"}
        }
    }

    GridView {
        id: menuGrid
        anchors {
            fill: parent
            margins: GCStyle.halfMargins
            rightMargin: 0
            bottomMargin: bar.height * 1.2
        }
        cellWidth: levelCellWidth
        cellHeight: levelCellHeight
        clip: true
        model: menuModel
        keyNavigationWraps: true
        maximumFlickVelocity: menuScreen.height
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: -1
        // Needed to calculate the OpacityMask offset
        // If using software renderer, this value is not used, so we save the calculation and set it to 1
        property real hiddenBottom: ApplicationInfo.useSoftwareRenderer ? 1 : contentHeight - height - contentY

        ReadyButton {
            id: iAmReady
            focus: true
            visible: items.iAmReadyChecked
            onClicked: {
                Activity.startCategory()
            }
        }

        delegate: Item {
            id: delegateItem
            width: levelCellWidth - GCStyle.halfMargins
            height: levelCellHeight - GCStyle.halfMargins
            property string sectionName: name
            opacity: (items.mode == "expert") ? 0.25 : 1

            Rectangle {
                id: activityBackground
                width: parent.width
                height: parent.height
                color: GCStyle.whiteBg
                opacity: 0.5
            }

            Image {
                id: containerImage
                source: image
                anchors.top: activityBackground.top
                anchors.horizontalCenter: parent.horizontalCenter
                height: (activityBackground.height - 3 * GCStyle.halfMargins) * 0.8
                width: height
                anchors.margins: GCStyle.halfMargins
                sourceSize.height: height
                fillMode: Image.PreserveAspectCrop
                clip: true
            }

            GCText {
                id: categoryName
                anchors.top: containerImage.bottom
                anchors.topMargin: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: activityBackground.width - GCStyle.halfMargins
                height: (activityBackground.height - 3 * GCStyle.halfMargins) * 0.2
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                text: name
                opacity: (items.mode == "expert") ? 0 : 1
            }

            ParticleSystemStarLoader {
                id: particles
                anchors.fill: activityBackground
            }
            MouseArea {
                anchors.fill: activityBackground
                enabled: menuScreen.started && items.mode !== "expert"
                onClicked: selectCurrentItem()
            }

            function selectCurrentItem() {
                particles.burst(50)
                Activity.storeCategoriesLevels(index)
            }

            Rectangle {
                anchors.fill: favoriteIcon
                anchors.margins: - GCStyle.tinyMargins
                color: GCStyle.whiteBg
                opacity: 0.5
                radius: width * 0.5
            }

            Image {
                id: favoriteIcon
                source: "qrc:/gcompris/src/activities/menu/resource/" +
                        ( favorite ? "all.svg" : "all_disabled.svg" );
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: GCStyle.halfMargins
                }
                sourceSize.width: iconWidth * 0.25
                visible: ApplicationSettings.sectionVisible
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
		                for(var i = 0; i < items.menuModel.count; i++) {
                            var category = items.menuModel.get(i)
                            var categoryIndex = category.index
                            if(index == categoryIndex)
                                menuModel.get(i)['favorite'] = !menuModel.get(i)['favorite']
                        }
                        dialogActivityConfig.saveData()
                        Activity.initCategories()
                    }
                }
            }
        } //delegate close

        highlight: Rectangle {
            width: levelCellWidth - GCStyle.halfMargins
            height: levelCellHeight - GCStyle.halfMargins
            color:  "#AAFFFFFF"
            border.width: GCStyle.thinBorder
            border.color: GCStyle.whiteBorder
            visible: (items.mode == "expert" || menuGrid.currentIndex === -1) ? false : true
            Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
            Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
        }

        layer.enabled: !ApplicationInfo.useSoftwareRenderer
        layer.effect: MultiEffect {
            id: menuOpacity
            maskEnabled: true
            maskSource: menuMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    } // grid view close
}
