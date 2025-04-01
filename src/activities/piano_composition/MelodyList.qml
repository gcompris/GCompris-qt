/* GCompris - MelodyList.qml
 *
 * SPDX-FileCopyrightText: 2017 Divyam Madaan <divyam3897@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Divyam Madaan <divyam3897@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"

Rectangle {
    id: dialogBackground
    color: GCStyle.configBg
    z: 10000
    anchors.fill: parent
    visible: false
    focus: visible

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Down) {
            scrollItem.down();
        } else if(event.key === Qt.Key_Up) {
            scrollItem.up();
        }
    }

    Keys.onEscapePressed: closeButton.close()

    Keys.onReleased: (event) => {
        if(event.key === Qt.Key_Back) {
            event.accepted = true;
            closeButton.close();
        }
    }

    signal close

    property alias melodiesModel: melodiesModel
    property bool horizontalLayout: dialogBackground.width >= dialogBackground.height
    property int selectedMelodyIndex: -1

    ListModel {
        id: melodiesModel
    }

    Column {
        id: contentColumn
        spacing: GCStyle.baseMargins
        anchors.top: parent.top
        anchors.topMargin: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        width: dialogBackground.width - 2 * GCStyle.baseMargins
        Rectangle {
            id: titleRectangle
            color: GCStyle.lightBg
            radius: GCStyle.baseMargins
            width: parent.width
            height: Math.max(title.height, closeButton.height) + GCStyle.baseMargins

            GCText {
                id: title
                text: qsTr("Melodies")
                width: titleRectangle.width - (closeButton.width + closeButton.anchors.margins) * 2
                anchors.horizontalCenter: titleRectangle.horizontalCenter
                anchors.verticalCenter: titleRectangle.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: mediumSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }
            // The close button
            GCButtonCancel {
                id: closeButton
                apply: true
                anchors.top: undefined
                anchors.verticalCenter: titleRectangle.verticalCenter
                anchors.margins: GCStyle.tinyMargins
                onClose: {
                    dialogBackground.selectedMelodyIndex = -1
                    dialogBackground.close()
                }
            }
        }

        Rectangle {
            id: flickableBg
            color: GCStyle.lightTransparentBg
            radius: GCStyle.baseMargins
            width: parent.width
            height: dialogBackground.height - (2 * parent.anchors.topMargin) - titleRectangle.height - parent.spacing
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.midBorder

            Flickable {
                id: flickableList
                anchors.margins: GCStyle.baseMargins
                anchors.fill: parent
                contentWidth: width
                contentHeight: melodiesGrid.height
                flickableDirection: Flickable.VerticalFlick
                maximumFlickVelocity: dialogBackground.height
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                Flow {
                    id: melodiesGrid
                    width: parent.width
                    spacing: GCStyle.baseMargins
                    anchors.horizontalCenter: parent.horizontalCenter

                    Repeater {
                        id: melodiesRepeater
                        model: melodiesModel

                        GCButton {
                            text: title
                            onClicked: {
                                dialogBackground.selectedMelodyIndex = index
                                items.multipleStaff.stopAudios()
                                items.multipleStaff.nbStaves = 2
                                items.multipleStaff.bpmValue = defaultBPM ? defaultBPM : 60
                                items.multipleStaff.loadFromData(melody)
                                lyricsArea.setLyrics(title, _origin, lyrics)
                            }
                            width: Math.floor((flickableList.width - GCStyle.baseMargins * 3) * 0.25)
                            height: Math.min(100 * ApplicationInfo.ratio, flickableList.height * 0.25)
                            theme: "dark"

                            Image {
                                source: "qrc:/gcompris/src/core/resource/apply.svg"
                                sourceSize.width: height
                                sourceSize.height: height
                                width: height
                                height: parent.height * 0.25
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                anchors.margins: GCStyle.tinyMargins
                                visible: dialogBackground.selectedMelodyIndex === index
                            }
                        }
                    }
                }
            }
            // The scroll buttons
            GCButtonScroll {
                id: scrollItem
                anchors.right: parent.right
                anchors.bottom: flickableList.bottom
                anchors.margins: GCStyle.halfMargins
                onUp: flickableList.flick(0, 1000)
                onDown: flickableList.flick(0, -1000)
                upVisible: flickableList.atYBeginning ? false : true
                downVisible: flickableList.atYEnd ? false : true
            }
        }
    }
}
