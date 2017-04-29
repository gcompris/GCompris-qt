/* GCompris - target.qml
 *
 * Copyright (C) 2014 Bruno coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
                    arrowRepeater.itemAt(items.currentArrow++).scale = 0.5
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

            if(targetItem.scoreTotal == userEntry.text)
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

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
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
