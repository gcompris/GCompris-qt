/* GCompris - GCButtonScroll.qml
 *
 * SPDX-FileCopyrightText: 2017 Timothée Giet <animtim@gcompris.net>
 *               2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

/**
 * A QML component representing GCompris' scroll buttons.
 * @ingroup components
 *
 * @inherit QtQuick.Image
 */
Rectangle {
    id: scrollButtons
    color: "#00000000"
    width: (isHorizontal ? 110 : 50) * ApplicationInfo.ratio
    height: (isHorizontal ? 50 : 110) * ApplicationInfo.ratio

    signal up
    signal down

    property bool upVisible: false
    property bool downVisible: false

    property bool isHorizontal: false
    property real heightRatio: isHorizontal ? (50 / 110) : (110 / 50)
    property real widthRatio: 1 / heightRatio

    BarButton {
        id: scrollUp
        width: isHorizontal ? parent.height : parent.width
        height: width
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        sourceSize.width: scrollUp.width
        sourceSize.height: scrollUp.height
        rotation: 180
        anchors.top: isHorizontal ? undefined : parent.top
        anchors.left: isHorizontal ? parent.left : undefined
        onClicked: up()
        visible: upVisible
    }

    BarButton {
        id: scrollDown
        width: isHorizontal ? parent.height : parent.width
        height: width
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        sourceSize.width: scrollDown.width
        sourceSize.height: scrollDown.height
        anchors.bottom: parent.bottom
        anchors.right: isHorizontal ? parent.right : undefined
        onClicked: down()
        visible: downVisible
    }
}
