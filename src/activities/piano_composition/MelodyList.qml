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

import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "piano_composition.js" as Activity

Rectangle {
    id: dialogBackground
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 10000
    anchors.fill: parent
    visible: false
    focus: true

    Keys.onEscapePressed: close()

    signal close

    property alias melodiesModel: melodiesModel
    property bool horizontalLayout: dialogBackground.width >= dialogBackground.height
    property int selectedMelodyIndex: -1

    ListModel {
        id: melodiesModel
    }

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                id: titleRectangle
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                GCText {
                    id: title
                    text: qsTr("Melodies")
                    width: dialogBackground.width - 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    fontSize: 20
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: dialogBackground.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flickableList
                    anchors.fill: parent
                    anchors.topMargin: 10
                    anchors.leftMargin: 20
                    contentWidth: parent.width
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
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * ApplicationInfo.ratio
                    anchors.bottom: flickableList.bottom
                    anchors.bottomMargin: 30 * ApplicationInfo.ratio
                    width: parent.width / 20
                    height: width * heightRatio
                    onUp: flickableList.flick(0, 1400)
                    onDown: flickableList.flick(0, -1400)
                    upVisible: (flickableList.visibleArea.yPosition <= 0) ? false : true
                    downVisible: ((flickableList.visibleArea.yPosition + flickableList.visibleArea.heightRatio) >= 1) ? false : true
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    GCButtonCancel {
        onClose: {
            dialogBackground.selectedMelodyIndex = -1
            parent.close()
        }
    }
}
