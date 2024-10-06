/* GCompris - SplashScreen.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

Rectangle {
    id: splash
    color: "#16B8EA"
    Image {
        id: logo
        source: "qrc:/gcompris/src/core/resource/gcompris-logo-full.svg"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: parent.width * 0.3
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: loadingImage
        source: "qrc:/gcompris/src/core/resource/loading.svg"
        anchors.centerIn: parent
        sourceSize.width: 150
        width: sourceSize.width
        height: sourceSize.width
        opacity: 0.8

        RotationAnimation on rotation {
            id: rotation
            running: splash.visible
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1500
        }
    }
}
