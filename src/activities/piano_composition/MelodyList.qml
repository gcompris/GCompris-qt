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
import GCompris 1.0

import "../../core"
import "piano_composition.js" as Activity

Rectangle {
    id: dialogBackground
    color: "#696da3"
    z: 10000
    anchors.fill: parent
    visible: false
    focus: visible

    Keys.onPressed: {
        if(event.key === Qt.Key_Down) {
            scrollItem.down();
        } else if(event.key === Qt.Key_Up) {
            scrollItem.up();
        }
    }

    Keys.onEscapePressed: closeButton.close()

    Keys.onReleased: {
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
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        width: dialogBackground.width - 30
        Rectangle {
            id: titleRectangle
            color: "#e6e6e6"
            radius: 10 * ApplicationInfo.ratio
            width: parent.width
            height: title.height + 10 * 2

            GCText {
                id: title
                text: qsTr("Melodies")
                width: titleRectangle.width - 120 * ApplicationInfo.ratio //minus twice the cancel button size
                anchors.horizontalCenter: titleRectangle.horizontalCenter
                anchors.verticalCenter: titleRectangle.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: 20
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }
            // The close button
            GCButtonCancel {
                id: closeButton
                apply: true
                anchors.verticalCenter: titleRectangle.verticalCenter
                anchors.margins: 2 * ApplicationInfo.ratio
                onClose: {
                    dialogBackground.selectedMelodyIndex = -1
                    dialogBackground.close()
                }
            }
        }

        Rectangle {
            color: "#bdbed0"
            radius: 10 * ApplicationInfo.ratio
            width: dialogBackground.width - 30
            height: dialogBackground.height - (2 * parent.anchors.topMargin) - titleRectangle.height - parent.spacing
            border.color: "white"
            border.width: 3 * ApplicationInfo.ratio

            Flickable {
                id: flickableList
                flickDeceleration: 1500
                anchors.fill: parent
                anchors.margins: 10 * ApplicationInfo.ratio
                contentWidth: width
                contentHeight: melodiesGrid.height
                flickableDirection: Flickable.VerticalFlick
                clip: true

                Flow {
                    id: melodiesGrid
                    width: parent.width
                    spacing: 40
                    anchors.horizontalCenter: parent.horizontalCenter

                    Repeater {
                        id: melodiesRepeater
                        model: melodiesModel

                        Item {
                            id: melodiesItem
                            width: dialogBackground.horizontalLayout ? dialogBackground.width / 5 : dialogBackground.width / 4
                            height: dialogBackground.height / 5

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
                                width: parent.width
                                height: parent.height * 0.8
                                theme: "dark"

                                Image {
                                    source: "qrc:/gcompris/src/core/resource/apply.svg"
                                    sourceSize.width: height
                                    sourceSize.height: height
                                    width: height
                                    height: parent.height / 4
                                    anchors.bottom: parent.bottom
                                    anchors.right: parent.right
                                    anchors.margins: 2
                                    visible: dialogBackground.selectedMelodyIndex === index
                                }
                            }
                        }
                    }
                }
            }
            // The scroll buttons
            GCButtonScroll {
                id: scrollItem
                anchors.right: parent.right
                anchors.rightMargin: 5 * ApplicationInfo.ratio
                anchors.bottom: flickableList.bottom
                anchors.bottomMargin: 5 * ApplicationInfo.ratio
                onUp: flickableList.flick(0, 1400)
                onDown: flickableList.flick(0, -1400)
                upVisible: flickableList.atYBeginning ? false : true
                downVisible: flickableList.atYEnd ? false : true
            }
        }
    }
}
