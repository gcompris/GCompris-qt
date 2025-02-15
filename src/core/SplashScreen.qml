/* GCompris - SplashScreen.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick

Rectangle {
    id: splash
    color: "#16B8EA"
    property int currentCircle: 0
    property bool fullyLoaded: false
    property alias colorChangeTimer: colorChangeTimer

    Image {
        id: logo
        source: "qrc:/gcompris/src/core/resource/gcompris-splash.svg"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: width * -0.2
        width: Math.min(parent.width, parent.height) * 0.4
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
    }

    Timer {
        id: colorChangeTimer
        running: splash.visible
        repeat: true
        interval: 500
        onTriggered: {
            splash.currentCircle = splash.currentCircle >= 2 ? 0 : ++splash.currentCircle;
        }
    }

    Row {
        id: loadingCircles
        anchors.top: logo.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: spacing
        spacing: logo.width * 0.1
        Repeater {
            model: 3
            Rectangle {
                required property int index
                width: loadingCircles.spacing
                height: width
                radius: width
                color: fullyLoaded || splash.currentCircle == index ? "#FFF" : "#80FFFFFF"
                border.color: "#80FFFFFF"
                border.width: 3
            }
        }
    }

    Image {
        id: kdeLogo
        source: "qrc:/gcompris/src/core/resource/kde-logo-white.svg"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: loadingCircles.spacing
        height: anchors.margins
        fillMode: Image.PreserveAspectFit
    }
}
