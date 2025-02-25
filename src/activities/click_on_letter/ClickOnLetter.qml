/* GCompris - ClickOnLetter.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0
import "../../core"
import "click_on_letter.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    /* mode of the activity, either "lowercase" (click_on_letter)
     * or "uppercase" (click_on_letter_up): */
    property string mode: "lowercase"

    onStart: focus = true

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the eventHandler item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusEventHandler()
        }
    }

    pageComponent: Image {
        id: activityBackground
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        verticalAlignment: Image.AlignBottom
        focus: true

        // system locale by default
        property string locale: "system"

        signal start
        signal stop
        signal voiceDone

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Timer {
            id: voiceTimer
            interval: 200
            repeat: true
            onTriggered: {
                if(DownloadManager.areVoicesRegistered(activityBackground.locale)) {
                    voiceTimer.stop();
                    Activity.appendVoices();
                }
            }
        }

        QtObject {
            id: items
            property Item activityPage: activity
            property int currentLevel: activity.currentLevel
            property alias trainModel: trainModel
            property GCAudio audioVoices: activity.audioVoices
            property alias winSound: winSound
            property alias parser: parser
            property alias questionItem: questionItem
            property alias repeatItem: repeatItem
            property alias score: score
            property alias bonus: bonus
            property alias locale: activityBackground.locale
            property bool keyNavigationMode: false
            property int lastSelectedIndex: -1
            property alias eventHandler: eventHandler
            property alias errorRectangle: errorRectangle
            property bool buttonsBlocked: false
            property alias voiceTimer: voiceTimer
        }

        onStart: {
            activity.audioVoices.done.connect(voiceDone);
            Activity.start(items, mode);
            eventHandler.forceActiveFocus();
        }

        onStop: {
            voiceTimer.stop();
            Activity.stop();
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        GCSoundEffect {
            id: crashSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        Item {
            id: eventHandler
            focus: true
            Keys.enabled: !items.buttonsBlocked && !dialogActivityConfig.visible
            Keys.onPressed: (event) => {
                if(event.key === Qt.Key_Tab) {
                    activity.audioVoices.clearQueue();
                    activity.audioVoices.stop();
                    Activity.playLetter(Activity.currentLetter);
                } else {
                    activityBackground.handleKeys(event);
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
                eventHandler.forceActiveFocus();
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels;
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels;
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels);
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    activityBackground.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    activityBackground.locale = Core.resolveLocale(activityBackground.locale);
                }
            }
            onStartActivity: {
                activityBackground.stop();
                activityBackground.start();
                eventHandler.forceActiveFocus();
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: GCStyle.baseMargins
            anchors.bottom: undefined
            anchors.right: undefined
            onStop: Activity.nextSubLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            width: GCStyle.bigButtonHeight
            anchors {
                top: parent.top
                right: parent.right
                margins: GCStyle.baseMargins
            }
            onClicked: {
                if(!activity.audioVoices.isPlaying()) {
                    Activity.playLetter(Activity.currentLetter);
                }
            }
        }

        Image {
            id: railway
            source: Activity.url + "railway.svg"
            fillMode: Image.PreserveAspectCrop
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            sourceSize.width: width
            sourceSize.height: height
            anchors.bottomMargin: bar.height * 1.5
        }

        Rectangle {
            id: questionItem
            anchors.fill: repeatItem
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.thinBorder
            color: "#2881C3"
            radius: GCStyle.halfMargins
            visible: false

            property alias text: questionText.text

            GCText {
                id: questionText
                anchors.centerIn: parent
                width: questionItem.width - GCStyle.baseMargins
                height: questionItem.height - GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: ""
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: width > 0 ? width : 1
                font.bold: true
                color: GCStyle.whiteText
            }
        }

        ListModel {
            id: trainModel
        }

        //always calculate layout for a maximum of 24 letters per level
        //adding 1 extra to px and py to include one more item (the engine) in the calculation
        property int itemWidth: Core.fitItems(wholeTrainArea.width, wholeTrainArea.height, 24, 1)

        Image {
            id: engine
            source: Activity.url + "engine.svg"
            anchors.bottom: wholeTrainArea.bottom
            anchors.left: wholeTrainArea.left
            sourceSize.width: itemWidth
            sourceSize.height: itemWidth
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: smoke
            source: Activity.url + "smoke.svg"
            anchors.bottom: engine.top
            anchors.left: engine.left
            anchors.bottomMargin: GCStyle.halfMargins
            sourceSize.width: engine.width
            fillMode: Image.PreserveAspectFit
        }

        Item {
            id: wholeTrainArea
            anchors.bottom: railway.bottom
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.top: repeatItem.bottom
            anchors.leftMargin: GCStyle.baseMargins
            anchors.rightMargin: GCStyle.baseMargins
            anchors.bottomMargin: GCStyle.halfMargins
        }

        GridView {
            id: train
            anchors.bottom: engine.bottom
            anchors.top: wholeTrainArea.top
            anchors.right: wholeTrainArea.right
            anchors.left: engine.right
            cellWidth: itemWidth
            cellHeight: itemWidth
            clip: false
            interactive: false
            verticalLayoutDirection: GridView.BottomToTop
            layoutDirection: Qt.LeftToRight
            keyNavigationWraps: true
            currentIndex: -1

            model: trainModel
            delegate: Carriage {
                width: train.cellWidth
                height: train.cellHeight
                nbCarriage: train.width / train.cellWidth - 1
                clickEnabled: items.buttonsBlocked ? false : (activity.audioVoices.playbackState == 1 ? false : true)
                isSelected: train.currentIndex === index
            }
        }

        ErrorRectangle {
            id: errorRectangle
            z: 20
            anchors.centerIn: parent
            width: 2
            height: 2
            imageSize: train.cellWidth * 0.75
            function releaseControls() {
                items.buttonsBlocked = false;
            }
        }

        function moveErrorRectangle(clickedItem) {
            errorRectangle.parent = clickedItem
            if(clickedItem.isCarriage){
                errorRectangle.anchors.centerIn = clickedItem.carriageBg
            } else {
                errorRectangle.anchors.centerIn = errorRectangle.parent
            }
            errorRectangle.startAnimation()
            crashSound.play()
        }

        function handleKeys(event) {
            if(!items.keyNavigationMode) {
                smudgeSound.play();
                items.keyNavigationMode = true;
                if(items.lastSelectedIndex > 0 && items.lastSelectedIndex < trainModel.count)
                    train.currentIndex = items.lastSelectedIndex;
                else
                    train.currentIndex = 0;
            } else if(event.key === Qt.Key_Right) {
                smudgeSound.play();
                train.moveCurrentIndexRight();
            } else if(event.key === Qt.Key_Left) {
                smudgeSound.play();
                train.moveCurrentIndexLeft();
            } else if(event.key === Qt.Key_Up) {
                smudgeSound.play();
                train.moveCurrentIndexUp();
            } else if(event.key === Qt.Key_Down) {
                smudgeSound.play();
                train.moveCurrentIndexDown();
            } else if(event.key === Qt.Key_Space && activity.audioVoices.playbackState != 1) {
                items.buttonsBlocked = true;
                if(Activity.checkAnswer(train.currentIndex)) {
                    train.currentItem.successAnimation.restart();
                    train.currentItem.particle.burst(30);
                } else {
                    moveErrorRectangle(train.currentItem);
                }
            }
        }

        JsonParser {
            id: parser
            onError: (msg) => console.error("Click_on_letter: Error parsing JSON: " + msg);
        }

    }
}
