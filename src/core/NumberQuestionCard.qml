/* GCompris - NumberQuestionCard.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

/**
 * A QML component used in tens_complement_find and tens_complement_use
 *
 * It's meant to be used in a Flickable (GridView, ListView ...) with a ListModel
 * containing the following properties:
 *     "value": a string to display on the card
 *     "visibility": a bool telling if the card is visible or hidden
 *     "clickable": a bool telling if the card is clickable or not
 *     "isSignSymbol": a bool set to true if the value is a math symbol and not a number
 */

Item {
    id: numberCard
    visible: visibility

    property bool selected: false
    property int cardSize: Math.min(width, height)

    required property string value
    required property bool visibility
    required property bool clickable
    required property bool isSignSymbol

    signal clicked

    Rectangle {
        id: cardBg
        height: numberCard.selected ? numberCard.cardSize * 0.9 : numberCard.cardSize * 0.7
        width: height
        color: numberCard.isSignSymbol || !numberCard.clickable ? "transparent" : GCStyle.whiteBg
        border.color: numberCard.isSignSymbol || !numberCard.clickable ? "transparent" : GCStyle.blueBorder
        border.width: numberCard.selected ? GCStyle.thickerBorder : GCStyle.thinBorder
        radius: GCStyle.halfMargins
        anchors.centerIn: parent
    }
    GCText {
        id: numberText
        width: numberCard.isSignSymbol ? numberCard.height : cardBg.height
        height: numberCard.isSignSymbol ? numberCard.width : cardBg.height
        anchors.centerIn: parent
        color: GCStyle.darkText
        text: numberCard.value
        fontSize: Math.max(1, height) // avoid value of 0 during init
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        width: numberCard.height
        height: numberCard.height
        anchors.centerIn: parent
        enabled: numberCard.clickable
        onClicked: {
            numberCard.clicked();
        }
    }
}
