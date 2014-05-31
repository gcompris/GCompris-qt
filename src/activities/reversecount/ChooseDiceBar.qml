/* GCompris - ChooseDiceBar.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
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
import QtQuick 2.2
import GCompris 1.0
import "../../core"
import "reversecount.js" as Activity


Item {
    id: chooseDiceBar
    width: barRow.width
    height: barRow.height - 30
    z: 1000

    property int value1: 0
    property int value2: 0

    property real barZoom: 1.2 * ApplicationInfo.ratio

    Row {
        id: barRow
        spacing: 8
        Item { width: 10; height: 1 }

        Button {
            source: "qrc:/gcompris/src/core/resource/bar_ok.svgz";
            sourceSize.width: activity.width / 10
            onClicked: Activity.moveTux()
        }
        Button {
            id: dice1
            source: Activity.url + "dice" + value1 + ".svgz"
            sourceSize.width: activity.width / 10
            onClicked: {
                if (value1 >= 8)
                    value1 = 0
                else
                    value1++
            }
            onRightClicked: {
                if (value1 == 0)
                    value1 = 8;
                else
                    value1--;
            }
       }
        Button {
            id: dice2
            source: Activity.url + "dice" + value2 + ".svgz"
            sourceSize.width: activity.width / 10
            onClicked: {
                if (value2 >= 8)
                    value2 = 0;
                else
                    value2++
            }
            onRightClicked: {
                if (value2 == 0)
                    value2 = 8;
                else
                    value2--;
            }
       }

        Item { width: 10; height: 1 }
    }

    Behavior on opacity { PropertyAnimation { duration: 500 } }

}

