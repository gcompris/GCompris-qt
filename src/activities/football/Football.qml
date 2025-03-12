/* GCompris - football.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (gameplay and layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12

import "../../core"
import "football.js" as Activity

import core 1.0
ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: "#64B560"
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
            property alias activityBackground: activityBackground
            property alias bar: bar
            property alias field: field
            property alias border: border
            property alias ball: ball
            property alias line: line
            property alias tux: tux
            property alias moveTux: moveTux
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias timer: timer
            property alias brickSound: brickSound
        }

        onStart: { Activity.start(items) }
        onStop: {
            activityIsStopped = true;
            repositionTimer.stop();
            Activity.stop();
        }

        /* Trigger reposition when screen size changes */
        property bool activityIsStopped: false
        onHeightChanged: {
            if(!activityIsStopped) {
                repositionTimer.restart()
            }
        }
        onWidthChanged: {
            if(!activityIsStopped) {
                repositionTimer.restart()
            }        }
        Timer {
            id: repositionTimer
            interval: 100
            running: false
            onTriggered: {
                moveTux.stop()
                ball.resetPosition()
                tux.resetPosition()
                moveTux.restart()
            }
        }

        GCSoundEffect {
            id: brickSound
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        Item {
            id: fieldArea
            anchors.fill: parent
            anchors.bottomMargin: bar.height * 1.2
            readonly property bool horizontalLayout: fieldArea.width >= fieldArea.height

            Image {
                id: field
                source: activity.resourceUrl + "background.svg"
                rotation: fieldArea.horizontalLayout ? 0 : 90
                width: fieldArea.horizontalLayout ? parent.width : parent.height
                height: fieldArea.horizontalLayout ? parent.height : parent.width
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent

                Item {
                    id: border
                    width: parent.width * 0.86
                    height: parent.height * 0.75
                    anchors.centerIn: parent

                    Rectangle {
                        id: line
                        opacity: 0.0
                        color: "#ee4b4b"
                        height: GCStyle.midBorder
                        width: 0
                        transformOrigin: Item.TopLeft
                    }

                    Image {
                        id: ball
                        source: activity.resourceUrl + "ball.svg"
                        sourceSize.height: Math.min(50 * ApplicationInfo.ratio, border.height * 0.2)
                        z: 10
                        onXChanged: if(line.opacity === 1) ballTouchArea.updateLine();
                        onYChanged: if(line.opacity === 1) ballTouchArea.updateLine();

                        function resetPosition() {
                            Activity.velocityX = 0;
                            Activity.velocityY = 0;
                            ball.x = border.width * 0.3 - ball.width * 0.5;
                            ball.y = (border.height - ball.height) * 0.5;
                        }

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
                                brickSound.play()
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
                        source: activity.resourceUrl+"tux_top.svg"
                        /* Increase size of TUX for each level */
                        sourceSize.height: ball.height + (border.height - ball.height * 3) / Activity.numberOfLevel * (items.currentLevel + 1)
                        x: border.width - tux.width
                        y: (border.height - tux.height) * 0.5
                        SequentialAnimation on y {
                            id: moveTux
                            loops: Animation.Infinite
                            running: false
                            PropertyAnimation {
                                id: moveUp
                                to: 0
                                duration: 1000
                                easing.type: Easing.InOutQuad
                            }
                            PropertyAnimation {
                                id: moveDown
                                to: border.height - tux.height
                                duration: 1000
                                easing.type: Easing.InOutQuad
                            }
                        }
                        function resetPosition() {
                            tux.x = border.width - tux.width;
                            tux.y = (border.height - tux.height) * 0.5;
                            moveUp.to = 0;
                            moveDown.to = border.height - tux.height
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - border.width) * 0.5
                    height: border.height
                    color: "blue"
                    anchors.verticalCenter: border.verticalCenter
                    anchors.left: border.right
                    z: 10
                    opacity: 0.3
                }
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
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
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
