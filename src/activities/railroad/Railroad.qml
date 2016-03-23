/* GCompris - railroad.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
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

import "../../core"
import "railroad.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        source: Activity.url + "railroad-bg.svg"
        sourceSize.width: parent.width

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
            property alias locAndWagonsRepeater: locAndWagonsRepeater
        }

        Flickable {
            id: engines
            clip: false
            width: background.width ; height: 800
            y: background.width/9.2
            contentWidth: background.width; contentHeight: 1180
            // anchors.fill: parent
            Flow {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 10

                // === Place locs and wagons ===
                Repeater {
                    id: locAndWagonsRepeater
                    model: Activity.trainParts
                    Item {
                        id: rail
                        parent: locAndWagonsRepeater.itemAt(0)
                        width: locAndWagons.width
                        height: locAndWagons.height
                        property bool mouseEnabled : true
                        property alias railMouseArea: railMouseArea
                        property int position

                        Image {
                            id : locAndWagons
                            source: Activity.url + modelData[0]

                        }
                        MouseArea{
                            id : railMouseArea
                            anchors.fill: parent
                            enabled: rail.mouseEnabled
                            onClicked:{
                                Qt.quit()
                            }
                        }
                    }
                }
            }
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        TrainPart {
            id: trainpart
            sourceSize.width: Math.min(activity.width / 6, activity.height / 6)
            z: 11
        }



        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
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
