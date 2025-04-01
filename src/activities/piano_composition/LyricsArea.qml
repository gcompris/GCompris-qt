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
import core 1.0

import "../../core"

Rectangle {
    id: lyricsArea

    property string title: ""
    property string origin: ""
    property string lyrics: ""

    border.width: GCStyle.thinBorder
    radius: GCStyle.halfMargins
    border.color: GCStyle.blueBorder
    visible: activityBackground.isLyricsMode

    GCText {
        id: melodyTitle
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: GCStyle.halfMargins
        }
        height: parent.height / 8
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        text: qsTr("Title: %1").arg(lyricsArea.title)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        color: "#5471af"
    }

    Rectangle {
        id: titleUnderline
        width: melodyTitle.contentWidth
        height: GCStyle.thinBorder
        color: GCStyle.blueBorder
        anchors.top: melodyTitle.bottom
        anchors.margins: GCStyle.halfMargins
        anchors.horizontalCenter: melodyTitle.horizontalCenter
    }

    GCText {
        id: melodyOrigin
        anchors {
            top: titleUnderline.bottom
            left: parent.left
            right: parent.right
            margins: GCStyle.halfMargins
        }
        height: parent.height / 10
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        text: qsTr("Origin: %1").arg(lyricsArea.origin)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.italic: true
        color: "#69799a"
    }

    GCText {
        id: melodyLyrics
        anchors {
            top: melodyOrigin.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: GCStyle.halfMargins
        }
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        text: lyricsArea.lyrics
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    function resetLyricsArea() {
        lyricsArea.title = ""
        lyricsArea.origin = ""
        lyricsArea.lyrics = ""
        optionsRow.lyricsOrPianoModeIndex = 0
    }

    function setLyrics(title: string, origin: string, lyrics: string) {
        resetLyricsArea()
        lyricsArea.title = title
        lyricsArea.origin = origin
        lyricsArea.lyrics = lyrics
        optionsRow.lyricsOrPianoModeIndex = 1
    }
}
