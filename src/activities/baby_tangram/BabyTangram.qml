/* GCompris - BabyTangram.qml
 *
 * Copyright (C) 2019 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Yves Combe /  Philippe Banwarth (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> / Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

import "dataset.js" as Dataset
import "../tangram"
import "."

Tangram {
    id: activity
    dataset: Dataset
    resourceUrl: "qrc:/gcompris/src/activities/baby_tangram/resource/"
}
