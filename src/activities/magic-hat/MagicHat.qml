/* GCompris - magic-hat.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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

    property string mode: "plus"

    pageComponent: Image{
        id: background
        anchors.fill: parent
        source: mode=="plus"? "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/magic_hat_plus_bg.png" : "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic-hat/magic_hat_minus_bg.png"
        fillMode: Image.PreserveAspectFit
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Grid {
            id: mainlayout
            anchors.fill: background
            Column {
                width: background.width/2
                height: background.height
                id: leftLayout
            }
            Column {
                width: background.width/2
                height:background.height
                id: rightLayout
                spacing: 100
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
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
