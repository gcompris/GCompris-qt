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
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
import "gletters.js" as Activity

ActivityBase {
    id: activity
    
    property bool uppercaseOnly: false;  // FIXME: this should go in activity settings

    onStart: focus = true
    onStop: {}
    
    Keys.onPressed: Activity.processKeyPress(event)
    
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/gletters/resource/scenery_background.png"
        signal start
        signal stop
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias wordDropTimer: wordDropTimer
            property alias flipAudio: flipAudio
            property alias crashAudio: crashAudio
        }

        onStart: { Activity.start(items, uppercaseOnly) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
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
            
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
        }
        
        Wordlist {
            id: wordlist
            defaultFilename: ":/gcompris/src/activities/gletters/resource/default-en.json"
            filename: ApplicationInfo.getAudioFilePath("gletters/default-de.json");  // FIXME: this should be something like ApplicationInfo.getDataPath() + "gletters/" + "default-" + ApplicationInfo.getCurrentLocale() + ".json" once it is there.

            onError: console.log("Gletters: Wordlist error: " + msg);
        }
        
        Timer {
            id: wordDropTimer
            repeat: false        
            onTriggered: Activity.dropWord();
        }

        Audio {
            id: flipAudio
            source: "qrc:/gcompris/src/core/resource/sounds/flip.wav";
            
            onErrorChanged: console.log("Gletters: flipAudio error: " +
                    error + ": " + errorString + " (source: " + source + ")")
        }

        Audio {
            id: crashAudio
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav";
            
            onErrorChanged: console.log("Gletters: crashAudio error: " +
                    error + ": " + errorString + " (source: " + source + ")")
        }
    }

}
