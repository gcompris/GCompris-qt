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
    property int currentCircle: 0
    property bool fullyLoaded: false
    property alias colorChangeTimer: colorChangeTimer

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
    }

    Timer {
        id: colorChangeTimer
        running: splash.visible
        repeat: true
        interval: 500
        onTriggered: {
            currentCircle = currentCircle >= 2 ? 0 : ++currentCircle;
        }
    }

    Row {
        id: loadingCircles
        anchors.top: loadingImage.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        spacing: 50
        Repeater {
            model: 3
            Rectangle {
                width: 75
                height: width
                radius: width
                color: fullyLoaded || currentCircle == index ? "#e77935" : "#80FFFFFF"
                border.color: "#80FFFFFF"
                border.width: 3
            }
        }
    }
}
