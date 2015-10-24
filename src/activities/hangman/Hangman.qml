﻿/* GCompris - hangman.qml
 *
 * Copyright (C) 2015 Rajdeep Kaur <rajdeep51994@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rajdeep kaur<rajdeep51994@gmail.com> (Qt Quick port)
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
import "hangman.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    
    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/hangman/resource/"
    
    onStart: focus = true
    onStop:  { }
    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

    pageComponent: Image {
        id: background
        source: activity.dataSetUrl+"background.svg"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        sourceSize.width: parent.width
        
        // system locale by default
        property string locale: "system"
                
        readonly property string wordsResource: "data2/words/words.rcc"
        property bool englishFallback: false
        property bool downloadWordsNeeded: false
        
        signal start
        signal stop
        signal voiceError
        signal voiceDone
        
        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property Item ourActivity: activity
            property alias bar: bar
            property alias bonus: bonus
            property alias keyboard: keyboard
            property alias hidden: hidden
            property alias textinput: textinput
            property alias wordImage: wordImage
            property alias score: score
            property alias parser: parser
            property alias locale: background.locale
            property int   remainingLife
            property alias imageframe: imageframe
            property variant goodWord
            property int goodWordIndex
            property alias englishFallbackDialog: englishFallbackDialog

            function playWord() {
                if (!activity.audioVoices.append(ApplicationInfo.getAudioFilePath(goodWord.voice)))
                    voiceError();
            }
            function voice() {
	            if(remainingLife == 3) {
	                playWord();
                }
            }
        }

        function handleResourceRegistered(resource) {
            if (resource == wordsResource) {
                Activity.start(items);
                Activity.focusTextInput()
            }
        }


        onStart: {
            focus = true
            activity.audioVoices.error.connect(voiceError)
            activity.audioVoices.done.connect(voiceDone)

            // check for words.rcc:
            if (DownloadManager.isDataRegistered("words")) {
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
            Activity.focusTextInput()
        }

        onStop: {
            Activity.stop();
            DownloadManager.resourceRegistered.disconnect(handleResourceRegistered);
        }

        GCText {
            id: hidden
            fontSize: largeSize
            color: "black"
            font.pointSize:5
            minimumPixelSize:20
            font.pixelSize:60
            font.letterSpacing :0.5
            anchors.horizontalCenter: parent.horizontalCenter
            y: background.height/3
        }
        
        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            enabled: !ApplicationInfo.isMobile
            visible: false
            focus: true
            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
        }
        
        Item {
  		    id: imageframe
            width: background.width/4.2
		    height: background.height/4.2
		    x: background.width/2.5
		    y: background.height/9.4
            Image {
		        id: wordImage
		        width: background.width/6
		        height: background.height/5
		        x: imageframe.width/2
		        y: imageframe.height/2
		        smooth: true
		        visible: false
		        anchors {
                    centerIn: parent
                    margins: 0.06 + parent.width
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

            Image {
		        id: threshmask
                smooth: true
                visible: false
                width: 1.3*parent.width
                height: 1.2*parent.height
                source: dataSetUrl+"fog.png"
            }

            ThresholdMask {
                id: thresh
                anchors.fill: wordImage
                source: wordImage
                maskSource: threshmask
                spread: 0.4
                threshold: 0.15 * items.remainingLife // remainingLife between 0 and 6 => threshold between 0 and 0.9
            }
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            GCComboBox {
                                id: localeBox
                                model: langs.languages
                                background: dialogActivityConfig
                                width: 250 * ApplicationInfo.ratio
                                label: qsTr("Select your locale")
                            }
                        }
                        
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["locale"]) {
                    background.locale = dataToSave["locale"];
                }
            }
            onSaveData: {
                var oldLocale = background.locale;
                var newLocale = dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                if(newLocale.indexOf('.') != -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave = {"locale": newLocale }

                background.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    background.stop();
                    background.start();
                }
            }


            function setDefaultValues() {
                var localeUtf8 = background.locale;
                if(background.locale != "system") {
                    localeUtf8 += ".UTF-8";
                }

                for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                        dialogActivityConfig.loader.item.localeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | config }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }
        
        Score {
            id: score

            anchors.top: undefined
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: keyboard.top
        }

        JsonParser {
            id: parser
            onError: console.error("Hangman: Error parsing json: " + msg);
        }

        Image {
            id: clock
            source: "qrc:/gcompris/src/activities/reversecount/resource/" + "flower" + items.remainingLife + ".svg"
            anchors {
                left: parent.left
                top: parent.top
                margins:10

            }
            sourceSize.width: 66 * bar.barZoom

        }
        
        
        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            onKeypress: Activity.processKeyPress(text);
            onError: console.log("VirtualKeyboard error: " + msg);
        }
        
        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.initSubLevel);
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
                button1Text: ApplicationInfo.isDownloadAllowed ? qsTr("Download the images") : qsTr("OK")
                onClose: background.downloadWordsNeeded = false
                onButton1Hit: {
                    if(ApplicationInfo.isDownloadAllowed) {
                        DownloadManager.resourceRegistered.connect(handleResourceRegistered);
                        DownloadManager.downloadResource(wordsResource)
                        Core.showDownloadDialog(activity, {});
                    }
                }
            }
            anchors.fill: parent
            focus: true
            active: background.downloadWordsNeeded
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
   }

}
