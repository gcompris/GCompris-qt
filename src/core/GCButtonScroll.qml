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
import core 1.0

/**
 * A QML component representing GCompris' scroll buttons.
 * @ingroup components
 *
 * @inherit QtQuick.Image
 */
Item {
    id: scrollButtons
    width: defaultWidth
    height: defaultHeight

    signal up
    signal down

    property bool upVisible: false
    property bool downVisible: false

    readonly property int defaultWidth: (isHorizontal ? 110 : 50) * ApplicationInfo.ratio
    readonly property int defaultHeight: (isHorizontal ? 50 : 110) * ApplicationInfo.ratio
    property bool isHorizontal: false
    property real heightRatio: isHorizontal ? (50 / 110) : (110 / 50)
    property real widthRatio: 1 / heightRatio

    BarButton {
        id: scrollUp
        width: scrollButtons.isHorizontal ? scrollButtons.height : scrollButtons.width
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        rotation: 180
        anchors.top: scrollButtons.isHorizontal ? undefined : parent.top
        anchors.left: scrollButtons.isHorizontal ? scrollButtons.left : undefined
        onClicked: scrollButtons.up()
        visible: scrollButtons.upVisible
    }

    BarButton {
        id: scrollDown
        width: scrollButtons.isHorizontal ? scrollButtons.height : scrollButtons.width
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        anchors.bottom: parent.bottom
        anchors.right: scrollButtons.isHorizontal ? scrollButtons.right : undefined
        onClicked: scrollButtons.down()
        visible: scrollButtons.downVisible
    }
}
