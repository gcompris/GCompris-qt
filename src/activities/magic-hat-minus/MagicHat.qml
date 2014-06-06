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
        source: mode == "minus" ?
                    Activity.url + "magic_hat_minus_newbg.svgz" :
                    Activity.url + "magic_hat_plus_newbg.svgz"
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property var starColors : ["yellow","green","blue"]

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
                    id: theHat
            }
        }
        Grid {
            anchors.right: background.right
            anchors.rightMargin: -background.width/26
            anchors.verticalCenter: background.verticalCenter
            anchors.verticalCenterOffset: background.height/8
            width: background.width/2
            height:background.height
            id: rightLayout
            rows: 3
            spacing: background.height/10
            Column{
                id: firstRow
                spacing: 5
                Repeater{
                    id: repeaterFirstRow
                    model: 3
                    StarsBar{
                        starsSize: background.height/18
                        starsColor: starColors[index]
                        opacity: index==0 ? 1.0 : 0.0
                    }
                }
            }
            Column{
                id: secondRow
                spacing: 5
                Repeater{
                    id: repeaterSecondRow
                    model: 3
                    StarsBar{
                        starsSize: background.height/18
                        starsColor: starColors[index]
                        opacity: index==0 ? 1.0 : 0.0
                    }
                }
            }
            Column{
                id: answerRow
                spacing: 5
                Repeater{
                    id: repeaterAnswerRow
                    model: 3
                    StarsBar{
                        starsSize: background.height/18
                        starsColor: starColors[index]
                        opacity: index==0 ? 1.0 : 0.0
                        authorizeClick: false
                    }
                }
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias hat: theHat
            property var repeatersList : [repeaterFirstRow,repeaterSecondRow,repeaterAnswerRow]
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
