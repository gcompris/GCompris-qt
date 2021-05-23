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
import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "target.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop
        signal targetReached

        Keys.onPressed: {
            if(items.currentArrow != items.nbArrow)
                return

            if(event.key === Qt.Key_Backspace) {
                backspace()
            }
            appendText(event.text)
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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias targetModel: targetItem.model
            property var levels: activity.datasetLoader.data
            property alias targetItem: targetItem
            property alias userEntry: userEntry
            property int currentArrow
            property int nbArrow
            property int currentSubLevel
            property int numberOfSubLevel
            property bool arrowFlying

            onNbArrowChanged: {
                arrowRepeater.init(nbArrow)
            }
        }

        onStart: {
            keyboard.populate();
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        TargetItem {
            id: targetItem
        }

        onTargetReached: {
            items.arrowFlying = false
            if(items.currentArrow == items.nbArrow) {
                targetItem.stop()
                targetItem.scoreText += " = "
                userEntry.text = "?"
            }
        }

        Arrow {
            id: arrowRepeater
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
            enabled: items.currentArrow != items.nbArrow && !items.arrowFlying
            onClicked: {
                activity.audioEffects.play(Activity.url + 'arrow.wav')
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
            } else {
                if(targetItem.scoreTotal == userEntry.text)
                    bonus.good("flower")
            }
        }

        function appendText(text) {
            if(text === keyboard.backspace) {
                backspace()
                return
            }

            var number = parseInt(text)
            if(isNaN(number))
                return

            if(userEntry.text === "?") {
                userEntry.text = ""
            }

            if(userEntry.text.length > ('' + targetItem.scoreTotal).length) {
                return
            }

            userEntry.text += text

            if(targetItem.scoreTotal.toString() === userEntry.text)
                bonus.good("flower")
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

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            hide: items.currentArrow == items.nbArrow ? false : true

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
            onKeypress: background.appendText(text)

            onError: console.log("VirtualKeyboard error: " + msg);
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

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
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
            currentSubLevel: items.currentSubLevel + 1
            numberOfSubLevels: items.numberOfSubLevel
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
