/* GCompris - football.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "football.js" as Activity

import GCompris 1.0
ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias field: field
            property alias border: border
            property alias ball: ball
            property alias line: line
            property alias tux: tux
            property alias moveTux: moveTux
            property alias moveUp: moveUp
            property alias moveDown: moveDown
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias timer: timer
            property GCSfx audioEffects: activity.audioEffects
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        /* To modify when screen size changes */
        onHeightChanged: {
            moveUp.to = 0
            moveDown.to = background.height * 0.75 - tux.height
            moveTux.restart()
        }

        Image {
            id: field
            source: Activity.url + "background.svg"
            anchors.fill: parent
            Rectangle {
                id: border
                height: parent.height * 0.75
                width: parent.width * 0.856
                x: parent.width * 0.075
                y: parent.height * 0.125
                color: "transparent"
                Rectangle {
                    id: line
                    opacity: 0.0
                    color: "#ee4b4b"
                    transformOrigin: Item.TopLeft
                }
                Image {
                    id: ball
                    source: Activity.url + "ball.svg"
                    sourceSize.height: 50 * ApplicationInfo.ratio
                    z: 10
                    onXChanged: if(line.opacity === 1) ballTouchArea.updateLine();
                    onYChanged: if(line.opacity === 1) ballTouchArea.updateLine();

                    property int halfSize: width * 0.5

                    MultiPointTouchArea {
                        id: ballTouchArea
                        enabled: !bonus.isPlaying
                        anchors.fill: parent
                        touchPoints: [ TouchPoint { id: point1 }]
                        property var pointPosition: Qt.point(0, 0)
                        onReleased: {
                            line.opacity = 0
                            Activity.startMotion(point1.x - ball.halfSize,
                                                 point1.y - ball.halfSize)
                            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                        }
                        onPressed: line.opacity = 1
                        onTouchUpdated: {
                            pointPosition = ball.mapToItem(border, point1.x, point1.y);
                            updateLine();
                        }

                        function updateLine() {
                            Activity.drawLine(pointPosition.x, pointPosition.y, ball.x + ball.halfSize, ball.y + ball.halfSize);
                        }
                    }
                }
                Image {
                    id: tux
                    source: Activity.url+"tux_top.svg"
                    sourceSize.height: 80 * ApplicationInfo.ratio
                    x: border.width - tux.width
                    y: border.height / 2
                    SequentialAnimation on y {
                        id: moveTux
                        loops: Animation.Infinite
                        running: true
                        PropertyAnimation {
                            id: moveUp
                            duration: 800
                            easing.type: Easing.InOutQuad
                        }
                        PropertyAnimation {
                            id: moveDown
                            duration: 800
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
            Rectangle {
                width: parent.width * 0.1
                height: parent.height * 0.75
                color: "blue"
                anchors.top: border.top
                anchors.left: border.right
                z: 10
                opacity: 0.3
            }
        }

        Timer {
            id: timer
            interval: 16;
            running: false;
            repeat: true
            onTriggered: Activity.ballMotion()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
