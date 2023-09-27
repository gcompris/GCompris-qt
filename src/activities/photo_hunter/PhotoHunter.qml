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
import GCompris 1.0
import QtQuick.Controls 2.12

import "../../core"
import "photo_hunter.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
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
            property alias background: background
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

        property bool vert: frame.width <= frame.height
        property double barHeight: ApplicationSettings.isBarHidden ? bar.height / 2 : bar.height
        property bool startedHelp: false

        function checkAnswer() {
            if (items.totalFound === items.model.length) {
                bonus.good("flower")

                // after completing a level, mark the problem as shown
                if (!problem.hideProblem) {
                    problem.hideProblem = true
                }
            }
        }

        Rectangle {
            id: problem
            width: parent.width - score.width - 20 * ApplicationInfo.ratio
            height:  hideProblem ? 0 : problemText.height
            anchors.top: parent.top
            anchors.topMargin: hideProblem ? 0 : 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            color: "#C0373737"
            z: hideProblem ? -5 : 5

            property bool hideProblem: false

            GCText {
                id: problemText
                anchors.centerIn: parent
                width: parent.width * 0.9
                fontSize: mediumSize
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: background.startedHelp ? qsTr("Drag the slider to show the differences.") :
                                          qsTr("Click on the differences between the two images.")
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: problem.hideProblem = true
            }
        }

        states: [
            State {
                name: "anchorProblem"
                when: problem.height >= score.height
                AnchorChanges {
                    target: frame
                    anchors.top: problem.bottom
                }
                PropertyChanges {
                    target: frame
                    height: background.height - problem.height - bar.height * 1.5 - 10 * ApplicationInfo.ratio
                }
            },
            State {
                name: "anchorScore"
                when: score.height > problem.height
                AnchorChanges {
                    target: frame
                    anchors.top: score.bottom
                }
                PropertyChanges {
                    target: frame
                    height: background.height - score.height - bar.height * 1.5 - 10 * ApplicationInfo.ratio
                }
            }
        ]

        Item {
            id: frame
            height: background.height - problem.height - bar.height * 1.5 - 10 * ApplicationInfo.ratio
            anchors.top: problem.bottom
            anchors.left: background.left
            anchors.right: background.right

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
                opacity: background.startedHelp ? 1 - slider.value : 1
                show: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            states: [
                State {
                    name: "horizontalImages"
                    when: !background.vert && !background.startedHelp
                    PropertyChanges {
                        target: img1
                        anchors.horizontalCenterOffset: -img1.width * 0.5 - 5 * ApplicationInfo.ratio
                        anchors.verticalCenterOffset: 0
                    }
                    PropertyChanges {
                        target: img2
                        anchors.horizontalCenterOffset: img1.width * 0.5 + 5 * ApplicationInfo.ratio
                        anchors.verticalCenterOffset: 0
                    }
                },
                State {
                    name: "horizontalHelp"
                    when: !background.vert && background.startedHelp
                    PropertyChanges {
                        target: img1
                        anchors.horizontalCenterOffset: 0
                        anchors.verticalCenterOffset: 0
                    }
                    PropertyChanges {
                        target: img2
                        anchors.horizontalCenterOffset: 0
                        anchors.verticalCenterOffset: 0
                    }
                },
                State {
                    name: "verticalImages"
                    when: background.vert && !background.startedHelp
                    PropertyChanges {
                        target: img1
                        anchors.verticalCenterOffset: -img1.height * 0.5 - 5 * ApplicationInfo.ratio
                    }
                    PropertyChanges {
                        target: img2
                        anchors.verticalCenterOffset: img1.height * 0.5 + 5 * ApplicationInfo.ratio
                    }
                },
                State {
                    name: "verticallHelp"
                    when: background.vert && background.startedHelp
                    PropertyChanges {
                        target: img1
                        anchors.verticalCenterOffset: 0
                    }
                    PropertyChanges {
                        target: img2
                        anchors.verticalCenterOffset: 0
                    }
                }
            ]

            GCSlider {
                id: slider
                value: 0
                height: background.startedHelp ? 50 : 0
                width: img1.width * 0.9
                z: background.startedHelp ? 5 : -5
                opacity: background.startedHelp ? 1 : 0
                enabled: background.startedHelp
                snapMode: Slider.NoSnap
                stepSize: 0

                anchors {
                    top: img1.bottom
                    topMargin: 20
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
                background.startedHelp = !background.startedHelp
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
                top: background.top
                topMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
            }
            numberOfSubLevels: items.total
            currentSubLevel: items.totalFound
        }
    }
}
