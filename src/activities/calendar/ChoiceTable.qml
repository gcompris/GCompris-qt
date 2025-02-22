/* GCompris - ChoiceTable.qml
 *
 * SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

// Creates a active button for making a table of days of weeks.
// Set different behaviours and animations on selecting a day from day table here.

import QtQuick 2.12
import core 1.0
import "../../core"
import "calendar.js" as Activity

Item {
    id: choiceBox
    property alias choices: choices
    property alias radius: boxBg.radius
    // index in the list. Can be different of dayIndex if first day of week is not Sunday
    property int listIndex
    // Sunday = 0, Monday = 1... whatever the first day of week for current locale is
    property int day
    function select() {
        if(Activity.dayOfWeekSelected === Activity.correctAnswer["dayOfWeek"]) {
            particles.burst(40);
            animWin.start();
        }
        Activity.checkAnswer();
    }

    ParticleSystemStarLoader {
        id: particles
        clip: false
    }

    Rectangle {
        id: boxBg
        color: "#AAFFFFFF"
        radius: GCStyle.halfMargins
        border.color: GCStyle.darkBorder
        border.width: GCStyle.thinnestBorder
        width: parent.width * 0.9
        height: parent.height - GCStyle.baseMargins
        anchors.centerIn: parent
    }

    GCText {
        id: choices
        anchors.fill: boxBg
        anchors.leftMargin: GCStyle.halfMargins
        anchors.rightMargin: GCStyle.halfMargins
        fontSizeMode: Text.Fit
        font.bold: true
        color: GCStyle.darkText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: boxBg
        onClicked: {
            items.answerChoices.currentIndex = choiceBox.listIndex
            Activity.dayOfWeekSelected = choiceBox.day
            select()
            choiceBox.scale = 1
        }
        hoverEnabled: true
        enabled: !items.buttonsBlocked
        onEntered: choiceBox.scale = 1.1
        onExited: choiceBox.scale = 1
    }

    SequentialAnimation {
        id: animWin
        running: false
        loops: 1
        NumberAnimation {
            target: choiceBox
            property: "rotation"
            from: 0; to: 360
            duration: 600
            easing.type: Easing.InOutQuad
        }
    }
}
