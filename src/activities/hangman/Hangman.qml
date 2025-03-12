/* GCompris - hangman.qml
 *
 * SPDX-FileCopyrightText: 2015 Rajdeep Kaur <rajdeep51994@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rajdeep kaur<rajdeep51994@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQuick.Effects

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
            Activity.focusTextInput();
        }
    }

    pageComponent: Image {
        id: activityBackground
        source: activity.dataSetUrl + "background.svg"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height

        // system locale by default
        property string locale: "system"

        property bool englishFallback: false

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
            property alias activityBackground: activityBackground
            property Item ourActivity: activity
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias keyboard: keyboard
            property alias hidden: hiddenTextPanel.textItem
            property alias guessedText: guessedTextPanel.textItem
            property alias textinput: textinput
            property alias wordImage: wordImage
            property alias score: score
            property alias parser: parser
            property alias locale: activityBackground.locale
            property alias okButton: okButton
            property int remainingLife
            property alias maskEffect: maskEffect
            property var goodWord
            property int goodWordIndex
            property bool easyModeImage: true
            property bool easyModeAudio: true
            property alias englishFallbackDialog: englishFallbackDialog
            property alias winTimer: winTimer
            property alias goodIcon: goodIcon

            function playWord() {
                var locale = ApplicationInfo.getVoicesLocale(items.locale)
                if(activity.audioVoices.append(
                            ApplicationInfo.getAudioFilePathForLocale(goodWord.voice, locale)))
                    bonus.interval = 2500
                else
                    bonus.interval = 500
            }
            onRemainingLifeChanged: {
                maskEffect.maskThresholdMin = 0.15 * remainingLife
                if(easyModeAudio && (remainingLife == 3)) {
                    playWord();
                }
            }
        }

        onStart: {
            focus = true;
            Activity.start(items);
            if(!activityBackground.englishFallback)
                Activity.focusTextInput();
        }

        onStop: {
            Activity.stop();
        }

        Image {
            id: goodIcon
            source: "qrc:/gcompris/src/core/resource/apply.svg"
            width: GCStyle.bigButtonHeight
            height: width
            sourceSize.width: width
            anchors {
                top: score.bottom
                right: score.right
                topMargin: GCStyle.baseMargins
            }
            visible: false
        }

        GCTextPanel {
            id: hiddenTextPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.5
            color: "#80ffffff"
            textItem.color: GCStyle.darkText
            textItem.fontSize: textItem.largeSize
            textItem.minimumPointSize: 7
        }

        GCTextPanel {
            id: guessedTextPanel
            panelWidth: parent.width - Math.max(score.width, clock.width) * 2 - 4 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, score.height)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            border.width: 0
            textItem.fontSize: textItem.smallSize
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
            onAccepted: if(okButton.visible) okButton.clicked()
        }

        Item {
            id: imageLayoutArea
            anchors.top: score.bottom
            anchors.bottom: hiddenTextPanel.top
            anchors.left: clock.right
            anchors.right: goodIcon.left
            anchors.margins: GCStyle.baseMargins
        }

        Item {
            id: imageframe
            width: Math.min(300 * ApplicationInfo.ratio,
                            imageLayoutArea.width,
                            imageLayoutArea.height)
            height: width
            anchors.centerIn: imageLayoutArea
            visible: items.easyModeImage ? true : false
            Image {
                id: wordImage
                smooth: true
                visible: false
                anchors.fill: parent
                function changeSource(nextSource_: string) {
                    maskEffect.maskThresholdMin = 1
                    source = nextSource_
                }
            }

            Image {
                id: threshmask
                visible: false
                anchors.fill: parent
                source: dataSetUrl + "fog.png"
            }

            MultiEffect {
                id: maskEffect
                anchors.fill: parent
                source: wordImage
                maskEnabled: true
                maskSource: threshmask
                maskSpreadAtMin: 0.5
                // remainingLife between 0 and 6 => threshold between 0 and 0.9
                maskThresholdMin: 1
            }
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
                    activityBackground.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    activityBackground.locale = Core.resolveLocale(activityBackground.locale);
                }
                if(activityData) {
                    if(activityData["easyModeImage"])
                        items.easyModeImage = (activityData["easyModeImage"] === "true");
                    else if(activityData["easyMode"])
                        items.easyModeImage = (activityData["easyMode"] === "true");
                }
                if(activityData && activityData["easyModeAudio"]) {
                    items.easyModeAudio = (activityData["easyModeAudio"] === "true");
                }

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

        Bar {
            id: bar
            level: items.currentLevel + 1
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Score {
            id: score
            isScoreCounter: false
            anchors {
                top: parent.top
                bottom: undefined
                right: parent.right
                margins: GCStyle.baseMargins
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            visible: false
            anchors.fill: goodIcon
            onClicked: Activity.nextSubLevel()
        }

        JsonParser {
            id: parser
            onError: (msg) => console.error("Hangman: Error parsing json: " + msg);
        }

        Image {
            id: clock
            anchors {
                left: parent.left
                top: parent.top
                margins: GCStyle.baseMargins
            }
            sourceSize.width: GCStyle.bigButtonHeight
            property int remainingLife: items.remainingLife
            onRemainingLifeChanged: {
                if(remainingLife >= 0) {
                    petalCount = "qrc:/gcompris/src/activities/reversecount/resource/" +
                           "flower" + remainingLife + ".svg"
                    clockAnim.restart()
                }
            }

            property string petalCount

            SequentialAnimation {
                id: clockAnim
                alwaysRunToEnd: true
                ParallelAnimation {
                    NumberAnimation {
                        target: clock; properties: "opacity";
                        to: 0; duration: 800; easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: clock; properties: "rotation"; from: 0; to: 180;
                        duration: 800; easing.type: Easing.OutCubic
                    }
                }
                PropertyAction {
                    target: clock; property: 'source';
                    value: clock.petalCount
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: clock; properties: "opacity";
                        to: 1; duration: 800; easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: clock; properties: "rotation"; from: 180; to: 0;
                        duration: 800; easing.type: Easing.OutCubic
                    }
                }
            }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            onKeypress: {
                Activity.processKeyPress(text);
                // Set the focus back to the InputText for keyboard input
                Activity.focusTextInput();
            }
            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
        }

        Bonus {
            id: bonus
            interval: 2000
            onLoose: okButton.visible = true
            onWin: Activity.nextSubLevel()
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
                onClose: {
                    activityBackground.englishFallback = false;
                    Activity.focusTextInput;
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }

        Timer {
            id: winTimer
            interval: 2000
            onTriggered: bonus.good("lion")
        }
    }
}
