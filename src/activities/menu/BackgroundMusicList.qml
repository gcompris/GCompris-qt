/* GCompris - BackgroundMusicList.qml
 *
 * SPDX-FileCopyrightText: 2019 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtMultimedia 5.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: dialogBackground
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 10000
    anchors.fill: parent
    visible: false
    focus: visible

    Keys.onPressed: {
        if(event.key === Qt.Key_Down) {
            scrollMusicList.down();
        } else if(event.key === Qt.Key_Up) {
            scrollMusicList.up();
        }
    }

    Keys.onEscapePressed: close()

    signal close

    onClose: parent.forceActiveFocus();

    property bool horizontalLayout: dialogBackground.width >= dialogBackground.height
    property int margin30: Math.round(30 * ApplicationInfo.ratio)

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
                    text: qsTr("Background music")
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
                    anchors.margins: 10 * ApplicationInfo.ratio
                    contentHeight: musicGrid.height + musicInfo.height + margin30
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    Flow {
                        id: musicGrid
                        width: parent.width
                        spacing: 10 * ApplicationInfo.ratio
                        anchors.horizontalCenter: parent.horizontalCenter

                        Repeater {
                            model: dialogActivityConfig.configItem ? dialogActivityConfig.configItem.allBackgroundMusic : 0

                            Item {
                                width: (musicGrid.width - margin30)  * 0.33
                                height: title.height * 2

                                GCButton {
                                    text: modelData.slice(0, modelData.lastIndexOf('.'))

                                    onClicked: {
                                        if(dialogActivityConfig.configItem.filteredBackgroundMusic.indexOf(modelData) == -1) {
                                            // Keep the filtered playlist sorted w.r.t to their positions in "allBackgroundMusic" to maintain their playing order
                                            var musicOriginalPosition = dialogActivityConfig.configItem.allBackgroundMusic.indexOf(modelData)
                                            var i = 0
                                            while(i < dialogActivityConfig.configItem.filteredBackgroundMusic.length) {
                                                var filteredMusicName = dialogActivityConfig.configItem.filteredBackgroundMusic[i]
                                                if(dialogActivityConfig.configItem.allBackgroundMusic.indexOf(filteredMusicName) >  musicOriginalPosition)
                                                    break
                                                i++
                                            }
                                            dialogActivityConfig.configItem.filteredBackgroundMusic.splice(i, 0, modelData)
                                        }
                                        else {
                                            dialogActivityConfig.configItem.filteredBackgroundMusic.splice(dialogActivityConfig.configItem.filteredBackgroundMusic.indexOf(modelData), 1)
                                            if(dialogActivityConfig.configItem.filteredBackgroundMusic == 0) {
                                                dialogActivityConfig.configItem.filteredBackgroundMusic.push(modelData)
                                                selectedIcon.visible = false
                                                Core.showMessageDialog(dialogBackground,
                                                    qsTr("Disable the background music if you don't want to play them."),
                                                    "", null,
                                                    "", null,
                                                    null
                                                );
                                            }
                                        }

                                        selectedIcon.visible = !selectedIcon.visible
                                    }
                                    width: parent.width
                                    height: parent.height * 0.8
                                    theme: "dark"

                                    Image {
                                        id: selectedIcon
                                        source: "qrc:/gcompris/src/core/resource/apply.svg"
                                        sourceSize.width: height
                                        sourceSize.height: height
                                        width: height
                                        height: parent.height / 4
                                        anchors.bottom: parent.bottom
                                        anchors.right: parent.right
                                        anchors.margins: 2
                                        visible: dialogActivityConfig.configItem.filteredBackgroundMusic ? dialogActivityConfig.configItem.filteredBackgroundMusic.indexOf(modelData) != -1 : false
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        id: musicInfo
                        spacing: 10 * ApplicationInfo.ratio
                        width: parent.width
                        anchors.top: musicGrid.bottom
                        anchors.leftMargin: 20
                        visible: backgroundMusic.playbackState === Audio.PlayingState && !backgroundMusic.muted
                        GCText {
                            //: Current background music playing
                            text: qsTr("Now Playing:")
                            width: dialogBackground.width - 30
                            horizontalAlignment: Text.AlignHCenter
                            color: "black"
                            fontSize: mediumSize
                            wrapMode: Text.WordWrap
                        }
                        GCText {
                            //: Title of the current background music playing
                            text: qsTr("Title: %1").arg(backgroundMusic.metaDataMusic[0])
                            width: dialogBackground.width - 30
                            horizontalAlignment: Text.AlignLeft
                            color: "black"
                            fontSize: smallSize
                            wrapMode: Text.WordWrap
                        }
                        GCText {
                            //: Artist of the current background music playing
                            text: qsTr("Artist: %1").arg(backgroundMusic.metaDataMusic[1])
                            width: dialogBackground.width - 30
                            horizontalAlignment: Text.AlignLeft
                            color: "black"
                            fontSize: smallSize
                            wrapMode: Text.WordWrap
                        }
                        GCText {
                            //: Year of the current background music playing
                            text: qsTr("Year: %1").arg(backgroundMusic.metaDataMusic[2])
                            width: dialogBackground.width - 30
                            horizontalAlignment: Text.AlignLeft
                            color: "black"
                            fontSize: smallSize
                            wrapMode: Text.WordWrap
                        }
                        GCText {
                            //: Copyright of the current background music playing
                            text: qsTr("Copyright: %1").arg(backgroundMusic.metaDataMusic[3])
                            width: dialogBackground.width - 30
                            horizontalAlignment: Text.AlignLeft
                            color: "black"
                            fontSize: smallSize
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                // The scroll buttons
                GCButtonScroll {
                    id: scrollMusicList
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * ApplicationInfo.ratio
                    anchors.bottom: flickableList.bottom
                    anchors.bottomMargin: 30 * ApplicationInfo.ratio
                    width: parent.width / 20
                    height: width * heightRatio
                    onUp: flickableList.flick(0, 1400)
                    onDown: flickableList.flick(0, -1400)
                    upVisible: flickableList.atYBeginning ? false : true
                    downVisible: flickableList.atYEnd ? false : true
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    GCButtonCancel {
        onClose: {
            parent.close()
        }
    }
}
