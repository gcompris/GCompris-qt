/* GCompris - roman_numerals.qml
 *
 * Copyright (C) 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}


    pageComponent: Image {
        id: background
        source: items.toArabic ?
                    "qrc:/gcompris/src/activities/roman_numerals/resource/arcs.svg" :
                    "qrc:/gcompris/src/activities/roman_numerals/resource/torrazzo-crema.svg"
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

            property bool toArabic: dataset[currentLevel].toArabic
            property string questionText: dataset[currentLevel].question
            property string instruction: dataset[currentLevel].instruction
            property string questionValue

            property int currentLevel: 0
            property int numberOfLevel: dataset.length

            property var dataset: [
                {
                    values: ['I', 'V', 'X', 'L', 'C', 'D', 'M'],
                    instruction: qsTr("Roman numerals, are based on seven symbols: \nI = 1, V = 5\nX = 10, L = 50\nC = 100, D = 500\nM = 1000"),
                    question: qsTr("Convert the roman number %1 in arabic."),
                    toArabic: true
                },
                {
                    values: [1, 5, 10, 50, 100, 500, 1000],
                    instruction: qsTr("Roman numerals, are based on seven symbols: \nI = 1, V = 5\nX = 10, L = 50\nC = 100, D = 500\nM = 1000"),
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['II', 'III', 'VI', 'XX', 'XXII', 'XXX', 'LX', 'CC', 'CCL', 'MM', 'CLX', 'DCCLI', 'CCCLXVI'],
                    instruction: qsTr("Several symbols create a larger number like:\nII = 2\nXX = 20\nXI = 11"),
                    question: qsTr("Convert the roman number %1 in arabic."),
                    toArabic: true
                },
                {
                    values: [2, 3, 6, 20, 22, 30, 60, 200, 250, 2000, 160, 651, 361],
                    instruction: qsTr("Several symbols create a larger number like:\nII = 2\nXX = 20\nXI = 11"),
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['IV', 'IX', 'XL', 'XC', 'CD', 'CM'],
                    instruction: qsTr("If a lower value symbol is before a higher value one, it is subtracted. Otherwise it is added. So:\n'IV' is '4'\n'VI' is '6'\n'IX' is '9'"),
                    question: qsTr("Convert the roman number %1 in arabic."),
                    toArabic: true
                },
                {
                    values: [4, 9, 40, 90, 400, 900],
                    instruction: qsTr("If a lower value symbol is before a higher value one, it is subtracted. Otherwise it is added. So:\n'IV' is '4'\n'VI' is '6'\n'IX' is '9'"),
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['VIII', 'LXXX', 'CCCCLXXX', 'DCCC', 'MCCC'],
                    instruction: qsTr("Only one number is subtracted, not two. So 8 is always VIII and never IIX."),
                    question: qsTr("Convert the roman number %1 in arabic."),
                    toArabic: true
                },
                {
                    values: [8, 70, 480, 800, 1300],
                    instruction: qsTr("Only one number is subtracted, not two. So 8 is always VIII and never IIX."),
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['XLIX', 'CMXC', 'XCV', 'XLVIII', 'CMXCIX', 'XLVI', 'CXCII', 'CDLXXV'],
                    instruction: qsTr("Proper form is to subtract only a value with the next lower power of 10. Thus, 900 is written CM, but 990 would not be XM - properly, it is CM for the 900 portion and XC for the 90 portion, or CMXC. Similarly, 999 would not be IM but rather CMXCIX - CM for the 900 portion, XC for the 90 portion, and IX for the 9 portion. Only values starting in 1's are ever used to subtract; 45 is properly XLV, not VL."),
                    question: qsTr("Convert the roman number %1 in arabic."),
                    toArabic: true
                },
                {
                    values: [48, 991, 96, 49, 998, 47, 193, 472, 1092],
                    instruction: qsTr("Proper form is to subtract only a value with the next lower power of 10. Thus, 900 is written CM, but 990 would not be XM - properly, it is CM for the 900 portion and XC for the 90 portion, or CMXC. Similarly, 999 would not be IM but rather CMXCIX - CM for the 900 portion, XC for the 90 portion, and IX for the 9 portion. Only values starting in 1's are ever used to subtract; 45 is properly XLV, not VL."),
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 50 /* up to this number */ , 10 /* sublevels */],
                    instruction: qsTr("Now you know the rules, you can read and write any numbers in roman numerals."),
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 100, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 500, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 1000, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 in roman."),
                    toArabic: false
                }
            ]

            onQuestionValueChanged: {
                textInput.text = ''
                romanConverter.arabic = 0
                if(toArabic)
                    keyboard.populateArabic()
                else
                    keyboard.populateRoman()

            }

            function start() {
                if (!ApplicationInfo.isMobile)
                    textInput.forceActiveFocus();
                items.currentLevel = 0
                initLevel()
            }

            function initLevel() {
                score.currentSubLevel = 1
                initSubLevel()
            }

            function initSubLevel() {
                if(dataset[currentLevel].values[0] == '_random_') {
                    questionValue = Math.round(Math.random() * dataset[currentLevel].values[1] + 1)
                    score.numberOfSubLevels = dataset[currentLevel].values[2]
                } else {
                    questionValue = dataset[currentLevel].values[score.currentSubLevel - 1]
                    score.numberOfSubLevels = dataset[currentLevel].values.length
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
                if(++score.currentSubLevel > score.numberOfSubLevels) {
                    nextLevel()
                } else {
                    initSubLevel();
                }
            }

            property bool isChecking: false
            function check() {
                if(isChecking) {
                    return
                }
                isChecking = true
                if(feedback.value == items.questionValue) {
                    bonus.good('tux')
                } else {
                    bonus.bad('tux')
                }
            }
        }

        onStart: {
            items.start()
        }
        onStop: { }

        Keys.onPressed: {
            if ((event.key === Qt.Key_Enter) || (event.key === Qt.Key_Return)) {
                items.check()
            }
        }

        QtObject {
            id: romanConverter
            property int arabic
            property string roman

            // conversion code copied from:
            // http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter
            function arabic2Roman(num) {
                if (!+num)
                    return '';
                var digits = String(+num).split(""),
                        key = ["","C","CC","CCC","CD","D","DC","DCC","DCCC","CM",
                               "","X","XX","XXX","XL","L","LX","LXX","LXXX","XC",
                               "","I","II","III","IV","V","VI","VII","VIII","IX"],
                        roman = "",
                        i = 3;
                while (i--)
                    roman = (key[+digits.pop() + (i * 10)] || "") + roman;
                return new Array(+digits.join("") + 1).join("M") + roman;
            }

            function roman2Arabic(str) {
                var	str = str.toUpperCase(),
                        validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/,
                        token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/g,
                        key = {M:1000,CM:900,D:500,CD:400,C:100,XC:90,L:50,XL:40,X:10,IX:9,V:5,IV:4,I:1},
                num = 0, m;
                if (!(str && validator.test(str)))
                    return false;
                while (m = token.exec(str))
                    num += key[m[0]];
                return num;
            }
            onArabicChanged: roman = arabic2Roman(arabic)
            onRomanChanged: arabic = roman2Arabic(roman)
        }

        Column {
            id: column
            anchors.fill: parent
            anchors.topMargin: 10
            GCText {
                id: questionLabel
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: TextEdit.WordWrap
                text: items.questionValue ? items.questionText.arg(items.questionValue) : ''
                color: 'white'
                width: parent.width * 0.9
                horizontalAlignment: Text.AlignHCenter
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
                x: parent.width / 2
                width: 60 * ApplicationInfo.ratio
                color: 'white'
                text: ''
                maximumLength: items.toArabic ?
                                   ('' + romanConverter.roman2Arabic(items.questionValue)).length + 1 :
                                   romanConverter.arabic2Roman(items.questionValue).length + 1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: questionLabel.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontLoader.name
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                cursorVisible: true
                validator: RegExpValidator{regExp: items.toArabic ?
                                                       /[0-9]+/ :
                                                       /[ivxlcdmIVXLCDM]*/}
                onTextChanged: if(text) {
                                   text = text.toUpperCase();
                                   if(items.toArabic)
                                       romanConverter.arabic = parseInt(text)
                                   else
                                       romanConverter.roman = text
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
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: column.width * 0.7
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
                text: items.toArabic ?
                          qsTr("Roman value: %1").arg(value) :
                          qsTr('Arabic value: %1').arg(value)
                color: 'white'
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
                property string value: items.toArabic ?
                                           romanConverter.roman :
                                           romanConverter.arabic ? romanConverter.arabic : ''
            }
            Item { // Just a margin
                width: 1
                height: 5 * ApplicationInfo.ratio
            }
            Rectangle {
                color: "transparent"
                width: parent.width
                height: (background.height - (y + bar.height + okButton.height + keyboard.height) * 1.1 )
                Flickable {
                    width: parent.width
                    height: parent.height
                    contentWidth: parent.width
                    contentHeight: instructionContainer.height
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    clip: true
                    GCText {
                        id: instruction
                        visible: items.instruction != ''
                        wrapMode: TextEdit.WordWrap
                        fontSize: tinySize
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.95
                        text: items.instruction
                        horizontalAlignment: Text.AlignHCenter
                        color: 'white'
                        Rectangle {
                            id: instructionContainer
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
                            width: parent.width
                            height: parent.contentHeight
                        }
                    }
                }
            }
        }

        Score {
            id: score
            anchors.bottom: bar.top
            currentSubLevel: 0
            numberOfSubLevels: 1
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            function populateArabic() {
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
                    { label: "9" },
                    { label: keyboard.backspace }
                ] ]
            }

            function populateRoman() {
                layout = [ [
                    { label: "I" },
                    { label: "V" },
                    { label: "X" },
                    { label: "L" },
                    { label: "C" },
                    { label: "D" },
                    { label: "M" },
                    { label: keyboard.backspace }
                ] ]
            }

            onKeypress: textInput.appendText(text)

            onError: console.log("VirtualKeyboard error: " + msg);
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: items.previousLevel()
            onNextLevelClicked: items.nextLevel()
            onHomeClicked: activity.home()
            level: items.currentLevel + 1
            onHintClicked: feedback.visible = !feedback.visible
        }
        BarButton {
          id: okButton
          source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
          sourceSize.width: 60 * ApplicationInfo.ratio
          visible: true
          anchors {
              verticalCenter: score.verticalCenter
              right: score.left
              rightMargin: 10 * ApplicationInfo.ratio
              bottomMargin: 10 * ApplicationInfo.ratio
          }
          onClicked: items.check()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(items.nextSubLevel)
            onWin: items.isChecking = false
            onLoose: items.isChecking = false
        }

    }
}
