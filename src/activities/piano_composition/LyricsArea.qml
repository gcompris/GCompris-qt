/* GCompris - LyricsArea.qml
*
* Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
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

Rectangle {
    id: lyricsArea

    property string title: ""
    property string origin: ""
    property string lyrics: ""

    border.width: 3
    radius: 5
    border.color: "black"
    opacity: 0.8
    visible: background.isLyricsMode
    Item {
        id: melodyTitle
        width: parent.width
        height: parent.height / 6
        GCText {
            id: titleText
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            text: qsTr("Title: %1").arg(lyricsArea.title)
            anchors.fill: parent
            anchors.rightMargin: parent.width * 0.02
            anchors.leftMargin: parent.width * 0.02
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            color: "green"
        }
    }

    Rectangle {
        id: titleUnderline
        width: titleText.contentWidth
        height: 3
        color: "black"
        anchors.top: melodyTitle.bottom
        anchors.horizontalCenter: melodyTitle.horizontalCenter
    }

    Item {
        id: melodyOrigin
        width: parent.width
        height: parent.height / 8
        anchors.top: titleUnderline.bottom
        GCText {
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            text: qsTr("Origin: %1").arg(lyricsArea.origin)
            anchors.fill: parent
            anchors.rightMargin: parent.width * 0.02
            anchors.leftMargin: parent.width * 0.02
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.italic: true
            color: "red"
        }
    }

    Item {
        id: melodyLyrics
        width: parent.width
        height: parent.height - melodyTitle.height - melodyOrigin.height - 20
        anchors.top: melodyOrigin.bottom
        GCText {
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            text: lyricsArea.lyrics
            anchors.fill: parent
            anchors.rightMargin: parent.width * 0.05
            anchors.leftMargin: parent.width * 0.05
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    function resetLyricsArea() {
        lyricsArea.title = ""
        lyricsArea.origin = ""
        lyricsArea.lyrics = ""
        optionsRow.lyricsOrPianoModeIndex = 0
    }

    function setLyrics(title, origin, lyrics) {
        resetLyricsArea()
        lyricsArea.title = title
        lyricsArea.origin = origin
        lyricsArea.lyrics = lyrics
        optionsRow.lyricsOrPianoModeIndex = 1
    }
}
