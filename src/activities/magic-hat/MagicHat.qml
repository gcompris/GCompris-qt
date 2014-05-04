/* GCompris - magic-hat.qml
 *
 * Copyright (C) 2014 <Thibaut ROMAIN>
 *
 * Authors:
 *   <Bruno Coudoin> (GTK+ version)
 *   Thibaut ROMAIN <Thibaut ROMAIN> (Qt Quick port)
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

import "qrc:/gcompris/src/core"
import "magic-hat.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "minus"

    pageComponent: Image{
        id: background
        anchors.fill: parent
        source: mode=="minus"? "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/magic_hat_minus_newbg.svg" : "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/magic_hat_plus_bg.png"
        fillMode: Image.PreserveAspectFit
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Column {
            id: mainlayout
            anchors.left: background.left
            width: background.width/2
            height:background.height
            Hat{
                    id: chapeau
            }
        }
        Grid {
            anchors.right: background.right
            anchors.rightMargin: -background.width/26
            anchors.verticalCenter: background.verticalCenter
            anchors.verticalCenterOffset: background.height/6.5
            width: background.width/2
            height:background.height
            id: rightLayout
            rows: 3
            spacing: background.height/5
            Column{
                id: firstRow
                spacing: 5
                StarsBar{
                    id: sb0
                    starsSize: background.height/18
                    starsColor: "yellow"
                }
                StarsBar{
                    id: sb1
                    starsSize: background.height/18
                    starsColor: "green"
                    opacity: 0
                }
            }
            Column{
                id: secondRow
                spacing: 5
                StarsBar{
                    id: sb2
                    starsSize: background.height/18
                    starsColor: "yellow"
                }
                StarsBar{
                    id: sb3
                    starsSize: background.height/18
                    opacity: 0
                    starsColor: "green"
                }
            }
            StarsBar{
                id: sbAnswer
                nbStarsOn: 0
                starsSize: background.height/18
                starsColor: "yellow"
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias hat: chapeau
            property var barsList : [sb0,sb1,sb2,sb3,sbAnswer]
            property int starsSize: background.height/18
            property alias columnY : secondRow.y
        }

        onStart: { Activity.start(items,mode) }
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
    }

}
