/* GCompris - roman_numerals.qml
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *   Timothée Giet <animtim@gmail.com> (layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

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
        source: items.toArabic ?
                    "qrc:/gcompris/src/activities/roman_numerals/resource/arabian-building.svg" :
                    "qrc:/gcompris/src/activities/roman_numerals/resource/roman-building.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        signal start
        signal stop
        signal resetFocus

        readonly property bool isHorizontal: width >= height

        onResetFocus: {
            if (!ApplicationInfo.isMobile)
                textInput.forceActiveFocus();
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
            activity.resetFocus.connect(resetFocus)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias bonus: bonus
            property alias score: score
            property alias textInput: textInput

            property bool toArabic: dataset[currentLevel].toArabic
            property string questionText: dataset[currentLevel].question
            property string instruction: dataset[currentLevel].instruction
            property string questionValue

            // we initialize it to -1, so on start() function,
            // it forces a layout refresh when it's set to 0
            property int currentLevel: -1
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: dataset.length
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
            property bool buttonsBlocked: false

            property var dataset: [
                {
                    values: ['I', 'V', 'X', 'L', 'C', 'D', 'M'],
                    instruction: qsTr("The roman numbers are all built out of these 7 numbers:\nI and V (units, 1 and 5)\nX and L (tens, 10 and 50)\nC and D (hundreds, 100 and 500)\n and M (1000).\n An interesting observation here is that the roman numeric system lacks the number 0."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [1, 5, 10, 50, 100, 500, 1000],
                    instruction: qsTr("The roman numbers are all built out of these 7 numbers:\nI and V (units, 1 and 5)\nX and L (tens, 10 and 50)\nC and D (hundreds, 100 and 500)\n and M (1000).\n An interesting observation here is that the roman numeric system lacks the number 0."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'],
                    instruction: qsTr("All the units except 4 and 9 are built using sums of I and V:\nI, II, III, V, VI, VII, VIII.\n The 4 and the 9 units are built using differences:\nIV (5 – 1) and IX (10 – 1)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [2, 3, 4, 5, 6, 7, 8, 9],
                    instruction: qsTr("All the units except 4 and 9 are built using sums of I and V:\nI, II, III, V, VI, VII, VIII.\n The 4 and the 9 units are built using differences:\nIV (5 – 1) and IX (10 – 1)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['XX', 'XXX', 'XL', 'LX', 'LXX', 'LXXX', 'XC'],
                    instruction: qsTr("All the tens except 40 and 90 are built using sums of X and L:\nX, XX, XXX, L, LX, LXX, LXXX.\nThe 40 and the 90 tens are built using differences:\nXL (10 taken from 50) and XC (10 taken from 100)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [20, 30, 40, 60, 70, 80, 90],
                    instruction: qsTr("All the tens except 40 and 90 are built using sums of X and L:\nX, XX, XXX, L, LX, LXX, LXXX.\nThe 40 and the 90 tens are built using differences:\nXL (10 taken from 50) and XC (10 taken from 100)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['CC', 'CCC', 'CD', 'DC', 'DCC', 'DCCC', 'CM', ],
                    instruction: qsTr("All the hundreds except 400 and 900 are built using sums of C and D:\nC, CC, CCC, D, DC, DCC, DCCC.\nThe 400 and the 900 hundreds are built using differences:\nCD (100 taken from 500) and CM (100 taken from 1000)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [200, 300, 400, 600, 700, 800, 900],
                    instruction: qsTr("All the hundreds except 400 and 900 are built using sums of C and D:\nC, CC, CCC, D, DC, DCC, DCCC.\nThe 400 and the 900 hundreds are built using differences:\nCD (100 taken from 500) and CM (100 taken from 1000)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['MM', 'MMM'],
                    instruction: qsTr("Sums of M are used for building thousands: M, MM, MMM.\nNotice that you cannot join more than three identical symbols. The first implication of this rule is that you cannot use just sums for building all possible units, tens or hundreds, you must use differences too. On the other hand, it limits the maximum roman number to 3999 (MMMCMXCIX)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [2000, 3000],
                    instruction: qsTr("Sums of M are used for building thousands: M, MM, MMM.\nNotice that you cannot join more than three identical symbols. The first implication of this rule is that you cannot use just sums for building all possible units, tens or hundreds, you must use differences too. On the other hand, it limits the maximum roman number to 3999 (MMMCMXCIX)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 50 /* up to this number */ , 10 /* sublevels */],
                    instruction: qsTr("Now you know the rules, you can read and write numbers in roman numerals."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 100, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 500, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 1000, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 to roman."),
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
                items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
                initLevel()
            }

            function initLevel() {
                errorRectangle.resetState()
                score.currentSubLevel = 0
                initSubLevel()
            }

            function initSubLevel() {
                if(dataset[currentLevel].values[0] === '_random_') {
                    questionValue = Math.round(Math.random() * dataset[currentLevel].values[1] + 1)
                    score.numberOfSubLevels = dataset[currentLevel].values[2]
                } else {
                    questionValue = dataset[currentLevel].values[score.currentSubLevel]
                    score.numberOfSubLevels = dataset[currentLevel].values.length
                }
                items.buttonsBlocked = false
            }

            function nextLevel() {
                score.stopWinAnimation()
                currentLevel = Core.getNextLevel(currentLevel, items.numberOfLevel);
                initLevel();
            }

            function previousLevel() {
                score.stopWinAnimation()
                currentLevel = Core.getPreviousLevel(currentLevel, items.numberOfLevel);
                initLevel();
            }

            function nextSubLevel() {
                if(score.currentSubLevel >= score.numberOfSubLevels) {
                    bonus.good("tux")
                } else {
                    initSubLevel();
                }
            }

            function check() {
                items.buttonsBlocked = true
                if(feedback.value == items.questionValue) {
                    score.currentSubLevel += 1;
                    score.playWinAnimation();
                    goodAnswerSound.play();
                } else {
                    badAnswerSound.play();
                    errorRectangle.startAnimation()
                }
            }
        }

        onStart: {
            items.start()
        }
        onStop: { }

        Keys.onPressed: (event) => {
            if ((event.key === Qt.Key_Enter) || (event.key === Qt.Key_Return)) {
                if(!items.buttonsBlocked)
                    items.check()
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
            id: romanConverter
            property int arabic
            property string roman

            // conversion code copied from:
            // http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter
            function arabic2Roman(num: int) : string {
                if (!+num || num > 3999)
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

            function roman2Arabic(str: string) : int {
                var upperStr = str.toUpperCase();
                var validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/;
                var token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/g;
                var key = {M:1000,CM:900,D:500,CD:400,C:100,XC:90,L:50,XL:40,X:10,IX:9,V:5,IV:4,I:1};
                var num = 0;
                var m;
                if (!(upperStr && validator.test(upperStr)))
                    return false;
                while (m = token.exec(upperStr))
                    num += key[m[0]];
                return num;
            }
            onArabicChanged: roman = arabic2Roman(arabic)
            onRomanChanged: arabic = roman2Arabic(roman)
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: parent.height - bar.y + bar.height * 0.2 // in case VirtualKeyboard is visible, the layout is reduced...
            property int heightUnit: (height - 3 * GCStyle.baseMargins) * 0.1
        }

        GCTextPanel {
            id: questionPanel
            panelWidth: layoutArea.width
            panelHeight: Math.min(50 * ApplicationInfo.ratio, layoutArea.heightUnit * 2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            color: GCStyle.lightBg
            border.color: GCStyle.blueBorder
            border.width: GCStyle.thinBorder
            textItem.color: GCStyle.darkText
            textItem.text: items.questionValue ? items.questionText.arg(items.questionValue) : ''
        }

        Rectangle {
            id: inputArea
            anchors.top: questionPanel.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.horizontalCenterOffset: -layoutArea.width * 0.25
            color: GCStyle.lightBg
            radius: GCStyle.halfMargins
            width: Math.min(layoutArea.width * 0.5, 200 * ApplicationInfo.ratio)
            height: layoutArea.heightUnit * 1.5
            TextInput {
                id: textInput
                anchors.centerIn: parent
                width: parent.width - GCStyle.baseMargins
                height: parent.height - GCStyle.baseMargins
                enabled: !items.buttonsBlocked
                color: GCStyle.darkText
                text: ''
                maximumLength: items.toArabic ?
                ('' + romanConverter.roman2Arabic(items.questionValue)).length + 1 :
                romanConverter.arabic2Roman(items.questionValue).length + 1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                scale: Math.min(1, width / contentWidth, height / contentHeight)
                font.pointSize: feedback.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontName
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                cursorVisible: true
                wrapMode: TextInput.Wrap
                validator: RegularExpressionValidator{ regularExpression: items.toArabic ?
                    /[0-9]+/ :
                    /[ivxlcdmIVXLCDM]*/}
                    onTextChanged: if(text) {
                        text = text.toUpperCase();
                        if(items.toArabic)
                            romanConverter.arabic = parseInt(text)
                            else
                                romanConverter.roman = text
                    }

                function appendText(car: string) {
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
            anchors.top: inputArea.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.horizontalCenterOffset: inputArea.anchors.horizontalCenterOffset
            width: inputArea.width
            height: inputArea.height
            color: GCStyle.lightBg
            radius: GCStyle.halfMargins

            GCText {
                id: feedback
                anchors.centerIn: parent
                text: items.toArabic ?
                qsTr("Roman value: %1").arg(value) :
                qsTr('Arabic value: %1').arg(value)
                color: GCStyle.darkText
                property string value: items.toArabic ?
                romanConverter.roman :
                romanConverter.arabic ? romanConverter.arabic : ''
                verticalAlignment: Text.AlignVCenter
                width: textInput.width
                height: textInput.height
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: regularSize
            }
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: activityBackground.isHorizontal ? layoutArea.width * 0.5 :
                layoutArea.width * 0.7
            panelHeight: activityBackground.isHorizontal ? layoutArea.heightUnit * 5 : layoutArea.heightUnit * 4
            hideIfEmpty: true
            anchors.bottom: layoutArea.bottom
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.horizontalCenterOffset: activityBackground.isHorizontal ?
                inputArea.anchors.horizontalCenterOffset :
                0
            color: GCStyle.lightBg
            border.color: GCStyle.blueBorder
            border.width: GCStyle.thinBorder
            radius: 0
            textItem.color: GCStyle.darkText
            textItem.fontSize: textItem.smallSize
            textItem.text: items.instruction
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: inputArea
            radius: inputArea.radius
            imageSize: height * 2
            function releaseControls() { items.buttonsBlocked = false; }
        }

        Item {
            id: rightSideItems
            anchors.left: inputArea.right
            anchors.right: layoutArea.right
            anchors.top: inputArea.top
            anchors.bottom: feedbackArea.bottom
        }

        Score {
            id: score
            anchors.right: rightSideItems.horizontalCenter
            anchors.rightMargin: GCStyle.halfMargins
            anchors.verticalCenter: rightSideItems.verticalCenter
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 1
            onStop: items.nextSubLevel()
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: visible && !items.buttonsBlocked

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

            onKeypress: (text) => textInput.appendText(text)

            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: items.previousLevel()
            onNextLevelClicked: items.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: feedbackArea.visible = !feedbackArea.visible
        }
        BarButton {
          id: okButton
          source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
          visible: true
          anchors.left: rightSideItems.horizontalCenter
          anchors.leftMargin: GCStyle.halfMargins
          anchors.verticalCenter: rightSideItems.verticalCenter
          enabled: !items.buttonsBlocked
          width: Math.min(GCStyle.bigButtonHeight, layoutArea.heightUnit * 3)
          onClicked: items.check()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(items.nextLevel)
        }
    }
}
