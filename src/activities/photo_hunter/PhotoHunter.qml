/* GCompris - PhotoHunter.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQuick.Controls.Basic

import "../../core"
import "photo_hunter.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/fifteen/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property alias brickSound: brickSound
            property alias bleepSound: bleepSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property var model
            property alias img1: img1
            property alias img2: img2
            property int total
            property int totalFound: img1.good + img2.good
            property alias frame: frame
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool isHorizontal: frame.width >= frame.height
        property double barHeight: ApplicationSettings.isBarHidden ? bar.height : bar.height * 1.5
        property bool startedHelp: false

        function checkAnswer() {
            if (items.totalFound === items.model.length) {
                bonus.good("flower")
            }
        }

        GCSoundEffect {
            id: brickSound
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        GCSoundEffect {
            id: bleepSound
            source: "qrc:/gcompris/src/core/resource/sounds/bleep.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - score.width - 3 * GCStyle.baseMargins
            panelHeight: score.height
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: score.verticalCenter
            anchors.horizontalCenterOffset: -(score.width + GCStyle.baseMargins) * 0.5
            textItem.text: activityBackground.startedHelp ?
                qsTr("Drag the slider to show the differences.") :
                qsTr("Click on the differences between the two images.")
        }

        Item {
            id: frame
            anchors.top: score.bottom
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: activityBackground.barHeight

            //left/top image
            Observe {
                id: img1
                show: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            //right/bottom image
            Observe {
                id: img2
                opacity: activityBackground.startedHelp ? 1 - slider.value : 1
                show: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            states: [
                State {
                    name: "horizontalImages"
                    when: activityBackground.isHorizontal && !activityBackground.startedHelp
                    PropertyChanges {
                        img1 {
                            anchors.horizontalCenterOffset: -img1.width * 0.5 - GCStyle.halfMargins
                            anchors.verticalCenterOffset: 0
                        }
                    }
                    PropertyChanges {
                        img2 {
                            anchors.horizontalCenterOffset: img1.width * 0.5 + GCStyle.halfMargins
                            anchors.verticalCenterOffset: 0
                        }
                    }
                },
                State {
                    name: "verticalImages"
                    when: !activityBackground.isHorizontal && !activityBackground.startedHelp
                    PropertyChanges {
                        img1 {
                            anchors.verticalCenterOffset: -img1.height * 0.5 - GCStyle.halfMargins
                        }
                    }
                    PropertyChanges {
                        img2 {
                            anchors.verticalCenterOffset: img1.height * 0.5 + GCStyle.halfMargins
                        }
                    }
                },
                State {
                    name: "verticallHelp"
                    when: activityBackground.startedHelp
                    PropertyChanges {
                        img1 {
                            anchors.verticalCenterOffset: 0
                        }
                    }
                    PropertyChanges {
                        img2 {
                            anchors.verticalCenterOffset: 0
                        }
                    }
                }
            ]

            GCSlider {
                id: slider
                value: 0
                width: img1.width * 0.9
                z: activityBackground.startedHelp ? 5 : -5
                opacity: activityBackground.startedHelp ? 1 : 0
                enabled: activityBackground.startedHelp
                snapMode: Slider.NoSnap
                stepSize: 0

                anchors {
                    top: img2.bottom
                    topMargin: GCStyle.baseMargins
                    horizontalCenter: img1.horizontalCenter
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: {
                activityBackground.startedHelp = !activityBackground.startedHelp
                slider.value = 0
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            anchors {
                bottom: undefined
                left: undefined
                top: activityBackground.top
                right: parent.right
                margins: GCStyle.baseMargins
            }
            numberOfSubLevels: items.total
            currentSubLevel: items.totalFound
        }
    }
}
