/* GCompris - ClickOnLetter.qml
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
import QtGraphicalEffects 1.0
import GCompris 1.0
import "../../core"
import "click_on_letter.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true
    
    /* mode of the activity, either "lowercase" (click_on_letter)
     * or "uppercase" (click_on_letter_up): */
    property string mode: "lowercase"
    
    pageComponent: Image {
        id: background
        source: Activity.url + "background.svgz"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
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
            property GCAudio audioVoices: activity.audioVoices
            property alias parser: parser
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
            content: BarEnumContent { value: help | home | repeat | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onRepeatClicked: if (ApplicationSettings.isAudioVoicesEnabled)
                                Activity.playLetter(Activity.currentLetter);
        }

        Score {
            id: score
            
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.right: undefined
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
        
        Image {
            id: railway
            source: Activity.url + "railway.svgz"
            fillMode: Image.PreserveAspectCrop
            anchors.bottom: parent.bottom
            anchors.left: bar.right
            anchors.right: parent.right
            height: 15 * ApplicationInfo.ratio
            sourceSize.width: parent.width
            anchors.bottomMargin: 13 * ApplicationInfo.ratio
        }

        Item {
            id: questionItem
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.topMargin: parent.height * 0.25
            z: 10
            width: questionText.width * 2
            height: questionText.height * 1.3
            visible: false
            
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

            GCText {
                id: questionText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 1.0
                z:11            
                text: ""
                font.pointSize: 44
                font.bold: true
                style: Text.Outline
                styleColor: "black"
                color: "white"
            }

            DropShadow {
                anchors.fill: questionText
                cached: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: "#80000000"
                source: questionText
            }

        }
        
        ListModel {
            id: trainModel     
        }
        
        property int itemWidth: Math.min(parent.width / 7.5, parent.height / 5)
        property int itemHeight: itemWidth * 1.11

        Image {
            id: engine
            source: Activity.url + "engine.svgz"

            anchors.bottom: railway.bottom
            anchors.left: railway.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            sourceSize.width: itemWidth
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: smoke
            source: Activity.url + "smoke.svgz"

            anchors.bottom: engine.top
            anchors.left: railway.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            sourceSize.width: itemWidth
            fillMode: Image.PreserveAspectFit
        }

        GridView {
            id: train
            anchors.bottom: railway.bottom
            anchors.left: engine.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            cellWidth: itemWidth
            cellHeight: itemHeight
            clip: false
            interactive: false
            verticalLayoutDirection: GridView.BottomToTop
            layoutDirection: Qt.LeftToRight
            
            model: trainModel
            delegate: Carriage {
                sourceSize.width: background.itemWidth
                width: background.itemWidth
                nbCarriage: (parent.width - engine.width) / background.itemWidth
            }
        }
        
        JsonParser {
            id: parser

            onError: console.error("Click_on_letter: Error parsing JSON: " + msg);
        }

    }
}
