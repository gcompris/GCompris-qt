/* GCompris - AdvancedColors.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges <pascal.georges1@free.fr>
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

import "../colors"
import "advanced_colors.js" as Dataset

FindIt {
    mode: "AdvancedColors"
    dataset: Dataset
    backgroundImg: "qrc:/gcompris/src/activities/menu/resource/background.svg"
}
