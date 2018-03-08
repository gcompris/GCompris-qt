/* GCompris - drawnumbers.qml
 *
 * Copyright (C) 2016 NITISH CHAUHAN <nitish.nc18@gmail.com>
 *
 * Authors:
 *
 *   Nitish Chauhan <nitish.nc18@gmail.com> (Qt Quick port)
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
import "drawnumbers_dataset.js" as Dataset

NumberSequence {
    mode: "drawnumbers"
    dataset: Dataset
    pointImageOpacity: 0
    url: "qrc:/gcompris/src/activities/drawnumbers/resource/"
}

