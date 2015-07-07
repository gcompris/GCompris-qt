/* GCompris - hangman.qml
 *
 * Copyright (C) 2015 Rajdeep Kaur <rajdeep51994@gmail.com>
 *
 * Authors:
 *   Bruno copyright to: Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
    onStop: {}
    
    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

    pageComponent: Image {
        id: background
        source:activity.dataSetUrl+"background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        anchors.fill: parent
        
        readonly property string wordsResource: "data2/words/words.rcc"
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

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property Item ourActivity: activity
            property alias bar: bar
            property alias bonus: bonus
            property alias keyboard:keyboard
            property alias hidden:hidden
            property alias textinput: textinput
            property alias ping:ping
            property alias flower:flower
            property alias ping_animation:ping_animation
            property alias wordImage: wordImage
            property alias score: score
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


        onStart: { Activity.start(items);
            Activity.focusTextInput();

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
        }

        onStop: { Activity.stop() }

        GCText {

            id:hidden
            anchors.centerIn: parent
            fontSize: largeSize
            color:"black"
            font.pointSize:60
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.verticalCenter:parent.verticalCenter
            
        }
        
        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            enabled: !ApplicationInfo.isMobile
            focus: true
            visible:false
            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
            

        }
        
        
        Image {    id:imageframe
            visible:true
            width:parent.width/5
            height:parent.height/5
            anchors.horizontalCenter:background.horizontalCenter
            y:background.height/10
            source:dataSetUrl+"imageid_frame.svg"
            Image{
                id:wordImage
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
        
        

        Image{
            id:ping
            visible:true
            width:parent.width/10
            height:parent.height/5
            x:background.width/6
            y:6*background.height/10
            source:activity.dataSetUrl+"pingu.svg";
            Behavior on x {
                PropertyAnimation {
                    id: xAnima
                    easing.type: Easing.InQuad
                    duration:  10000

                }
            }
        }
        Image{

            id:flower
            visible:false
            width:ping.width/4
            height:ping.height/6
            source:activity.dataSetUrl+"flower.svg";
            anchors.left:ping.left
            y:6.5*background.height/10


        }
        SequentialAnimation{  id:ping_animation
            PropertyAnimation{
                target:flower
                property:"visible" ;to:true
            }
            PropertyAnimation{
                target:ping
                property:"x" ;from:background.width/6; to :background.width/11
                duration:1000
                easing.type: Easing.InQuad
            }
            PropertyAnimation{
                target:flower
                property:"visible" ;to:"false"
            }
            PropertyAnimation{
                target:ping
                property:"x" ;from:background.width/11; to :background.width/6
                duration:1000
                easing.type: Easing.InQuad
            }



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
            
            onError: console.error("Imageid: Error parsing json: " + msg);
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
