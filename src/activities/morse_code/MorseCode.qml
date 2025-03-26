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
import QtQuick 2.15
import "../../core"
import "../../core/core.js" as Core
import core 1.0

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
        id: activityBackground
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/background.svg"
        width: parent.width
        height: parent.height
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

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

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias textInput: textInput
            readonly property var dataset: activity.datasets
            property bool toAlpha: false
            property bool audioMode: false
            property string questionText: ""
            property string questionValue
            property int numberOfLevel: dataset.length
            property bool buttonsBlocked: false
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
                errorRectangle.resetState();
                items.toAlpha = dataset[currentLevel].toAlpha;
                items.audioMode = dataset[currentLevel].audioMode ? dataset[currentLevel].audioMode : false
                items.questionText = dataset[currentLevel].question;
                // Reset the values on the text fields
                toAlphaChanged();
                score.currentSubLevel = 0
                score.numberOfSubLevels = dataset[currentLevel].values[1].length
                if(dataset[currentLevel].values[0] == '_random_') {
                    Core.shuffle(dataset[currentLevel].values[1]);
                }
                initSubLevel()
            }

            function initSubLevel() {
                textInput.text = ''
                stopMorseSounds();
                questionValue = dataset[currentLevel].values[1][score.currentSubLevel]
                questionValue = questionValue.replace(/\./g, items.middleDot);
                questionValue = questionValue.replace(items.regexSpaceReplace, ' ');
                activity.audioVoices.clearQueue();
                // Play the audio at start of the sublevel
                if(items.audioMode) {
                    delayTimer.restart();
                }
                items.buttonsBlocked = false;
            }

            function nextLevel() {
                score.stopWinAnimation();
                currentLevel = Core.getNextLevel(currentLevel, numberOfLevel);
                initLevel();
            }

            function previousLevel() {
                score.stopWinAnimation();
                currentLevel = Core.getPreviousLevel(currentLevel, numberOfLevel);
                initLevel();
            }

            function nextSubLevel() {
                if(score.currentSubLevel >= score.numberOfSubLevels) {
                    bonus.good('tux');
                }
                else {
                    initSubLevel();
                }
            }

            function check() {
                items.buttonsBlocked = true;
                if(feedback.value === items.questionValue) {
                    stopMorseSounds();
                    score.currentSubLevel++;
                    score.playWinAnimation();
                    goodAnswerSound.play();
                }
                else {
                    stopMorseSounds();
                    errorRectangle.startAnimation();
                    badAnswerSound.play();
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

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            if ((event.key === Qt.Key_Enter) || (event.key === Qt.Key_Return)) {
                if(firstScreen.visible) {
                    firstScreen.visible = false;
                }
                else {
                    items.check();
                }
            }
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
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
            function morse2alpha(str: string): string {
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

            function alpha2morse(str: string): string {
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
            anchors.top: activityBackground.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.margins: GCStyle.baseMargins
            color: GCStyle.lightBg
            radius: GCStyle.baseMargins
            height: questionLabel.height + 2 * GCStyle.baseMargins
            Rectangle {
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                color: GCStyle.lightBg
                radius: GCStyle.halfMargins
                border.width: GCStyle.midBorder
                border.color: GCStyle.blueBorder
                GCText {
                    id: questionLabel
                    anchors.centerIn: parent
                    wrapMode: TextEdit.WordWrap
                    text: items.questionValue ? items.questionText.includes("%1") ? items.questionText.arg(items.questionValue) : items.questionText : ''
                    color: GCStyle.darkText
                    width: parent.width - GCStyle.baseMargins
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            id: inputArea
            anchors.top: questionArea.bottom
            anchors.left: activityBackground.left
            anchors.margins: GCStyle.baseMargins
            color: GCStyle.lightBg
            radius: GCStyle.halfMargins
            width: questionArea.width * 0.5 - GCStyle.halfMargins
            height: textInput.height
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.blueBorder
            TextInput {
                id: textInput
                x: parent.width * 0.5
                width: parent.width
                color: GCStyle.darkText
                enabled: !firstScreen.visible && !items.buttonsBlocked
                text: ''
                // At best, 5 characters when looking for a letter (4 max + 1 space)
                maximumLength: items.toAlpha ? items.questionValue.split(' ').length + 1 : 5 * items.questionValue.length
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: questionLabel.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontName
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                cursorVisible: true
                wrapMode: TextInput.Wrap
                validator: RegularExpressionValidator { regularExpression: items.toAlpha ?
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
            anchors.margins: GCStyle.baseMargins
            anchors.right: activityBackground.right
            width: inputArea.width
            height: inputArea.height
            color: GCStyle.lightBg
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.blueBorder

            GCText {
                id: feedback
                anchors.centerIn: parent
                text: items.toAlpha ?
                qsTr("Morse value: %1").arg(value) :
                qsTr("Alphabet/Numeric value: %1").arg(value)
                color: GCStyle.darkText
                property string value: items.toAlpha ?
                                           morseConverter.morse.replace(/\./g, items.middleDot).replace(items.regexSpaceReplace, ' ')
 :
                                           morseConverter.alpha
                verticalAlignment: Text.AlignVCenter
                width: parent.width - GCStyle.baseMargins * 2
                height: parent.height - GCStyle.baseMargins
                fontSizeMode: Text.Fit
                minimumPointSize: 10
                fontSize: mediumSize
            }
        }

        Item {
            id: layoutArea
            anchors.top: feedbackArea.bottom
            anchors.topMargin: GCStyle.baseMargins
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
            anchors.rightMargin: GCStyle.baseMargins
            height: Math.min(GCStyle.bigButtonHeight, layoutArea.height)
            width: height
            radius:GCStyle.baseMargins
            color: GCStyle.lightBg
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.blueBorder
            property var soundList: []
            property bool phraseRunning: false

            Rectangle {
                id: ledContour
                anchors.centerIn: parent
                width: parent.height * 0.9
                height: width
                radius: width * 0.5
                color: GCStyle.darkBg
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
                width: ledOff.width
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

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: inputArea
            radius: inputArea.radius
            imageSize: height * 1.5
            function releaseControls() {
                items.buttonsBlocked = false;
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
            onStop: items.nextSubLevel()
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
                activityBackground.stop()
                activityBackground.start()
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
            enabled: visible && !items.buttonsBlocked
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

            onKeypress: (text) => {
                if(!items.buttonsBlocked) {
                    textInput.appendText(text)
                }
                // Set the focus back to the InputText for keyboard input
                resetFocus();
            }
            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
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
            width: ledContainer.height
            visible: !firstScreen.visible && items.audioMode
            anchors {
                verticalCenter: layoutArea.verticalCenter
                right: showMapButton.left
                rightMargin: GCStyle.baseMargins
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
            anchors.rightMargin: GCStyle.baseMargins
            enabled: !items.buttonsBlocked
            width: ledContainer.height
            onClicked: items.check()
        }

        BarButton {
            id: showMapButton
            source: "qrc:/gcompris/src/activities/morse_code/resource/morseButton.svg"
            visible: !firstScreen.visible
            anchors.right: okButton.left
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.rightMargin: GCStyle.baseMargins
            enabled: !items.buttonsBlocked
            width: ledContainer.height
            onClicked: {
                morseMap.visible = true
                displayDialog(morseMap)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(items.nextLevel)
        }
    }
}
