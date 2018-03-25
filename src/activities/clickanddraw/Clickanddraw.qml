/* GCompris - Clickanddraw.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Olivier Ponchaut <opvg@mailoo.org> (GTK+ version)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import "../number_sequence"
import "../../core" as Core
import "clickanddraw_dataset.js" as Dataset

NumberSequence {
    mode: "clickanddraw"
    pointImageOpacity: 0
    dataset: Dataset
    url: "qrc:/gcompris/src/activities/number_sequence/resource/"
}
