/* GCompris - Reversecount.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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

import "../../../../core"

ActivityBase {
    id: activity

    activityInfo: QtObject {
        property bool demo: false
    }

    property QtObject user
    property string act

    property var model: user && user.activityData[act] ? user.activityData[act].data : undefined

    pageComponent: Item {
        anchors.fill: parent
        Grid {
            id: results
            spacing: 10
            columns: 1
            Repeater {
                model: activity.model

                Rectangle {
                    id: line
                    property int mIndex: modelData.data["index"]
                    property int mCurrentPosition: modelData.data["currentPosition"]
                    property int mDice1: modelData.data["dice1"]
                    property int mDice2: modelData.data["dice2"]

                    width: activity.width
                    height: 100
                    color: "yellow"
                    Rectangle {
                        id: goodValue
                        color: (mIndex === mCurrentPosition + mDice1 + mDice2) ? "green" : "red"
                        radius: width
                        width: line.height * 0.8
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    GCText {
                        text: modelData.date
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: goodValue.right
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: home }
            onHomeClicked: activity.home()
        }
    }
}
