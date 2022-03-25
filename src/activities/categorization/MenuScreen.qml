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
import GCompris 1.0
import QtGraphicalEffects 1.0

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
        menuGrid.currentIndex = 0
        opacity = 1
    }

    function stop() {
        focus = false
        opacity = 0
    }

    Keys.onEscapePressed: {
        home()
    }

    Keys.enabled: (items.mode == "expert") ? false : true
    Keys.onPressed: {
        if(event.key === Qt.Key_Space) {
            menuGrid.currentItem.selectCurrentItem()
            event.accepted = true
        }
        if(event.key === Qt.Key_Enter) {
            menuGrid.currentItem.selectCurrentItem()
            event.accepted = true
        }
        if(event.key === Qt.Key_Return) {
            menuGrid.currentItem.selectCurrentItem()
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

    Keys.onReleased: {
        keyboardMode = true
        event.accepted = false
    }

    // sections
    property int iconWidth: 180 * ApplicationInfo.ratio
    property int iconHeight: 180 * ApplicationInfo.ratio

    property int levelCellWidth: background.width / Math.floor(background.width / iconWidth )
    property int levelCellHeight: iconHeight * 1.2

    ListModel {
        id: menuModel
    }

    GridView {
        id: menuGrid
        anchors {
            fill: parent
            bottomMargin: bar.height
        }
        cellWidth: levelCellWidth
        cellHeight: levelCellHeight
        clip: true
        model: menuModel
        keyNavigationWraps: true
        property int spacing: 10

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
            width: levelCellWidth - menuGrid.spacing
            height: levelCellHeight - menuGrid.spacing
            property string sectionName: name
            opacity: (items.mode == "expert") ? 0.25 : 1

            Rectangle {
                id: activityBackground
                width: levelCellWidth - menuGrid.spacing
                height: levelCellHeight - menuGrid.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                opacity: 0.5
            }

            Image {
                id: containerImage
                source: image
                anchors.top: activityBackground.top
                anchors.horizontalCenter: parent.horizontalCenter
                height: activityBackground.height*0.8 - 6
                width: height
                anchors.margins: 5
                sourceSize.height: height
                fillMode: Image.PreserveAspectCrop
                clip: true
            }

            GCText {
                id: categoryName
                anchors.top: containerImage.bottom
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: activityBackground.width
                height: activityBackground.height*0.2 - 6
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

            Image {
                source: "qrc:/gcompris/src/activities/menu/resource/" +
                        ( favorite ? "all.svg" : "all_disabled.svg" );
                anchors {
                    top: parent.top
                    right: parent.right
                    rightMargin: 4 * ApplicationInfo.ratio
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
                    }
                }
            }
        } //delegate close

        highlight: Rectangle {
            width: levelCellWidth - menuGrid.spacing
            height: levelCellHeight - menuGrid.spacing
            color:  "#AA41AAC4"
            border.width: 3
            border.color: "black"
            visible: (items.mode == "expert") ? false : true
            Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
            Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
        }

        Rectangle {
            id: menusMask
            visible: false
            anchors.fill: menuGrid
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFFFF" }
                GradientStop { position: 0.92; color: "#FFFFFFFF" }
                GradientStop { position: 0.96; color: "#00FFFFFF" }
            }
        }
        
        layer.enabled: ApplicationInfo.useOpenGL
        layer.effect: OpacityMask {
            id: activitiesOpacity
            source: menuGrid
            maskSource: menusMask
            anchors.fill: menuGrid
        }
    } // grid view close
}
