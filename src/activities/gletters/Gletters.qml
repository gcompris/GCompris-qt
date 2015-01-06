/* GCompris - gletters.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "gletters.js" as Activity

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/gletters/resource/"
    
    property bool uppercaseOnly: false;  // FIXME: this should go in activity settings
    /* mode of the activity, "letter" (gletters) or "word" (wordsgame):*/
    property string mode: "letter"

    // Override if you want to replace texts by your image
    function getImage(key) {
        return ""
    }

    // Override if you want to replace texts by the domino
    function getDominoValues(key) {
        return []
    }

    onStart: focus = true
    onStop: {}
    
    Keys.onPressed: Activity.processKeyPress(event.text)
    
    pageComponent: Image {
        id: background
        source: activity.dataSetUrl + "background.svgz"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

        signal start
        signal stop
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property Item ourActivity: activity
            property GCAudio audioVoices: activity.audioVoices
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias keyboard: keyboard
            property alias wordDropTimer: wordDropTimer
            property GCAudio audioEffects: activity.audioEffects
        }

        onStart: { Activity.start(items, uppercaseOnly, mode) }
        onStop: { Activity.stop() }

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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        
        Score {
            id: score

            anchors.top: undefined
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: keyboard.top
        }
        
        VirtualKeyboard {
            id: keyboard
            
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            keyHeight: 35 * ApplicationInfo.ratio
            equalKeyWidth: true
            
            onKeypress: Activity.processKeyPress(text)
            
            onError: console.log("VirtualKeyboard error: " + msg);
        }
        
        Wordlist {
            id: wordlist
            defaultFilename: activity.dataSetUrl + "default-en.json"
            filename: ApplicationInfo.getLocaleFilePath(activity.dataSetUrl +
                                                       "default-$LOCALE.json");

            onError: console.log("Gletters: Wordlist error: " + msg);
        }
        
        Timer {
            id: wordDropTimer
            repeat: false        
            onTriggered: Activity.dropWord();
        }

    }

}
