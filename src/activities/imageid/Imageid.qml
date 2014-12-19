/* GCompris - Imageid.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
 */

import QtQuick 2.1
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.1

import "../../core"
import "imageid.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/imageid/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

        property bool horizontalLayout: background.width > background.height
        property Item dialog

        signal start
        signal stop
        signal voiceError
        signal voiceDone

        Connections {
            target: DownloadManager

            onDownloadFinished: Activity.start(items)
            onError: {
                // Fixme display an error message
                Core.destroyDialog(dialog)
            }
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias wordImage: wordImage
            property alias wordListModel: wordListModel
            property alias parser: parser
            property variant goodWord

            function playWord() {
                activity.audioVoices.append(ApplicationInfo.getAudioFilePath(goodWord.voice))
            }
            onGoodWordChanged: playWord()
        }

        onStart: {
            Activity.init(items)

            if(!DownloadManager.haveLocalResource("data/words/words.rcc")) {
                var buttonHandler = new Array();
                buttonHandler[StandardButton.No] = function() {};
                buttonHandler[StandardButton.Yes] = function() {
                    DownloadManager.updateResource("data/words/words.rcc") };
                    dialog = Core.showMessageDialog(parent, qsTr("Download?"),
                                                qsTr("Are you ok to download the images for this activity"),
                                                "",
                                                StandardIcon.Question,
                                                buttonHandler);
            } else {
                // Will register the resource file and call start() on callback
                DownloadManager.updateResource("data/words/words.rcc")
            }
            repeatItem.visible = false
            activity.audioVoices.error.connect(voiceError)
            activity.audioVoices.done.connect(voiceDone)
        }

        onStop: { Activity.stop() }
        
        JsonParser {
            id: parser
            
            onError: console.error("Imageid: Error parsing json: " + msg);
        }

        ListModel {
            id: wordListModel
        }

        Grid {
            id: gridId
            columns: horizontalLayout ? 2 : 1
            spacing: 10 * ApplicationInfo.ratio
            anchors.fill: parent
            anchors.margins: 10 * ApplicationInfo.ratio

            Item {
                width: background.horizontalLayout
                       ? background.width * 0.55
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.4
                Image {
                    id: imageFrame
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    source: "qrc:/gcompris/src/activities/imageid/resource/imageid_frame.svg"
                    sourceSize.width: background.horizontalLayout ? parent.width * 0.9 : parent.height * 1.2
                    z: 11

                    Image {
                        id: wordImage
                        sourceSize.width: parent.width * 0.6

                        anchors {
                            centerIn: parent
                            margins: 0.05 + parent.width
                        }
                    }
                }
            }
            ListView {
                id: wordListView

                width: background.horizontalLayout
                       ? background.width * 0.40
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.40
                spacing: 10 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false

                property int buttonHeight: height / wordListModel.count * 0.9

                model: wordListModel

                delegate: AnswerButton {
                    id: wordRectangle

                    width: wordListView.width
                    height: wordListView.buttonHeight

                    textLabel: word
                    isCorrectAnswer: word === items.goodWord.translatedTxt
                    onCorrectlyPressed: bonus.good("smiley");
                }
            }
        }

        onVoiceDone: repeatItem.visible = true
        onVoiceError: repeatItem.visible = false

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svgz";
            sourceSize.width: 80 * ApplicationInfo.ratio

            z: 12
            anchors {
                top: parent.top
                left: parent.left
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: items.playWord()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar

            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
        
        Score {
            id: score

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.top: undefined
        }
        
    }
}
