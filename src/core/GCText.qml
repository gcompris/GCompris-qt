/* GCompris - GCText.qml
 *
 * Copyright (C) 2014 Johnny Jazeix
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
import QtQuick 2.0
import GCompris 1.0

// QTBUG-34418, singletons require explicit import to load qmldir file
// https://qt-project.org/wiki/QmlStyling#6b81104b320e452a59cc3bf6857115ab
import "."

Text {
    font.family: GCSingletonFontLoader.fontLoader.name
}
