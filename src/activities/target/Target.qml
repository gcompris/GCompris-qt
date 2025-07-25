/* GCompris - target.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"
import "target.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: activityBackground
        anchors.fill: parent

        signal start
        signal stop

        Keys.onPressed: (event) => {
            if(items.currentArrow != items.nbArrow)
                return

            if(bonus.isPlaying || items.inputLocked)
                return

            if(event.key === Qt.Key_Backspace) {
                backspace()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                Activity.checkAnswer();
                event.accepted = true
            }
            else if(appendText(event.text)) {
                event.accepted = true
            }
        }

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
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias targetModel: targetItem.model
            readonly property var levels: activity.datasets
            property alias targetItem: targetItem
            property alias userEntry: userEntry
            property int currentArrow
            property int nbArrow
            property int currentSubLevel
            property int numberOfSubLevel
            property bool arrowFlying
            property bool inputLocked: true

            onNbArrowChanged: {
                arrowRepeater.init(nbArrow)
                items.currentArrow = 0
            }
        }

        onStart: {
            keyboard.populate();
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        TargetItem {
            id: targetItem
            onTargetReached: {
                items.arrowFlying = false
                if(items.currentArrow == items.nbArrow) {
                    targetItem.stop()
                    targetItem.scoreText += " = "
                    userEntry.text = "?"
                    items.inputLocked = false
                }
            }
        }

        Arrow {
            id: arrowRepeater
            onReattachArrow: (arrow) => {
                targetItem.attachArrow(arrow)
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

        GCSoundEffect {
            id: arrowSound
            source: Activity.url + "arrow.wav"
        }

        Image {
            id: cross
            anchors.centerIn: parent
            source: Activity.url + "cross.svg"
            opacity: items.currentArrow != items.nbArrow ? 1 : 0
            sourceSize.width: 50 * ApplicationInfo.ratio
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: items.currentArrow != items.nbArrow && !items.arrowFlying && !items.inputLocked
            onClicked: {
                arrowSound.play()
                items.arrowFlying = true
                if(items.currentArrow != items.nbArrow) {
                    arrowRepeater.itemAt(items.currentArrow).opacity = 1
                    arrowRepeater.itemAt(items.currentArrow++).scale = 1
                }
            }
        }

        GCText {
            id: scoreItem
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            text: targetItem.scoreText
            fontSize: 22
            font.bold: true
            style: Text.Outline
            styleColor: "black"
            color: "white"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        function backspace() {
            userEntry.text = userEntry.text.slice(0, -1)
            if(userEntry.text.length === 0) {
                userEntry.text = "?"
            }
        }

        function appendText(text: string) : bool {
            if(items.inputLocked)
                return false

            if(text === keyboard.backspace) {
                backspace()
                return true
            }

            var number = parseInt(text)
            if(isNaN(number))
                return false

            if(userEntry.text === "?") {
                userEntry.text = ""
            }

            if(userEntry.text.length > ('' + targetItem.scoreTotal).length) {
                return false
            }

            userEntry.text += text
            return true
        }

        GCText {
            id: userEntry
            anchors.top: scoreItem.bottom
            width: parent.width
            fontSize: 22
            font.bold: true
            style: Text.Outline
            styleColor: "black"
            color: "white"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.5
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.baseMargins
            mouseArea.enabled: !items.inputLocked
            visible: items.currentArrow == items.nbArrow
            onClicked: {
                Activity.checkAnswer();
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: userEntry
            imageSize: height * 0.75
            function releaseControls() { items.inputLocked = false; }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            hide: items.currentArrow == items.nbArrow ? false : true
            enabled: visible && !items.inputLocked

            function populate() {
                layout = [
                [
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
            onKeypress: (text) => activityBackground.appendText(text)

            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                activity.levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: {
                activity.home()
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Score {
            id: score
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: items.numberOfSubLevel
            onStop: Activity.nextSubLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
