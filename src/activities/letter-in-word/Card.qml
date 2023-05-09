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
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "letter-in-word.js" as Activity

Rectangle {
    id: cardItem
    property bool mouseActive: true
    color: "#01FFFFFF"  //setting the base as not totally transparent rectangle avoids the bug of randomly overlapping images when highlight moves

    Image {
        id: wordPic
        width: cardItem.width * 0.8
        height: width
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        source: imgurl
    }

    Rectangle {
        width: cardBg.width + 10 * ApplicationInfo.ratio
        height: cardBg.height + 10 * ApplicationInfo.ratio
        radius: 15 * ApplicationInfo.ratio
        color: "#00000000"
        border.width: 5 * ApplicationInfo.ratio + 1 // +1 to avoid subpixel holes around cardBg
        border.color: "#E77936"
        anchors.centerIn: cardBg
        visible: selected
    }

    Rectangle {
        id: cardBg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: wordPic.width
        height: wordPic.height * 0.5
        radius: 10 * ApplicationInfo.ratio
        color: "#E0FFFFFF"

        GCText {
            id: textItem
            text: spelling
            font.pointSize: NaN  // need to clear font.pointSize explicitly
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            font.pixelSize: cardBg.width * 0.30
            font.bold: true
            style: Text.Outline
            width: cardBg.width
            height: cardBg.height
            wrapMode: spelling.indexOf(' ') === -1 ? Text.WrapAnywhere : Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            styleColor: "white"
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
