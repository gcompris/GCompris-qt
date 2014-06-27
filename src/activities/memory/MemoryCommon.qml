/* GCompris - MemoryCommon.qml
 *
 * Copyright (C) 2014 JB BUTET
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtMultimedia 5.0

import "../../core"
import "../memory"
import "memory.js" as Activity

ActivityBase {
    id: activity
    focus: true
    property real displayWidthRatio
    property real displayHeightRatio
    property int displayX
    property int displayY
    property int itemWidth
    property int itemHeight
    property int rowsNb
    property int paired
    property string backgroundImg
    property string type  //define if it's a "picture" ou a "sound" memory
    property var dataset
    property GCAudio sound1

    onStart: {}
    onStop: {}
    paired:0

    onPairedChanged: {
        if (paired == 3){ //when 2 pictures are clicked and we click a third one
          Activity.cardReturn()
        }

    }

    // For perf reason it is best not to put this in each HexagonItem
    GCAudio {
        id: sound1
        source: ""
    }

    pageComponent: Image {
        source: backgroundImg
        fillMode: Image.PreserveAspectCrop
        id: background
        signal start
        signal stop
        focus: true


        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: { Activity.start(main, type, background, bar, bonus,
                                  containerModel, cardRepeater, grid,
                                  dataset, displayWidthRatio, displayHeightRatio,
                                  displayX, displayY,sound1) }

        onStop: { Activity.stop() }

        ListModel {
            id: containerModel
        }

        Grid {
            id: grid
            x: displayX
            y: displayY
            spacing: 5
            Repeater {
                id: cardRepeater
                model: containerModel
                delegate: CardItem {
                       source: back  //first picture is the back
                       width: width_
                       height: height_
                       backPict: back
                       isBack: true
                       imagePath: image
                       matchCode: matchCode_
                       audioFile: audioFile_
                       textDisplayed : text_

               }
            }

        }



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
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
