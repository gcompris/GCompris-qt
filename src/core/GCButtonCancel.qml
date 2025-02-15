/* GCompris - GCButtonCancel.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

/**
 * A QML component representing GCompris' cancel button.
 * @ingroup components
 *
 * @inherit QtQuick.Image
 */
Image {
    id: cancel
    source: apply ? "qrc:/gcompris/src/core/resource/apply.svg" : "qrc:/gcompris/src/core/resource/cancel.svg";
    anchors.right: parent.right
    anchors.top: parent.top
    smooth: true
    width: 60 * ApplicationInfo.ratio
    height: width
    sourceSize.width: width
    sourceSize.height: height
    fillMode: Image.PreserveAspectFit
    anchors.margins: GCStyle.halfMargins

    signal close

    property bool apply: false

    SequentialAnimation {
        id: anim
        running: cancel.parent.visible
        loops: Animation.Infinite
        NumberAnimation {
            target: cancel
            property: "rotation"
            from: -10; to: 10
            duration: 500
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: cancel
            property: "rotation"
            from: 10; to: -10
            duration: 500
            easing.type: Easing.InOutQuad }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: close()
    }
}
