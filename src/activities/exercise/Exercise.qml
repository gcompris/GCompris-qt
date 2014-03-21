/* GCompris - exercise.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import QtQuick 2.1

import "qrc:/gcompris/src/core"
import "exercise.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
            id: background
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "DeepSkyBlue" }
                GradientStop { position: 1.0; color: "LightsteelBlue" }
            }
            signal start
            signal stop

            Component.onCompleted: {
                activity.start.connect(start)
                activity.stop.connect(stop)
            }
            onStart: { Activity.start(main, background, bar, bonus) }
            onStop: { Activity.stop() }

            Text {
                anchors.centerIn: parent
                wrapMode : Text.Wrap
                text: "my multiple activities"
                font.pointSize: 18
            }
            Item {
                width: 300; height: 300

                Rectangle {
                    id: rect
                    width: 150; height: 100; anchors.centerIn: parent
                    color: "red"
                    antialiasing: true

                    states: State {
                        name: "rotated"
                        PropertyChanges { target: rect; rotation: 180 }
                    }

                    transitions: Transition {
                        RotationAnimation { duration: 1000; direction: RotationAnimation.Counterclockwise }
                    }
                    Text {
                        text: " rotate"
                        font.pointSize: 24
                        color: "black"
                    }
                }

                MouseArea { anchors.fill: parent; onClicked: rect.state = "rotated" }
                   }
            Rectangle {
                id: smiley
                width:30
                height:30
                color:"red"
                y: 200/3
                x: 100


                // Animate the y property. Setting loops to Animation.Infinite makes the
                // animation repeat indefinitely, otherwise it would only run once.
                SequentialAnimation on x {
                    loops: Animation.Infinite

                    // Move from minHeight to maxHeight in 300ms, using the OutExpo easing function
                    NumberAnimation {
                        from: 100; to: 500
                        easing.type: Easing.OutExpo; duration: 300
                    }

                    // Then move back to minHeight in 1 second, using the OutBounce easing function
                    NumberAnimation {
                        from: 500; to: 100
                        easing.type: Easing.OutBounce; duration: 1000
                    }

                    // Then pause for 500ms
                    PauseAnimation { duration: 500 }
                }
            }
            Rectangle {
                id: smi
                width:30
                height:30
                color:"red"
                y: 200/3
                x: 100
                SequentialAnimation on y {
                    loops: Animation.Infinite
                NumberAnimation {
                    from: 500; to: 100
                    easing.type: Easing.OutBounce; duration: 1000}

                        }
            }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
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

