/* GCompris - MenuScreen.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
import QtQuick.Controls 2.12

import "../../core"
import "lang.js" as Activity

Item {
    id: menuScreen
    anchors.fill: parent
    opacity: 0

    property alias menuModel: menuModel
    property bool keyboardMode: false
    property bool started: opacity == 1
    property int spacing: Math.floor(5 * ApplicationInfo.ratio)

    Behavior on opacity { PropertyAnimation { duration: 200 } }

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

    // Activities
    property int iconSize: 180 * ApplicationInfo.ratio

    property int levelCellWidth: menuGrid.width / Math.floor(menuGrid.width / iconSize )
    property int levelCellHeight: iconSize * 1.4

    ListModel {
        id: menuModel
    }

    GridView {
        id: menuGrid

        anchors {
            fill: parent
            topMargin: menuScreen.spacing
            leftMargin: menuScreen.spacing
            bottomMargin: bar.height + menuScreen.spacing
        }
        cellWidth: levelCellWidth
        cellHeight: levelCellHeight
        clip: true
        model: menuModel
        keyNavigationWraps: true
        // Needed to calculate the OpacityMask offset
        // If not using OpenGL, this value is not used, so we save the calculation and set it to 1
        property real hiddenBottom: ApplicationInfo.useOpenGL ? contentHeight - height - contentY : 1

        delegate: Rectangle {
            id: delegateItem
            width: levelCellWidth - menuScreen.spacing
            height: levelCellHeight - menuScreen.spacing
            property string sectionName: name
            color: "#7FFFFFFF"

            Image {
                id: containerImage
                source: image;
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: title.top
                anchors.bottomMargin: title.lineCount  > 1 ? title.height * -0.5 : menuScreen.spacing
                fillMode: Image.PreserveAspectFit
            }

            Rectangle {
                anchors.fill: title
                color: menuScreen.keyboardMode && menuGrid.currentIndex == index ?
                    "#80EAF8FD" : "#80C2ECF8"
            }

            GCText {
                id: title
                anchors.bottom: progressLang.top
                anchors.bottomMargin: menuScreen.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - 4 * ApplicationInfo.ratio
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: regularSize
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                text: Activity.items.categoriesTranslations[name]
            }

            GCProgressBar {
                id: progressLang
                borderSize: ApplicationInfo.ratio
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottomMargin: menuScreen.spacing
                anchors.leftMargin: ApplicationInfo.ratio * 10
                anchors.rightMargin: anchors.leftMargin
                height: 14 * ApplicationInfo.ratio
                to: wordCount
                from: 0
                value: progress
                displayText: false
            }

            MouseArea {
                anchors.fill: parent
                enabled: menuScreen.started
                onClicked: selectCurrentItem()
            }

            function selectCurrentItem() {
                Activity.initLevel(index)
            }

            Rectangle {
                color: "#C0FFFFFF"
                anchors.centerIn: favoriteButton
                width: favoriteButton.width +  2 * ApplicationInfo.ratio
                height: width
                radius: width * 0.5
            }
            Image {
                id: favoriteButton
                source: "qrc:/gcompris/src/activities/menu/resource/" +
                        ( favorite ? "all.svg" : "all_disabled.svg" );
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: menuScreen.spacing
                }
                sourceSize.width: iconSize * 0.2

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        menuModel.get(index)['favorite'] = !menuModel.get(index)['favorite']
                    }
                }
            }

        } //delegate close

        highlight: Rectangle {
            width: levelCellWidth - menuScreen.spacing
            height: levelCellHeight - menuScreen.spacing
            color:  "#AAFFFFFF"
            border.width: 2 * ApplicationInfo.ratio
            border.color: "#373737"
            visible: menuScreen.keyboardMode
            Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
            Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
        }

        Rectangle{
            id: menuMask
            visible: false
            anchors.fill: menuGrid
            // Dynamic position of the gradient used for OpacityMask
            // If the hidden bottom part of the grid is > to the maximum height of the gradient,
            // we use the maximum height.
            // Else we set the gradient start position proportionnally to the hidden bottom part,
            // until it disappears.
            // And if not using OpenGL, the mask is disabled, so we save the calculation and set it to 1
            property real gradientStartValue:
                ApplicationInfo.useOpenGL ?
                (menuGrid.hiddenBottom > menuGrid.height * 0.08 ?
                    0.92 : 1 - (menuGrid.hiddenBottom / menuGrid.height)) :
                    1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFFFF" }
                GradientStop { position: menuMask.gradientStartValue; color: "#FFFFFFFF" }
                GradientStop { position: menuMask.gradientStartValue + 0.04; color:"#00FFFFFF"}
            }
        }

        layer.enabled: ApplicationInfo.useOpenGL
        layer.effect: OpacityMask {
            id: activitiesOpacity
            source: menuGrid
            maskSource: menuMask
            anchors.fill: menuGrid
        }

    } // grid view close

}
