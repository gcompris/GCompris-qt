/* GCompris - LyricsArea.qml
*
* SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
