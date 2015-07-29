/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/import QtQuick 2.1
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.2

import "../../core"
import "lang.js" as Activity
import "quiz.js" as QuizActivity
import "spell_it.js" as SpellActivity
import "qrc:/gcompris/src/core/core.js" as Core

Image {
    id: menu_screen
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: Activity.baseUrl + "imageid-bg.svg"
    sourceSize.width: parent.width

    property alias menuModel: menuModel
    // Filters
    property bool horizontal: parent.width > parent.height

    property var currentActiveGrid: menuGrid
    property bool keyboardMode: false
    property string favtUrl: "qrc:/gcompris/src/activities/menu/resource/"

    Keys.onEscapePressed: {
        if(Activity.currentMiniGame == -1) {
            home()
        }
        else {
            Activity.launchMenuScreen()
        }
    }

    Keys.onPressed: {
        if( Activity.currentMiniGame === -1) {
            console.log("key pressed in menu screen")
            items.background.keyNavigation = false
            event.accepted = true
            if(event.key === Qt.Key_Space) {
                currentActiveGrid.currentItem.selectCurrentItem()
            }
            if(event.key === Qt.Key_Enter) {
                currentActiveGrid.currentItem.selectCurrentItem()
            }
            if(event.key === Qt.Key_Return) {
                currentActiveGrid.currentItem.selectCurrentItem()
            }
            if(event.key === Qt.Key_Left) {
                currentActiveGrid.moveCurrentIndexLeft()
            }
            if(event.key === Qt.Key_Right) {
                currentActiveGrid.moveCurrentIndexRight()
            }
            if(event.key === Qt.Key_Up) {
                currentActiveGrid.moveCurrentIndexUp()
            }
            if(event.key === Qt.Key_Down) {
                currentActiveGrid.moveCurrentIndexDown()
            }
        }
    }
    Keys.onReleased: {
        keyboardMode = true
        event.accepted = false
    }

    // Activities
    property int iconWidth: 190 * ApplicationInfo.ratio
    property int iconHeight: 190 * ApplicationInfo.ratio

    property int levelCellWidth:
        horizontal ? background.width / Math.floor(background.width / iconWidth ):
                     background.width  / Math.floor(background.width  / iconWidth)
    property int levelCellHeight: iconHeight * 1.5


    ListModel {
        id: menuModel
    }


    GridView {
        id: menuGrid
        layer.enabled: true

        anchors {
            top: parent.top
            fill: parent
            //            margins: 4
        }
        width: background.width
        cellWidth: levelCellWidth
        cellHeight: levelCellHeight
        clip: true
        model: menuModel
        keyNavigationWraps: true
        property int spacing: 10
        delegate: Item {
            id: delegateItem
            width: levelCellWidth - menuGrid.spacing
            height: levelCellHeight - menuGrid.spacing

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
                source: "qrc:/gcompris/data/"+ image;
                anchors.top: activityBackground.top
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: iconHeight
                anchors.margins: 5

                GCText {
                    id: title
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: activityBackground.width
                    fontSizeMode: Text.Fit
                    minimumPointSize: 7
                    fontSize: regularSize
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                    text: name
                }
                //   TODO : progress bar
                ProgressBar {
                    id: progressLang
                    anchors.top: title.bottom
                    anchors.topMargin: ApplicationInfo.ratio * 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: activityBackground.width
                    maximumValue: wordCount
                    minimumValue: 0
                    value: Activity.savedProgress[index]
                    orientation: Qt.Horizontal
                }

            }

            ParticleSystemStarLoader {
                id: particles
                anchors.fill: activityBackground
            }
            MouseArea {
                anchors.fill: activityBackground
                onClicked: selectCurrentItem()
            }

            function selectCurrentItem() {
                particles.burst(50)
                Activity.initLevel(index)
            }


            Image {
                source: menu_screen.favtUrl + ( Activity.favorites[index] ? "all.svg" : "all_disabled.svg");
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
                        console.log("before Activity.favorites[index] is "+Activity.favorites)
                        Activity.favorites[index] = !(Activity.favorites[index])
                        parent.source = menu_screen.favtUrl + ( Activity.favorites[index] ? "all.svg" : "all_disabled.svg");
                        console.log("now Activity.favorites[index] is "+Activity.favorites)
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
            visible: menu_screen.keyboardMode
            Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
            Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
        }

    } // grid view close
    Rectangle{
        id: menusMask
        visible: false
        anchors.fill: menuGrid
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFFFF" }
            GradientStop { position: 0.92; color: "#FFFFFFFF" }
            GradientStop { position: 0.96; color: "#00FFFFFF"}
        }
    }


    layer.effect: OpacityMask {
        id: activitiesOpacity
        source: menuGrid
        maskSource: menusMask
        anchors.fill: menuGrid
    }

}
