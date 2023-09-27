/* GCompris - missing-letter.qml
 *
 * Copyright (C) 2014 "Amit Tomar" <a.tomar@outlook.com>
 *
 * Authors:
 *   "Pascal Georges" <pascal.georgis1.free.fr> (GTK+ version)
 *   "Amit Tomar" <a.tomar@outlook.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "missing-letter.js" as Activity

ActivityBase {
    id: activity

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
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        // system locale by default
        property string locale: "system"

        property bool englishFallback: false
        property bool downloadWordsNeeded: false

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias questionImage: questionImage
            property alias questionText: questionText
            property alias questionAnim: questionAnim
            property alias answers: answers
            property GCAudio audioVoices: activity.audioVoices
            property alias englishFallbackDialog: englishFallbackDialog
            property alias parser: parser
            property alias locale: background.locale
            property string answer
            property alias textinput: textinput
            property bool isGoodAnswer: false
            property bool buttonsBlocked: false
        }

        onStart: {
            Activity.init(items)
            Activity.focusTextInput()
            Activity.start()
        }
        onStop: {
            Activity.stop()
        }

        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            anchors.centerIn: background
            enabled: !ApplicationInfo.isMobile
            focus: true
            visible: false

            onTextChanged: {
                if (text != '') {
                    var typedText = text
                    var answerText = Activity.getCurrentQuestion().answer
                    if(ApplicationSettings.fontCapitalization === Font.AllUppercase)
                        typedText = text.toLocaleUpperCase()
                    else if(ApplicationSettings.fontCapitalization === Font.AllLowercase)
                        typedText = text.toLocaleLowerCase()

                    if(!items.isGoodAnswer && (typedText === answerText)) {
                        questionAnim.start()
                        Activity.showAnswer()
                    }
                    text = '';
                }
            }

            Keys.onTabPressed: bar.repeatClicked();
        }

        Item {
            id: layoutArea
            anchors.top: score.bottom
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.4
            anchors.left: background.left
            anchors.right: background.right
            anchors.margins: 10 * ApplicationInfo.ratio
        }

        Item {
            id: questionArea
            width: Math.min(layoutArea.width, layoutArea.height)
            height: width
            anchors.centerIn: layoutArea
        }

        // Buttons with possible answers shown on the left of screen
        Column {
            id: buttonHolder
            spacing: 10 * ApplicationInfo.ratio
            anchors.left: questionArea.left
            anchors.top: questionArea.top

            add: Transition {
                NumberAnimation { properties: "y"; from: holder.y; duration: 500 }
            }

            Repeater {
                id: answers

                AnswerButton {
                    width: questionArea.width - holder.width - 10 * ApplicationInfo.ratio
                    height: (holder.height
                             - buttonHolder.spacing * answers.model.length) / answers.model.length
                    textLabel: modelData
                    blockAllButtonClicks: items.buttonsBlocked
                    isCorrectAnswer: modelData === items.answer
                    onCorrectlyPressed: questionAnim.restart()
                    onPressed: {
                        items.buttonsBlocked = true
                        if(!items.isGoodAnswer) {
                            modelData == items.answer ? Activity.showAnswer() : ''
                        }
                    }
                    onIncorrectlyPressed: items.buttonsBlocked = false
                }
            }
        }

        // Picture holder for different images being shown
        Rectangle {
            id: holder
            width: questionArea.width * 0.7
            height: questionArea.height
            anchors.top: questionArea.top
            anchors.right: questionArea.right
            color: "white"
            radius: 10
            border.width: 2
            border.color: "#373737"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#80FFFFFF" }
                GradientStop { position: 0.9; color: "#80EEEEEE" }
                GradientStop { position: 1.0; color: "#80AAAAAA" }
            }

            Image {
                id: questionImage
                anchors.horizontalCenter: holder.horizontalCenter
                anchors.top: holder.top
                width: holder.width
                height: width
                fillMode: Image.PreserveAspectFit
            }

            Rectangle {
                id: questionTextBg
                width: holder.width
                height: holder.height - questionImage.height
                anchors.horizontalCenter: holder.horizontalCenter
                anchors.top: questionImage.bottom
                radius: 10
                color: "#373737"

                GCText {
                    id: questionText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#f2f2f2"
                    anchors.centerIn: parent
                    width: parent.width * 0.9
                    height: parent.height * 0.9
                    font.pointSize: NaN  // need to clear font.pointSize explicitly
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 10
                    font.pixelSize: width * 0.2

                    SequentialAnimation {
                        id: questionAnim
                        NumberAnimation {
                            target: questionText
                            property: 'scale'
                            to: 1.05
                            duration: 500
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: questionText
                            property: 'scale'
                            to: 0.95
                            duration: 1000
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: questionText
                            property: 'scale'
                            to: 1.0
                            duration: 500
                            easing.type: Easing.OutQuad
                        }
                        ScriptAction {
                            script: Activity.nextSubLevel()
                        }
                    }
                }
            }
        }

        Score {
            id: score
            anchors.bottom: undefined
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.top: parent.top
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    background.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    background.locale = Core.resolveLocale(background.locale);
                }
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

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | repeat | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onRepeatClicked: {
                if(!audioVoices.isPlaying() && !items.buttonsBlocked) {
                    Activity.playCurrentWord()
                }
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            onStart: items.buttonsBlocked = true
            onStop: items.buttonsBlocked = false
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        JsonParser {
            id: parser
            onError: console.error("missing letter: Error parsing json: " + msg);
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("https://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: background.englishFallback = false
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }

    }
}
