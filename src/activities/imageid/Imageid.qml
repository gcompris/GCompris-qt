/* GCompris - Imageid.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
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
        property bool keyNavigation: false
        readonly property string wordsResource: "data/words/words.rcc"
        property bool englishFallback: false
        property bool downloadWordsNeeded: false

        signal start
        signal stop
        signal voiceError
        signal voiceDone

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
            property int goodWordIndex
            property alias englishFallbackDialog: englishFallbackDialog

            function playWord() {
                if (!activity.audioVoices.append(ApplicationInfo.getAudioFilePath(goodWord.voice)))
                    voiceError();
            }
            onGoodWordChanged: playWord()
        }

        function handleResourceRegistered(resource)
        {
            if (resource == wordsResource)
                Activity.start(items);
        }

        onStart: {
            Activity.init(items)

            repeatItem.visible = false
            keyNavigation = false
            activity.audioVoices.error.connect(voiceError)
            activity.audioVoices.done.connect(voiceDone)

            // check for words.rcc:
            if (DownloadManager.isResourceRegistered(wordsResource)) {
                // words.rcc is already registered -> start right away
                Activity.start(items);
            } else if(DownloadManager.haveLocalResource(wordsResource)) {
                // words.rcc is there, but not yet registered -> updateResource
                DownloadManager.resourceRegistered.connect(handleResourceRegistered);
                DownloadManager.updateResource(wordsResource);
            } else {
                // words.rcc has not been downloaded yet -> ask for download
                downloadWordsNeeded = true
            }
        }

        onStop: {
            DownloadManager.resourceRegistered.disconnect(handleResourceRegistered);
            Activity.stop()
        }
        
        Keys.onRightPressed: {
            keyNavigation = true
            wordListView.incrementCurrentIndex()
        }
        Keys.onLeftPressed:  {
            keyNavigation = true
            wordListView.decrementCurrentIndex()
        }
        Keys.onDownPressed:  {
            keyNavigation = true
            wordListView.incrementCurrentIndex()
        }
        Keys.onUpPressed:  {
            keyNavigation = true
            wordListView.decrementCurrentIndex()
        }
        Keys.onSpacePressed:  {
            keyNavigation = true
            wordListView.currentItem.pressed()
        }
        Keys.onEnterPressed:  {
            keyNavigation = true
            wordListView.currentItem.pressed()
        }
        Keys.onReturnPressed:  {
            keyNavigation = true
            wordListView.currentItem.pressed()
        }

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
                        property string nextSource
                        function changeSource(nextSource_) {
                            nextSource = nextSource_
                            animImage.start()
                        }

                        SequentialAnimation {
                            id: animImage
                            PropertyAnimation {
                                target: wordImage
                                property: "opacity"
                                to: 0
                                duration: 100
                            }
                            PropertyAction {
                                target: wordImage
                                property: "source"
                                value: wordImage.nextSource
                            }
                            PropertyAnimation {
                                target: wordImage
                                property: "opacity"
                                to: 1
                                duration: 100
                            }
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
                model: wordListModel

                highlight:  Rectangle {
                    width: wordListView.width
                    height: wordListView.buttonHeight
                    color: "lightsteelblue"
                    radius: 5
                    visible: background.keyNavigation
                    y: wordListView.currentItem.y
                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
                highlightFollowsCurrentItem: false
                focus: true
                keyNavigationWraps: true

                property int buttonHeight: height / wordListModel.count * 0.9

                delegate: AnswerButton {
                    id: wordRectangle

                    width: wordListView.width
                    height: wordListView.buttonHeight

                    textLabel: word
                    isCorrectAnswer: word === items.goodWord.translatedTxt
                    onIncorrectlyPressed: Activity.badWordSelected(items.goodWordIndex);
                    onCorrectlyPressed: Activity.nextSubLevel();
                }
            }
        }

        onVoiceDone: repeatItem.visible = true
        onVoiceError: repeatItem.visible = false

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
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
            onWin: Activity.nextLevel()
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity.main
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("http://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: background.englishFallback = false
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }

        Loader {
            id: downloadWordsDialog
            sourceComponent: GCDialog {
                parent: activity.main
                message: qsTr("The images for this activity are not yet installed.")
                button1Text: qsTr("Download the images")
                onClose: background.downloadWordsNeeded = false
                onButton1Hit: {
                    DownloadManager.resourceRegistered.connect(handleResourceRegistered);
                    DownloadManager.downloadResource(wordsResource)
                    var downloadDialog = Core.showDownloadDialog(activity, {});
                }
            }
            anchors.fill: parent
            focus: true
            active: background.downloadWordsNeeded
            onStatusChanged: if (status == Loader.Ready) item.start()
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
