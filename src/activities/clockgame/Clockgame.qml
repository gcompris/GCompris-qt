/* GCompris - Clockgame.qml
*
* Copyright (C) 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "clockgame.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {

    }

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/menu/resource/background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int targetH: 12
            property int targetM: 0
            property int targetS: 0
            property int currentH: 1
            property int currentM: 25
            property int currentS: 43
            property int numberOfTry: 3
            property int currentTry: 0
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        Score {
            anchors {
                bottom: bar.top
                bottomMargin: 10 * ApplicationInfo.ratio
                right: bar.right
                rightMargin: 10 * ApplicationInfo.ratio
                left: parent.left
                leftMargin: 10 * ApplicationInfo.ratio
                top: undefined
            }
            numberOfSubLevels: items.numberOfTry
            currentSubLevel: items.currentTry + 1
        }

        /* Target text */
        Rectangle {
            id: questionItemBackground
            color: "#c0ceb339"
            border.width: 0
            radius: 10
            z: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                margins: 10
            }
            height: questionItem.height + anchors.margins * 2
            width: questionItem.width + anchors.margins * 2
            Behavior on height { PropertyAnimation { duration: 100 } }

            GCText {
                id: questionItem
                text: qsTr("Set the watch to:") + " " +
                      //~ singular %n hour
                      //~ plural %n hours
                      addNbsp(qsTr("%n hour(s)", "", items.targetH)) + " " +
                      //~ singular %n minute
                      //~ plural %n minutes
                      addNbsp(qsTr("%n minute(s)", "", items.targetM)) +
                      //~ singular %n second
                      //~ plural %n seconds
                      (s.visible ? " " + addNbsp(qsTr("%n second(s)", "", items.targetS)) : "")
                fontSize: mediumSize
                textFormat: Text.RichText
                font.weight: Font.DemiBold
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: background.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    margins: 10
                }
                // We don't want the wrapping to happen anywhere, set no break space
                function addNbsp(str) {
                    return str.replace(" ", "&nbsp;");
                }
            }
        }

        /* The clock */
        Image {
            id: clock
            source: Activity.url + "clock_bg.svg"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            sourceSize.height: parent.height

            property int radius: Math.min(background.width * 1.4, background.height)

            /* The yellow zones */
            Image {
                id: zones
                source: Activity.url + "clock_zones.svg"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                sourceSize.height: parent.height * 0.7
                visible: items.bar.level < 5
                z: 2
            }

            /* The setter */
            Image {
                id: setter
                source: Activity.url + "clock_setter.svg"
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.right
                    leftMargin: -10
                }
                z: 1
            }

            /* The minutes */
            Repeater {
                model: 60
                GCText {
                    text: index + 1
                    font {
                        pointSize: NaN  // need to clear font.pointSize explicitly
                        pixelSize: Math.max(
                                       (index + 1) % 5
                                       === 0 ? clock.radius / 40 : clock.radius / 45,
                                               1)
                        bold: items.currentM === ((index + 1) % 60) || (items.currentS === ((index + 1) % 60) && s.visible)
                        underline: items.currentM === ((index + 1) % 60) || (items.currentS === ((index + 1) % 60) && s.visible)
                    }
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.33 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 60)
                        horizontalCenterOffset: clock.radius * 0.33 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 60)
                    }
                    z: 4
                    color: "#d56a3a"
                    visible: items.bar.level < 6
                }
            }

            Repeater {
                model: 60

                Rectangle {
                    color: "#d56a3a"
                    width: clock.radius * 0.02
                    height: 2
                    rotation: 90 + (index + 1) * 360 / 60
                    radius: 1
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.3 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 60)
                        horizontalCenterOffset: clock.radius * 0.3 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 60)
                    }
                    z: 4
                    visible: items.bar.level < 8
                }
            }

            /* The hours */
            Repeater {
                model: 12
                GCText {
                    text: index + 1
                    font {
                        pointSize: NaN  // need to clear font.pointSize explicitly
                        pixelSize: Math.max(clock.radius / 30, 1)
                        bold: items.currentH === ((index + 1) % 12)
                        underline: items.currentH === ((index + 1) % 12)
                    }
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.26 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 12)
                        horizontalCenterOffset: clock.radius * 0.26 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 12)
                    }
                    z: 4
                    color: "#3a81d5"
                    visible: items.bar.level < 7
                }
            }

            Repeater {
                model: 12

                Rectangle {
                    color: "#3a81d5"
                    width: clock.radius * 0.03
                    height: 4
                    rotation: 90 + (index + 1) * 360 / 12
                    radius: 1
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.3 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 12)
                        horizontalCenterOffset: clock.radius * 0.3 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 12)
                    }
                    z: 4
                    visible: items.bar.level < 9 || (items.bar.level === 9
                                                     && ((index + 1) % 3) === 0)
                }
            }

            /* Help text */
            GCText {
                id: helper
                text: Activity.get2CharValue(
                          items.currentH) + ":" + Activity.get2CharValue(
                          items.currentM) + ":" + Activity.get2CharValue(
                          items.currentS)
                font.pointSize: NaN
                font.pixelSize: Math.max(clock.radius / 30, 1)
                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: clock.radius * 0.2
                }
                z: 4
                color: "#2a2a2a"
                visible: items.bar.level < 4
            }

            /* Arrow H */
            Rectangle {
                id: h
                property alias angle: roth.angle
                height: clock.radius * 0.2
                width: height / 10
                radius: width / 2
                color: "#3a81d5"
                transform: Rotation {
                    id: roth
                    origin.x: h.width / 2
                    origin.y: 0
                    angle: (180 + 360 * (items.currentH / 12 + items.currentM / 60 / 12)) % 360
                    Behavior on angle {
                        RotationAnimation {
                            duration: 100
                            direction: RotationAnimation.Shortest
                        }
                    }
                }

                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: h.height / 2
                }
                z: 5
            }

            /* Arrow M */
            Rectangle {
                id: m
                property alias angle: rotm.angle
                height: clock.radius * 0.28
                width: height / 20
                radius: width / 2
                color: "#d56a3a"
                transform: Rotation {
                    id: rotm
                    origin.x: m.width / 2
                    origin.y: 0
                    angle: (180 + 360 * (items.currentM / 60 + items.currentS / 60 / 60)) % 360
                    Behavior on angle {
                        RotationAnimation {
                            duration: 100
                            direction: RotationAnimation.Shortest
                        }
                    }
                }

                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: m.height / 2
                }
                z: 6
            }

            /* Arrow S */
            Rectangle {
                id: s
                property alias angle: rots.angle
                height: clock.radius * 0.32
                width: height / 30
                radius: width / 2
                color: "#2ccf4b"
                transform: Rotation {
                    id: rots
                    origin.x: s.width / 2
                    origin.y: 0
                    angle: (180 + 360 * items.currentS / 60) % 360
                    Behavior on angle {
                        RotationAnimation {
                            duration: 100
                            direction: RotationAnimation.Shortest
                        }
                    }
                }

                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: s.height / 2
                }
                z: 7
                visible: items.bar.level > 2
            }

            /* Center */
            Rectangle {
                id: center
                color: "#2a2a2a"
                height: clock.radius / 25
                width: height
                radius: width / 2
                anchors.centerIn: clock
                z: 8
            }

            /* Manage the move */
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: {
                    /* Find the closer Arrow */
                    var a = (270 + 360 + 180 * Math.atan2(
                                 mouseY - (center.y + center.height / 2),
                                 mouseX - (center.x + center.width / 2)) / Math.PI) % 360
                    var agnh = h.angle
                    var angm = m.angle
                    var angs = s.angle
                    var dh = Math.min(Math.abs(a - agnh),
                                      Math.abs(a - agnh - 360),
                                      Math.abs(a - agnh + 360))
                    var dm = Math.min(Math.abs(a - angm),
                                      Math.abs(a - angm - 360),
                                      Math.abs(a - angm + 360))
                    var ds = s.visible ? Math.min(
                                             Math.abs(a - angs),
                                             Math.abs(a - angs - 360),
                                             Math.abs(a - angs + 360)) : 9999
                    var dmin = Math.min(dh, dm, ds)

                    if (dh === dmin) {
                        Activity.selectedArrow = h
                    } else if (dm === dmin) {
                        Activity.selectedArrow = m
                    } else {
                        Activity.selectedArrow = s
                    }
                }

                onReleased: {
                    Activity.selectedArrow = null
                    if (items.currentH === items.targetH
                            && items.currentM === items.targetM
                            && items.currentS === items.targetS) {
                        items.bonus.good("gnu")
                    }
                }

                onMouseXChanged: {
                    /* Move */
                    if (Activity.selectedArrow !== null) {
                        var a = (270 + 360 + 180 * Math.atan2(
                                     mouseY - (center.y + center.height / 2),
                                     mouseX - (center.x + center.width / 2)) / Math.PI) % 360

                        var previousM = items.currentM
                        var previousS = items.currentS

                        if (Activity.selectedArrow === h) {
                            items.currentH = Math.round(
                                        12 * ((a - 180) / 360 - items.currentM / 60 / 12) + 12) % 12
                        } else if (Activity.selectedArrow === m) {
                            items.currentM = Math.round(
                                        60 * ((a - 180) / 360 - items.currentS / 60 / 60) + 60) % 60
                        } else {
                            items.currentS = Math.round(
                                        60 * (a - 180) / 360 + 60) % 60
                        }

                        if (previousS > 45 && items.currentS < 15)
                            items.currentM = (items.currentM + 1 + 60) % 60
                        if (previousS < 15 && items.currentS > 45)
                            items.currentM = (items.currentM - 1 + 60) % 60
                        if (previousM > 45 && items.currentM < 15)
                            items.currentH = (items.currentH + 1 + 12) % 12
                        if (previousM < 15 && items.currentM > 45)
                            items.currentH = (items.currentH - 1 + 12) % 12
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | level
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextTry)
        }
    }
}
