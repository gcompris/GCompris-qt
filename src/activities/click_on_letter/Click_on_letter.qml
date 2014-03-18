/* GCompris - Click_on_letter.qml
 *
 * Copyright (C) 2014 Holger Kaelberer 
 * 
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
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
import QtMultimedia 5.0
import GCompris 1.0
import "qrc:/gcompris/src/core"
import "click_on_letter.js" as Activity

ActivityBase {
    id: activity
    focus: true
    
    /* mode of the activity, either "lowercase" (click_on_letter)
     * or "uppercase" (click_on_letter_up): */
    property string mode: "lowercase"
    
    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/click_on_letter/resource/background.svgz"
        id: background
        signal start
        signal stop
        focus: true
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        
        QtObject {
            id: items
            property alias bar: bar
            property alias trainModel: trainModel
            property alias nextLevelAudio: nextLevelAudio
            property alias levelsFile: levelsFile
            property alias letterAudio: letterAudio 
            property alias questionItem: questionItem
            property alias score: score
            property alias bonus: bonus
        }
        
        onStart: Activity.start(items, mode); 
        
        onStop: Activity.stop()

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            
            // anchor in top right corner:
            anchors.bottom: undefined 
            anchors.top: parent.top
            x: parent.width - width
            anchors.topMargin: height + 10
            
            content: BarEnumContent { value: help | home | repeat | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onRepeatClicked: if (Activity.getSetting("fx"))
                                letterAudio.play();
        }

        Score {
            id: score
            
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
        
        Item {
            id: questionItem
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.topMargin: 160 * ApplicationInfo.ratio
            z: 10
            width: 80
            height: 80
            scale: 1 * ApplicationInfo.ratio
            visible: false;
            
            property alias text: questionText.text
            
            Rectangle {
                id: questionRect
                anchors.fill: parent
                
                border.color: "#FFFFFFFF"
                border.width: 2
                color: "#000065"
                opacity: 0.31
                radius: 10
            }
                        
            Text {
                id: questionText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 1.0
                z:11            
                text: ""
                font.pointSize: 44
                font.bold: true
                style: Text.Outline
                styleColor: "darkblue"
                color: "white"
            }
        }
        
        ListModel {
            id: trainModel
            
        }
        
        Image {
            id: engine
            source: "qrc:/gcompris/src/activities/click_on_letter/resource/engine.svgz"
            
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 13 * ApplicationInfo.ratio
            anchors.leftMargin: 10 * ApplicationInfo.ratio

            scale: 1 * ApplicationInfo.ratio      
        }

        GridView {
            id: train
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 13 * ApplicationInfo.ratio
            anchors.leftMargin: (10 + engine.width) * ApplicationInfo.ratio
            width: (820 - 144) * ApplicationInfo.ratio
            height: parent.height - anchors.bottomMargin
            cellWidth: 112 * ApplicationInfo.ratio
            cellHeight: 126 * ApplicationInfo.ratio

            flickableDirection: Flickable.HorizontalFlick
            interactive: ApplicationInfo.isMobile ? true : false   // FIXME allow scrolling the train horizontally on mobile: need to implement a kind of returnToBounds()
            clip: ApplicationInfo.isMobile ? true : false // flick only the carriages
            verticalLayoutDirection: GridView.BottomToTop
            layoutDirection: Qt.LeftToRight
            
            model: trainModel
            delegate: Carriage { }
        }
        
        File {
            id: levelsFile
            name: ""
                
            onError: console.log("Click_on_letter: levelsFile error: " + msg);
        }

        Audio {
            id: nextLevelAudio
            source: ApplicationInfo.getAudioFilePath("voices/$LOCALE/misc/click_on_letter.ogg")
            
            onErrorChanged: console.log("Click_on_letter: nextLevelAudio error: " +
                    error + ": " + errorString + " (source: " + source + ")")
        }

        Audio {
            id: letterAudio
            source: ""
            
            onErrorChanged: console.log("Click_on_letter: letterAudio error: "
                    + error + ": " + errorString + " (source: " + source + ")")
            
            function playDelayed(ms) {
                if (letterAudioTimer.running)
                    letterAudioTimer.stop();
                letterAudioTimer.interval = ms;
                letterAudioTimer.start();
            }
        }
        
        Timer {
            id: letterAudioTimer
            repeat: false        
            onTriggered: letterAudio.play();
        }
    }
}
