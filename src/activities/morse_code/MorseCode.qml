/* GCompris - MorseCode.qml
 *
 * SPDX-FileCopyrightText: 2016 SOURADEEP BARUA <sourad97@gmail.com>
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   SOURADEEP BARUA <sourad97@gmail.com>
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "../../core/core.js" as Core
import GCompris 1.0

ActivityBase {
    id: activity
    property string resourcesUrl: "qrc:/gcompris/src/activities/morse_code/resource/"
    onStart: focus = true
    onStop: {}

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    signal resetFocus
    onFocusChanged: {
       if(focus)
            resetFocus();
    }

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)

        signal start
        signal stop
        signal resetFocus

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
            activity.resetFocus.connect(resetFocus)
        }

        onResetFocus: {
            if (!ApplicationInfo.isMobile)
                textInput.forceActiveFocus();
        }

        property int layoutMargins: 10 * ApplicationInfo.ratio

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias textInput: textInput
            readonly property var dataset: activity.datasetLoader.data
            property bool toAlpha: dataset[currentLevel].toAlpha
            property bool audioMode: dataset[currentLevel].audioMode ? dataset[currentLevel].audioMode : false
            property string questionText: dataset[currentLevel].question
            property string questionValue
            property int numberOfLevel: dataset.length
            readonly property string middleDot: '·'
            readonly property var regexSpaceReplace: new RegExp(keyboard.space, "g")

            onToAlphaChanged: {
                textInput.text = ''
                morseConverter.alpha = ''
                if(toAlpha)
                    keyboard.populateAlpha()
                else
                    keyboard.populateMorse()
            }

            function start() {
                if (!ApplicationInfo.isMobile)
                    textInput.forceActiveFocus();
                items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
                initLevel()
            }

            function initLevel() {
                // Reset the values on the text fields
                toAlphaChanged();
                score.currentSubLevel = 1
                score.numberOfSubLevels = dataset[currentLevel].values[1].length
                if(dataset[currentLevel].values[0] == '_random_') {
                    Core.shuffle(dataset[currentLevel].values[1]);
                }
                initSubLevel()
            }

            function initSubLevel() {
                stopMorseSounds();
                questionValue = dataset[currentLevel].values[1][score.currentSubLevel-1]
                questionValue = questionValue.replace(/\./g, items.middleDot);
                questionValue = questionValue.replace(items.regexSpaceReplace, ' ');
                activity.audioVoices.clearQueue();
                // Play the audio at start of the sublevel
                if(items.audioMode) {
                    delayTimer.restart();
                }
            }

            function nextLevel() {
                currentLevel = Core.getNextLevel(currentLevel, numberOfLevel);
                initLevel();
            }

            function previousLevel() {
                currentLevel = Core.getPreviousLevel(currentLevel, numberOfLevel);
                initLevel();
            }

            function nextSubLevel() {
                textInput.text = ''
                if(++score.currentSubLevel > score.numberOfSubLevels) {
                    nextLevel();
                }
                else {
                    initSubLevel();
                }
            }

            function check() {
                if(feedback.value === items.questionValue) {
                    stopMorseSounds();
                    bonus.good('tux');
                }
                else {
                    stopMorseSounds();
                    bonus.bad('tux', bonus.checkAnswer);
                }
            }

            function stopMorseSounds() {
                // Reset soundList and stop running sound
                delayTimer.stop();
                ledContainer.soundList = [];
                ledContainer.phraseRunning = false;
                activity.stopSounds();
            }
        }

        onStart: {
            firstScreen.visible = true
            items.start()
        }
        onStop: {
            ledContainer.soundList = []
            activity.audioVoices.stop()
            activity.audioVoices.clearQueue()
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            if ((event.key === Qt.Key_Enter) || (event.key === Qt.Key_Return)) {
                if(firstScreen.visible) {
                    firstScreen.visible = false;
                }
                else {
                    items.check();
                }
            }
        }

        QtObject {
            id: morseConverter
            property string alpha
            property string morse
            // TODO Need to double check the values just in case...
            property var table: {
             "A" : ".-", "B" : "-...", "C" : "-.-.", "D" : "-..",  "E" : ".", "F" : "..-.", "G" : "--.",
             "H" : "....", "I" : "..", "J" : ".---", "K" : "-.-",  "L" : ".-..","M" : "--","N" : "-.",
             "O" : "---", "P" : ".--.", "Q" : "--.-", "R" : ".-.",  "S" : "...","T" : "-", "U" : "..-",
             "V" : "...-", "W" : ".--",  "X" : "-..-",  "Y" : "-.--","Z" : "--..","1" : ".----","2" : "..---",
             "3" : "...--",  "4" : "....-", "5" : ".....", "6" : "-....",  "7" : "--...",  "8" : "---..",
             "9" : "----." , "0" : "-----"
            }
            function morse2alpha(str) {
                var letters = ""
                var input = []
                input = str.split(' ')
                if(input[0] === "") return ''

                for(var index in input) {
                    for(var key in table) {
                        if(table[key] === input[index]) {
                            letters += key
                            continue;
                        }
                    }
                }

                if(!letters) return ''
                return letters
            }

            function alpha2morse(str) {
                var code = "";

                for(var index in str) {
                    if(table[str[index]]) {
                        code += table[str[index]] + " ";
                    }
                    else {
                        code = "";
                        break;
                    }
                }
                code = code.trim();
                return code
            }

            onAlphaChanged: morse = alpha2morse(alpha);
            onMorseChanged: alpha = morse2alpha(morse);
        }

        Rectangle {
            id: questionArea
            anchors.top: background.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.margins: background.layoutMargins
            color: "#f2f2f2"
            radius: background.layoutMargins
            height: questionLabel.height + 20 * ApplicationInfo.ratio
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - background.layoutMargins
                height: parent.height - background.layoutMargins
                color: "#f2f2f2"
                radius: parent.radius
                border.width: 3 * ApplicationInfo.ratio
                border.color: "#9fb8e3"
                GCText {
                    id: questionLabel
                    anchors.centerIn: parent
                    wrapMode: TextEdit.WordWrap
                    text: items.questionValue ? items.questionText.includes("%1") ? items.questionText.arg(items.questionValue) : items.questionText : ''
                    color: "#373737"
                    width: parent.width * 0.9
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Rectangle {
            id: inputArea
            anchors.top: questionArea.bottom
            anchors.left: background.left
            anchors.margins: background.layoutMargins
            color: "#f2f2f2"
            radius: background.layoutMargins
            width: questionArea.width * 0.5 - background.layoutMargins * 0.5
            height: textInput.height
            border.width: 1 * ApplicationInfo.ratio
            border.color: "#9fb8e3"
            TextInput {
                id: textInput
                x: parent.width / 2
                width: parent.width
                color: "#373737"
                enabled: !firstScreen.visible && !bonus.isPlaying
                text: ''
                // At best, 5 characters when looking for a letter (4 max + 1 space)
                maximumLength: items.toAlpha ? items.questionValue.split(' ').length + 1 : 5 * items.questionValue.length
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: questionLabel.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontLoader.name
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                cursorVisible: true
                wrapMode: TextInput.Wrap
                // TODO Use RegularExpressionValidator when supporting Qt5.14 minimum
                validator: RegExpValidator { regExp: items.toAlpha ?
                                                       /^[a-zA-Z0-9 ]+$/ :
                                                       /[\.\-\x00B7 ]+$/
                                           }
                onTextChanged: {
                    if(text) {
                        text = text.replace(/\./g, items.middleDot);
                        text = text.replace(items.regexSpaceReplace, ' ');
                        text = text.toUpperCase();
                        if(items.toAlpha) {
                            morseConverter.alpha = text.replace(/\W/g , '');
                        }
                        else {
                            morseConverter.morse = text.replace(/·/g, '.');
                        }
                    }
                    else {
                        morseConverter.morse = "";
                        morseConverter.alpha = "";
                    }
                }

                function appendText(car) {
                    if(car === keyboard.backspace) {
                        if(text && cursorPosition > 0) {
                            var oldPos = cursorPosition
                            text = text.substring(0, cursorPosition - 1) + text.substring(cursorPosition)
                            cursorPosition = oldPos - 1
                        }
                        return
                    }
                    var oldPos = cursorPosition
                    text = text.substring(0, cursorPosition) + car + text.substring(cursorPosition)
                    cursorPosition = oldPos + 1
                }
            }
        }

        Rectangle {
            id: feedbackArea
            anchors.top: questionArea.bottom
            anchors.margins: background.layoutMargins
            anchors.right: background.right
            width: inputArea.width
            height: inputArea.height
            color: "#f2f2f2"
            radius: background.layoutMargins
            border.width: 1 * ApplicationInfo.ratio
            border.color: "#9fb8e3"

            GCText {
                id: feedback
                anchors.horizontalCenter: parent.horizontalCenter
                text: items.toAlpha ?
                qsTr("Morse value: %1").arg(value) :
                qsTr("Alphabet/Numeric value: %1").arg(value)
                color: "#373737"
                property string value: items.toAlpha ?
                                           morseConverter.morse.replace(/\./g, items.middleDot).replace(items.regexSpaceReplace, ' ')
 :
                                           morseConverter.alpha
                verticalAlignment: Text.AlignVCenter
                width: parent.width * 0.9
                height: parent.height * 0.9
                fontSizeMode: Text.Fit
                minimumPointSize: 10
                fontSize: mediumSize
            }
        }

        Item {
            id: layoutArea
            anchors.top: feedbackArea.bottom
            anchors.topMargin: background.layoutMargins
            anchors.left: inputArea.left
            anchors.right: feedbackArea.right
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
        }

        Rectangle {
            id: ledContainer
            visible: repeatItem.visible
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.right: repeatItem.left
            anchors.rightMargin: background.layoutMargins
            height: Math.min(70 * ApplicationInfo.ratio, layoutArea.height)
            width: height
            radius:background.layoutMargins
            color: "#f2f2f2"
            border.width: 1 * ApplicationInfo.ratio
            border.color: "#9fb8e3"
            property var soundList: []
            property bool phraseRunning: false

            Rectangle {
                id: ledContour
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) * 0.9
                height: width
                radius: width * 0.5
                color: "#373737"
            }
            Image {
                id: ledOff
                source: "qrc:/gcompris/src/activities/morse_code/resource/ledOff.svg"
                anchors.centerIn: ledContour
                width: ledContour.width * 0.9
                height: width
                sourceSize.width: width
                sourceSize.height: width
            }
            Image {
                id: ledOn
                source: "qrc:/gcompris/src/activities/morse_code/resource/ledOn.svg"
                anchors.centerIn: ledContour
                width: ledContour.width * 0.9
                height: width
                sourceSize.width: width
                sourceSize.height: width
                visible: false
            }
            SequentialAnimation {
                id: dotAnim
                PropertyAction { target: ledOn; property: "visible"; value: true }
                ScriptAction { script: activity.audioVoices.append("qrc:/gcompris/src/activities/morse_code/resource/dot.wav") }
                PauseAnimation { duration: 100 }
                PropertyAction { target: ledOn; property: "visible"; value: false }
                PauseAnimation { duration: 400 }
                ScriptAction { script: ledContainer.playLedAnim() }
            }
            SequentialAnimation {
                id: dashAnim
                PropertyAction { target: ledOn; property: "visible"; value: true }
                ScriptAction { script: activity.audioVoices.append("qrc:/gcompris/src/activities/morse_code/resource/dash.wav") }
                PauseAnimation { duration: 300 }
                PropertyAction { target: ledOn; property: "visible"; value: false }
                PauseAnimation { duration: 200 }
                ScriptAction { script: ledContainer.playLedAnim() }
            }
            SequentialAnimation {
                id: silenceAnim
                PropertyAction { target: ledOn; property: "visible"; value: false }
                PauseAnimation { duration: 500 }
                ScriptAction { script: ledContainer.playLedAnim() }
            }
            function playLedAnim() {
                if(ledContainer.soundList.length > 0) {
                    var soundType = soundList.shift();
                    if (soundType === "dot.wav") {
                        dotAnim.restart();
                    } else if (soundType === "dash.wav") {
                        dashAnim.restart();
                    } else if (soundType === "silence.wav") {
                        silenceAnim.restart();
                    }
                } else {
                    ledContainer.phraseRunning = false;
                }
            }
        }

        Timer {
            id: delayTimer
            interval: 1000
            repeat: false
            running: false
            onTriggered: repeatItem.clicked()
        }

        MorseMap {
            id: morseMap
            visible: false
            onClose: home()
        }

        Score {
            id: score
            visible: !firstScreen.visible
            anchors.right: layoutArea.right
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 1
        }


        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !firstScreen.visible
            function populateAlpha() {
                layout = [ [
                              { label: "0" },
                              { label: "1" },
                              { label: "2" },
                              { label: "3" },
                              { label: "4" },
                              { label: "5" },
                              { label: "6" },
                              { label: "7" },
                              { label: "8" },
                              { label: "9" }
                           ],
                           [
                              { label: "A" },
                              { label: "B" },
                              { label: "C" },
                              { label: "D" },
                              { label: "E" },
                              { label: "F" },
                              { label: "G" },
                              { label: "H" },
                              { label: "I" },
                              { label: "J" },
                              { label: "K" },
                              { label: "L" },
                              { label: "M" }
                           ],
                           [
                              { label: "N" },
                              { label: "O" },
                              { label: "P" },
                              { label: "Q" },
                              { label: "R" },
                              { label: "S" },
                              { label: "T" },
                              { label: "U" },
                              { label: "V" },
                              { label: "W" },
                              { label: "X" },
                              { label: "Y" },
                              { label: "Z" },
                              { label: keyboard.space },
                              { label: keyboard.backspace }

                           ]
                         ]
            }

            function populateMorse() {
                layout = [ [
                    { label: items.middleDot },
                    { label: "-" },
                    { label: keyboard.space },
                    { label: keyboard.backspace }
                ] ]
            }

            onKeypress: {
                if(!bonus.isPlaying) {
                    textInput.appendText(text)
                }
                // Set the focus back to the InputText for keyboard input
                resetFocus();
            }
            onError: console.log("VirtualKeyboard error: " + msg);
        }

        FirstScreen {
            id: firstScreen
            visible: true
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            anchors.bottom: keyboard.top
            content: BarEnumContent {
                value: !firstScreen.visible ? (help | home | level | hint | activityConfig) : (help | home)
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: items.previousLevel()
            onNextLevelClicked: items.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: feedbackArea.visible = !feedbackArea.visible
        }
        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg"
            height: ledContainer.height
            width: height
            sourceSize.height: height
            sourceSize.width: height
            visible: !firstScreen.visible && items.audioMode
            anchors {
                verticalCenter: layoutArea.verticalCenter
                right: showMapButton.left
                rightMargin: background.layoutMargins
            }
            mouseArea.enabled: ledContainer.phraseRunning == false
            mouseArea.hoverEnabled: ledContainer.phraseRunning == false
            onClicked: {
                ledContainer.soundList = []
                for(var f = 0 ; f < items.questionValue.length; ++ f) {
                    var letter = items.questionValue[f];
                    // If the character to play is a letter, we convert it to morse
                    if(".·- ".indexOf(items.questionValue[f]) === -1) {
                        letter = morseConverter.alpha2morse(items.questionValue[f]);
                    }
                    // We play each character, one after the other
                    for(var i = 0 ; i < letter.length; ++ i) {
                        if(letter[i] === '-') {
                            ledContainer.soundList.push("dash.wav");
                        }
                        else if(letter[i] === '.' || letter[i] === '·') {
                            ledContainer.soundList.push("dot.wav");
                        }
                    }
                    // Add a silence after each letter
                    ledContainer.soundList.push("silence.wav")
                }
                ledContainer.phraseRunning = true;
                ledContainer.playLedAnim();
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            visible: !firstScreen.visible
            anchors.right: score.left
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.rightMargin: background.layoutMargins
            enabled: !bonus.isPlaying
            height: ledContainer.height
            width: height
            sourceSize.height: height
            sourceSize.width: height
            onClicked: items.check()
        }

        BarButton {
            id: showMapButton
            source: "qrc:/gcompris/src/activities/morse_code/resource/morseButton.svg"
            visible: !firstScreen.visible
            anchors.right: okButton.left
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.rightMargin: background.layoutMargins
            enabled: !bonus.isPlaying
            height: ledContainer.height
            width: height
            sourceSize.height: height
            sourceSize.width: height
            onClicked: {
                morseMap.visible = true
                displayDialog(morseMap)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(items.nextSubLevel)
        }
    }
}
