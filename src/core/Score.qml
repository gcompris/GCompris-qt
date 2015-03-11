/* GCompris - Score.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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

Rectangle {
    id: score

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#AAFFFFFF" }
        GradientStop { position: 0.9; color: "#AAFFFFFF" }
        GradientStop { position: 1.0; color: "#AACECECE" }
    }
    width: subLevelText.width * 2
    height: subLevelText.height * 1.4
    radius: 10
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 30

    border.color: "black"
    border.width: 2

    z: 1000

    property alias fontSize: subLevelText.fontSize

    /* Either fill in numberOfSubLevels and currentSubLevel
     * or directly the message you want to write */
    property int numberOfSubLevels
    property int currentSubLevel
    property string message

    onCurrentSubLevelChanged: message = currentSubLevel + "/" + numberOfSubLevels
    onNumberOfSubLevelsChanged: message = currentSubLevel + "/" + numberOfSubLevels

    GCText {
        id: subLevelText
        anchors.centerIn: parent
        fontSize: mediumSize
        font.bold: true
        color: "black"
        text: message
    }
}
