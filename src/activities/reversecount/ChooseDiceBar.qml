/* GCompris - ChooseDiceBar.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "reversecount.js" as Activity


Item {
    id: chooseDiceBar
    z: 1000

    property alias value1: domino.value1
    property alias value2: domino.value2
    property alias valueMax: domino.valueMax
    property alias mode: domino.mode
    property GCSfx audioEffects

    Row {
        id: barRow
        spacing: 8
        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            sourceSize.width: 75 * ApplicationInfo.ratio
            visible: true
            anchors {
                right: undefined
                rightMargin: undefined
                top: undefined
                topMargin: undefined
            }

            onClicked: Activity.moveTux()
        }

        Domino {
            id: domino
            height: ok.height
            width: height * 2
            isClickable: true
            audioEffects: activity.audioEffects
        }
    }
}

