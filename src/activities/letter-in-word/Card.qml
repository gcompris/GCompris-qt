/* GCompris - Card.qml
 *
 * SPDX-FileCopyrightText: 2016 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *               2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0
import "../../core"
import "letter-in-word.js" as Activity

Rectangle {
    id: cardItem
    property bool mouseActive: true
    color: "#01FFFFFF"  //setting the base as not totally transparent rectangle avoids the bug of randomly overlapping images when highlight moves

    Image {
        id: wordPic
        width: cardItem.width * 0.6
        height: width
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        source: imgurl
    }

    Rectangle {
        id: cardBgOutline
        width: cardItem.width - GCStyle.baseMargins
        height: cardItem.height * 0.5
        radius: GCStyle.baseMargins
        color: "#00000000"
        border.width: GCStyle.thickerBorder
        border.color: "#E77936"
        anchors.centerIn: cardBg
        visible: selected
    }

    Rectangle {
        id: cardBg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: cardItem.width - 2 * GCStyle.baseMargins
        height: cardBgOutline.height - GCStyle.baseMargins
        radius: GCStyle.halfMargins
        color: "#E0FFFFFF"

        GCText {
            id: textItem
            text: spelling
            fontSizeMode: Text.Fit
            fontSize: smallSize
            font.bold: true
            anchors.fill: parent
            anchors.margins: GCStyle.halfMargins
            wrapMode: spelling.indexOf(' ') === -1 ? Text.WrapAnywhere : Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: ApplicationInfo.isMobile ? false : true
        onClicked: {
            select();
        }
    }

    SequentialAnimation {
        id: selectAnimation
        NumberAnimation {
            target: cardItem
            easing.type: Easing.InOutQuad
            property: "rotation"
            to: 20; duration: 250
        }
        NumberAnimation {
            target: cardItem
            easing.type: Easing.InOutQuad
            property: "rotation"; to: -20
            duration: 500
        }
        NumberAnimation {
            target: cardItem
            easing.type: Easing.InOutQuad
            property: "rotation"
            to: 0
            duration: 250
        }
    }

    function playWord() {
        var locale = ApplicationInfo.getVoicesLocale(items.locale)
        activity.audioVoices.append(
             ApplicationInfo.getAudioFilePathForLocale(voice, locale))
    }

    function select() {
        if(mouseActive) {
            if(Activity.checkWord(index)) {
                selectAnimation.restart();
                if(selected)
                    playWord();
            }
        }
    }
}
