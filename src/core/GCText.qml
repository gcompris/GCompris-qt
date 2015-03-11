/* GCompris - GCText.qml
 *
 * Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>
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
    // Some constants for often used fontSizes
    // Note: these should be Enums actually, which by now can't be defined in
    // QML (cf. QTBUG-14861)
    readonly property int tinySize:     10.0
    readonly property int smallSize:    12.0
    readonly property int regularSize:  14.0
    readonly property int mediumSize:   16.0
    readonly property int largeSize:    24.0
    readonly property int hugeSize:     32.0

    property bool fixFontSize: false  // set to true for not applying baseFontSize

    // font-size are best specified using the fontSize property, which
    // wraps font.pointSize to take the DPI of the display into account.
    // If font.pointSize is used directly text might appear to small on some
    // devices.
    //
    // If you really need to specify font.pixelSize instead of pointSize,
    // you need to clear font.pointSize explicitly with NaN:
    // font.pointSize: NaN
    property int fontSize: 14

    font.pointSize: ((fixFontSize ? 0 : ApplicationSettings.baseFontSize)
                      + fontSize) * ApplicationInfo.fontRatio
    font.family: GCSingletonFontLoader.fontLoader.name
}
