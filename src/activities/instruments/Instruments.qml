/* GCompris - Instruments.qml
 *
 * Original activity in the Gtk+ version of GCompris by
 * Sylvain Dechy <syl.1@free.fr>
 *
 * Copyright (C) 2014 Bruno Coudoin
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

import "../colors"
import "instruments.js" as Dataset

FindIt {
    mode: "Instruments"
    dataset: Dataset
    backgroundImg: "qrc:/gcompris/src/activities/instruments/resource/background.svgz"
    itemWidth: 130 * ApplicationInfo.ratio
    itemHeight: 130 * ApplicationInfo.ratio
}
