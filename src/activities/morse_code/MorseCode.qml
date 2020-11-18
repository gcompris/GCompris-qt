/* GCompris - MorseCode.qml
 *
 * Copyright (C) 2016 SOURADEEP BARUA <sourad97@gmail.com>
 *
 * Authors:
 *   SOURADEEP BARUA <sourad97@gmail.com>
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
import "../../core"
import GCompris 1.0
import "dataset.js" as Dataset

ActivityBase {
    id: activity
    property string url : "qrc:/gcompris/src/activities/morse_code/resource/"
    onStart: focus = true
    onStop: {}


    pageComponent: Image {
        id: background
        source: url+"background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias textInput: textInput
            property var dataset: Dataset.get()
            property bool toAlpha: dataset[currentLevel].toAlpha
            property string questionText: dataset[currentLevel].question
            property string questionValue
            property string instruction: dataset[currentLevel].instruction
            property int currentLevel: 0
            property int numberOfLevel: dataset.length
            readonly property string middle_dot: '\u00B7'

            onToAlphaChanged: {
                textInput.text = ''
                morseConverter.alpha=0
                if(toAlpha)
                    keyboard.populateAlpha()
                else
                    keyboard.populateMorse()
            }

            function start() {
                if (!ApplicationInfo.isMobile)
                    textInput.forceActiveFocus();
                items.currentLevel = 0
                initLevel()
            }

            function initLevel() {
                score.currentSubLevel = 1
                score.numberOfSubLevels = dataset[currentLevel].values[1].length
                initSubLevel()
            }

            function initSubLevel() {
                if(dataset[currentLevel].values[0] == '_random_') {
                    var randomIndex = Math.floor(Math.random() * dataset[currentLevel].values[1].length)
                    questionValue = dataset[currentLevel].values[1][randomIndex]
                    questionValue = questionValue.replace(/\./g, items.middle_dot);
                    dataset[currentLevel].values[1].splice(randomIndex,1)
                } else {
                    questionValue = dataset[currentLevel].values[1][score.currentSubLevel - 1]
                    questionValue = questionValue.replace(/\./g, items.middle_dot);
                }
            }

            function nextLevel() {
                if(numberOfLevel - 1 == currentLevel ) {
                    currentLevel = 0
                } else {
                    currentLevel++
                }

                initLevel();
            }

            function previousLevel() {
                if(currentLevel == 0) {
                    currentLevel = numberOfLevel - 1
                } else {
                    currentLevel--
                }

                initLevel();
            }

            function nextSubLevel() {
                textInput.text = ''
                if(++score.currentSubLevel > score.numberOfSubLevels) {
                    nextLevel()
                } else {
                    initSubLevel();
                }
            }

        }

        onStart: {
            first_screen.visible=true
            items.start()
        }
        onStop: {}

        QtObject {
            id: morseConverter
            property string alpha
            property string morse
            property string last
            property var table : {
             "A" : ".-", "B" : "-...", "C" : "-.-.", "D" : "-..",  "E" : ".", "F" : "..-.", "G" : "--.",
             "H" : "....", "I" : "..", "J" : ".---", "K" : "-.-",  "L" : ".-..","M" : "--","N" : "-.",
             "O" : "---", "P" : ".--.", "Q" : "--.-", "R" : ".-.",  "S" : "...","T" : "-", "U" : "..-",
             "V" : "...-", "W" : ".--",  "X" : "-..-",  "Y" : "-.--","Z" : "--..","1" : ".----","2" : "..---",
             "3" : "...--",  "4" : "....-", "5" : ".....", "6" : "-....",  "7" : "--...",  "8" : "---..",
             "9" : "----." , "0" : "-----"
            };
            function morse2alpha(str) {
                var letter=""
                var input=[]
                input = str.split(' ')
                if(input[0]==="")   return ''

                for(var key in table)
                {
                    if(table[key]===input[0])
                        letter = key
                }

                if(!letter) return ''
                return letter
            }

            function alpha2morse(str) {
                if(str==="0" && last!="9") return ''

                var code="";

                if(table[str])
                    code=table[str];
                else code="";

                morseConverter.last=str
                return code
            }
            onAlphaChanged: morse = alpha2morse(alpha)
            onMorseChanged: alpha = morse2alpha(morse)

        }

        Column {
            id: column
            anchors.fill: parent
            anchors.topMargin: 10
            Image {
                id: tux
                source:url+"tux.svg"
                fillMode: Image.PreserveAspectCrop
                width: 100 * ApplicationInfo.ratio
                height: 100 * ApplicationInfo.ratio

                anchors.bottomMargin: 200
                anchors.leftMargin: 75
                anchors.horizontalCenter: parent.horizontalCenter
            }

            GCText {
                id: questionLabel
                anchors.horizontalCenter: parent.horizontalCenter
                text: items.questionValue ? items.questionText.arg(items.questionValue) : ''
                color: 'white'
                fontSizeMode: Text.Fit
                Rectangle {
                    z: -1
                    border.color: 'black'
                    border.width: 1
                    anchors.centerIn: parent
                    width: parent.width * 1.1
                    height: parent.height
                    opacity: 0.8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#000" }
                        GradientStop { position: 0.9; color: "#666" }
                        GradientStop { position: 1.0; color: "#AAA" }
                    }
                    radius: 10
                }
            }
            Item { // Just a margin
                width: 1
                height: 5 * ApplicationInfo.ratio
            }
            TextInput {
                id: textInput
                anchors.horizontalCenter: parent.horizontalCenter
                width: 50 * ApplicationInfo.ratio
                color: 'white'
                text: ''
                maximumLength: items.toAlpha ? 1:5
                horizontalAlignment: TextInput.AlignLeft
                font.pointSize: questionLabel.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontLoader.name
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                cursorVisible: true
                validator: RegExpValidator { regExp: items.toAlpha ?
                                                       /^[a-zA-Z0-9]+$/ :
                                                       /[.- ]*/}


                onTextChanged: if(!(first_screen.visible) && !(morse_map.visible) && text) {
                                   text = text.replace(/\./g, items.middle_dot);
                                   text = text.toUpperCase();
                                   if(items.toAlpha){
                                        morseConverter.alpha = text.replace( /\W/g , '')
                                   }
                                   else
                                       morseConverter.morse = text.replace(/\u00B7/g, '.');

                               }

                Rectangle {
                    z: -1
                    opacity: 0.8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#000" }
                        GradientStop { position: 0.9; color: "#666" }
                        GradientStop { position: 1.0; color: "#AAA" }
                    }
                    radius: 10
                    border.color: 'black'
                    border.width: 1
                    anchors.centerIn: parent
                    width: column.width * 0.5
                    height: parent.height
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
            Item { // Just a margin
                width: 1
                height: 5 * ApplicationInfo.ratio
            }
            GCText {
                id: feedback
                anchors.horizontalCenter: parent.horizontalCenter
                text: first_screen.visible ? '' :(items.toAlpha ?
                          qsTr("Morse value: %1").arg(value) :
                          qsTr('Alphabet/Numeric value: %1').arg(value))
                onTextChanged: timer.start()
                color: 'white'
                fontSizeMode: Text.Fit
                Rectangle {
                    z: -1
                    opacity: 0.8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#000" }
                        GradientStop { position: 0.9; color: "#666" }
                        GradientStop { position: 1.0; color: "#AAA" }
                    }
                    radius: 10
                    border.color: 'black'
                    border.width: 1
                    anchors.centerIn: parent
                    width: parent.width * 1.1
                    height: parent.height
                }
                property string value: first_screen.visible ? '' : items.toAlpha ?
                                           morseConverter.morse.replace(/\./g, items.middle_dot).trim() :
                                           morseConverter.alpha ? morseConverter.alpha.replace(/\./g, items.middle_dot) : ''
            }

            Timer {
                id: timer
                interval: 5
                onTriggered: {
                    if(!first_screen.visible && feedback.value == items.questionValue ) {
                        bonus.good('tux')
                    }

                }
            }
            Item {
                id:margin
                width: 1
                height: 20 * ApplicationInfo.ratio
            }

            GCText {
                id: instruction

                fontSize: largeSize
                minimumPixelSize: 70
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.5
                text: items.instruction.replace(/\./g, items.middle_dot)
                height: Text.Fit
                wrapMode: TextEdit.WordWrap
                color: 'black'

            }


        }

        Rectangle {
            id: morse_map
            width: parent.width * 0.8
            height: parent.height * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            visible: false

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: grid1.height * 1.1
                flickableDirection: Flickable.VerticalFlick
                clip: true

                Flow {
                    id: grid1
                    width: parent.width * 0.9
                    anchors {
                        top: parent.top
                        topMargin: 10 * ApplicationInfo.ratio
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 5 * ApplicationInfo.ratio

                    Repeater {
                        id: cardRepeater
                        model: [
                            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                            "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                            "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4",
                            "5", "6", "7", "8", "9", "0"
                        ]

                        Column {
                            Rectangle {
                                id: rect1
                                width:  100
                                height: ins.height
                                border.width: 3
                                border.color: "black"
                                color: "white"

                                GCText {
                                    id: ins
                                    text: morseConverter.table[modelData].replace(/\./g, items.middle_dot)
                                    style: Text.Outline
                                    styleColor: "white"
                                    color: "black"
                                    fontSize: 10
                                    anchors.centerIn: parent
                                }
                            }
                            GCText {
                                id: text1
                                text: modelData
                                font.weight: Font.DemiBold
                                style: Text.Outline
                                styleColor: "black"
                                color: "black"
                                fontSize: Math.max(Math.min(parent.width * 0.2, 24), 12)
                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
        }

        Score {
            id: score
            visible: !(first_screen.visible)
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.right: undefined
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
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
                              { label: "W" },
                              { label: "X" },
                              { label: "Y" },
                              { label: "Z" },
                              { label: keyboard.backspace }

                           ]
                         ]

            }

            function populateMorse() {
                layout = [ [
                    { label: items.middle_dot },
                    { label: "-" },
                    { label: keyboard.backspace }
                ] ]
            }

            onKeypress: {
                if(!morse_map.visible)
                    textInput.appendText(text)
            }
            onError: console.log("VirtualKeyboard error: " + msg);
        }

        FirstScreen {
            id: first_screen
            visible: true
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: (!first_screen.visible)?(help | home | level | hint):(help | home) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: items.previousLevel()
            onNextLevelClicked: items.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: {
                morse_map.visible = !morse_map.visible
                keyboard.visible = !morse_map.visible & ApplicationSettings.isVirtualKeyboard
            }

            level: items.currentLevel + 1
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(items.nextSubLevel)
        }

    }
}

