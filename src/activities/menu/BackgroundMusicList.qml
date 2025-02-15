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
import QtMultimedia
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: dialogBackground
    color: GCStyle.configBg
    z: 10000
    anchors.fill: parent
    visible: false
    focus: visible

    Keys.onPressed: (event) => {
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

    Column {
        spacing: GCStyle.halfMargins
        anchors.top: parent.top
        anchors.topMargin: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        width: dialogBackground.width - 2 * GCStyle.baseMargins
        Rectangle {
            id: titleRectangle
            color: GCStyle.lightBg
            radius: GCStyle.baseMargins
            width: parent.width
            height:  Math.max(title.height, cancel.height) + GCStyle.baseMargins

            GCText {
                id: title
                text: qsTr("Background music")
                width: titleRectangle.width - (cancel.width + cancel.anchors.margins) * 2
                height: 50 * ApplicationInfo.ratio
                anchors.horizontalCenter: titleRectangle.horizontalCenter
                anchors.verticalCenter: titleRectangle.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: largeSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }
            // The cancel button
            GCButtonCancel {
                id: cancel
                anchors.top: undefined
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: GCStyle.tinyMargins
                onClose: dialogBackground.close()
            }
        }

        Rectangle {
            color: GCStyle.lightTransparentBg
            radius: GCStyle.baseMargins
            width: parent.width
            height: dialogBackground.height - (2 * parent.anchors.topMargin) - titleRectangle.height - parent.spacing
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.midBorder

            Flickable {
                id: flick
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                contentHeight: musicGrid.height + musicInfo.height + 70 * ApplicationInfo.ratio
                flickableDirection: Flickable.VerticalFlick
                maximumFlickVelocity: dialogBackground.height
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                Grid {
                    id: musicGrid
                    width: parent.width + GCStyle.halfMargins
                    spacing: GCStyle.halfMargins

                    Repeater {
                        model: dialogActivityConfig.configItem ? dialogActivityConfig.configItem.allBackgroundMusic : 0

                        Item {
                            width: Math.floor((musicGrid.width - GCStyle.baseMargins) / 3)
                            height: title.height

                            GCButton {
                                text: modelData.slice(0, modelData.lastIndexOf('.'))
                                width: parent.width - GCStyle.halfMargins
                                height: parent.height - GCStyle.halfMargins
                                theme: "dark"
                                rightIconSize: selectedIcon.height + GCStyle.baseMargins

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

                                Image {
                                    id: selectedIcon
                                    source: "qrc:/gcompris/src/core/resource/apply.svg"
                                    height: parent.height * 0.5
                                    width: height
                                    sourceSize.width: width
                                    sourceSize.height: height
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.margins: GCStyle.halfMargins
                                    visible: dialogActivityConfig.configItem.filteredBackgroundMusic ? dialogActivityConfig.configItem.filteredBackgroundMusic.indexOf(modelData) != -1 : false
                                }
                            }
                        }
                    }
                }

                Column {
                    id: musicInfo
                    spacing: GCStyle.baseMargins
                    width: parent.width
                    anchors.top: musicGrid.bottom
                    anchors.leftMargin: GCStyle.baseMargins
                    visible: backgroundMusic.playbackState === MediaPlayer.PlayingState && !backgroundMusic.muted
                    GCText {
                        //: Current background music playing
                        text: qsTr("Now Playing:")
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        fontSize: mediumSize
                        wrapMode: Text.WordWrap
                    }
                    GCText {
                        //: Title of the current background music playing
                        text: qsTr("Title: %1").arg(backgroundMusic.metaDataMusic[0])
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        fontSize: smallSize
                        wrapMode: Text.WordWrap
                    }
                    GCText {
                        //: Artist of the current background music playing
                        text: qsTr("Artist: %1").arg(backgroundMusic.metaDataMusic[1])
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        fontSize: smallSize
                        wrapMode: Text.WordWrap
                    }
                    GCText {
                        //: Year of the current background music playing
                        text: qsTr("Year: %1").arg(backgroundMusic.metaDataMusic[2])
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        fontSize: smallSize
                        wrapMode: Text.WordWrap
                    }
                    GCText {
                        //: Copyright of the current background music playing
                        text: qsTr("Copyright: %1").arg(backgroundMusic.metaDataMusic[3])
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        fontSize: smallSize
                        wrapMode: Text.WordWrap
                    }
                }
            }
            // The scroll buttons
            GCButtonScroll {
                id: scrollItem
                anchors.right: parent.right
                anchors.rightMargin: GCStyle.halfMargins
                anchors.bottom: flick.bottom
                anchors.bottomMargin: GCStyle.halfMargins
                onUp: flick.flick(0, 1000)
                onDown: flick.flick(0, -1000)
                upVisible: flick.atYBeginning ? false : true
                downVisible: flick.atYEnd ? false : true
            }
        }
    }
}
