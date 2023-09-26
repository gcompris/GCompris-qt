/* GCompris - family.qml
 *
 * SPDX-FileCopyrightText: 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
 *
 * Authors:
 *
 *   Rajdeep Kaur <rajdeep.kaur@kde.org>
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "family.js" as Activity

ActivityBase {
    id: activity

    property string mode: "family"

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        property bool horizontalLayout: background.width >= background.height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        property real treeAreaWidth: background.horizontalLayout ? background.width * 0.65 : background.width
        property real treeAreaHeight: background.horizontalLayout ? background.height : background.height * 0.65

        property real nodeWidth: (0.8 * treeAreaWidth) / 5
        property real nodeHeight: (0.8 * treeAreaWidth) / 5

        property real nodeWidthRatio: nodeWidth / treeAreaWidth
        property real nodeHeightRatio: nodeHeight / treeAreaHeight

        onWidthChanged: loadDatasetDelay.start()
        onHeightChanged: if (!loadDatasetDelay.running) {
                            loadDatasetDelay.start()
                         }

        /*
         * Adding a delay before reloading the datasets
         * needed for fast width / height changes
         */
        Timer {
            id: loadDatasetDelay
            running: false
            repeat: false
            interval: 100
            onTriggered: Activity.loadDatasets()
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias nodeRepeater: nodeRepeater
            property alias answersChoice: answersChoice
            property alias edgeRepeater: edgeRepeater
            property alias ringRepeator: ringRepeator
            property alias dataset: dataset
            property string mode: activity.mode
            property alias questionTopic: question.questionTopic
            property alias selectedPairs: selectedPairs
            property alias loadDatasetDelay: loadDatasetDelay
            property bool buttonsBlocked: false
            property point questionMarkPosition: questionMarkPosition
            property point meLabelPosition: meLabelPosition
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        FamilyDataset {
            id: dataset
        }

        // handling pair matching for family_find_relative
        Item {
            id: selectedPairs
            property var firstNodePointer: undefined
            property var secondNodePointer: undefined

            function reset() {
                firstNodePointer = undefined
                secondNodePointer = undefined
            }

            function deactivatePairs() {
                if (firstNodePointer && secondNodePointer) {
                    firstNodePointer.changeState("deactivate")
                    secondNodePointer.changeState("deactivate")
                    reset()
                }
            }

            function checkResult() {
                if (firstNodePointer.weight == (secondNodePointer.weight * -1) && firstNodePointer.weight != 0) {
                    return true
                } else {
                    return false
                }
            }

            function selectNode(node_) {
                if (firstNodePointer && secondNodePointer)
                    return

                if(firstNodePointer == undefined) {
                    firstNodePointer = node_
                    firstNodePointer.changeState("activeTo")
                } else {
                    secondNodePointer = node_

                    if (firstNodePointer == secondNodePointer) {
                        deactivatePairs()
                        return
                    }

                    secondNodePointer.changeState("activeTo")

                    // checking results
                    if (checkResult()) {
                        bonus.good("lion")
                    } else {
                        bonus.bad("lion")
                        deactivatePairs()
                    }
                }
            }
        }

        Item {
            id: board
            width: background.width
            height: background.height
            Rectangle {
                id: treeArea
                color: "transparent"
                width: background.treeAreaWidth
                height: background.treeAreaHeight
                anchors.horizontalCenter: activity.mode == "find_relative" ? board.horizontalCenter : undefined
                anchors.verticalCenter: activity.mode == "find_relative" ? board.verticalCenter : undefined
                border.width: 0
                Item {
                    id: treeItem
                    Repeater {
                        id: nodeRepeater
                        model: ListModel {}
                        delegate:
                            Node {
                            id: currentPointer
                            x: xPosition * treeArea.width
                            y: yPosition * treeArea.height
                            z: 30
                            width: treeArea.width / 5
                            height: treeArea.width / 5
                            nodeWidth: currentPointer.width
                            nodeHeight: currentPointer.height
                            nodeImageSource: Activity.url + nodeValue
                            borderColor: "#373737"
                            borderWidth: 8
                            color: "transparent"
                            radius: nodeWidth / 2
                            state:  currentState
                            weight: nodeWeight

                            states: [
                               State {
                                     name: "active"
                                     PropertyChanges {
                                         target: currentPointer
                                         borderColor: "#e1e1e1"
                                     }
                               },
                               State {
                                      name: "deactivate"
                                      PropertyChanges {
                                          target: currentPointer
                                      }
                               },
                               State {
                                    name: "activeTo"
                                    PropertyChanges {
                                        target: currentPointer
                                        borderColor: "#e77936"
                                        color: "#80f2f2f2"
                                    }
                               }
                            ]
                        }
                    }

                    Rectangle {
                        id: me
                        visible: dataset.levelElements[bar.level-1].captions[0] !== undefined && activity.mode == "family"
                        x: items.meLabelPosition.x * treeArea.width
                        y: items.meLabelPosition.y * treeArea.height

                        width: treeArea.width / 12
                        height: treeArea.height / 14

                        radius: 5
                        color: "#f2f2f2"
                        border.color: "#e1e1e1"
                        GCText {
                            id: meLabel
                            text: qsTr("Me")
                            color: "#555555"
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    Rectangle {
                        id: questionmark
                        visible: dataset.levelElements[bar.level-1].captions[1] !== undefined && activity.mode == "family"
                        x: items.questionMarkPosition.x * treeArea.width
                        y: items.questionMarkPosition.y * treeArea.height

                        width: treeArea.width / 14
                        height: width

                        radius: width/2
                        color: "#f2f2f2"
                        border.color: "#e77936"
                        GCText {
                            id: qLabel
                            text: qsTr("?")
                            color: "#555555"
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    Repeater {
                        id: edgeRepeater
                        model: ListModel {}
                        delegate: Rectangle {
                            id: edge
                            z: 20
                            opacity: 1
                            antialiasing: true
                            transformOrigin: Item.TopLeft
                            x: _x1 * treeArea.width
                            y: _y1 * treeArea.height
                            property var x2: _x2 * treeArea.width
                            property var y2: _y2 * treeArea.height
                            width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                            height: 4 * ApplicationInfo.ratio
                            rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)
                            color: "#373737"
                        }
                    }

                    Repeater {
                        id: ringRepeator
                        model: ListModel {}
                        delegate: Image {
                            id: ring
                            source: Activity.url + "rings.svg"
                            width: treeArea.width * 0.05
                            sourceSize.width: width
                            fillMode: Image.PreserveAspectCrop
                            x: ringx * treeArea.width
                            y: ringy * treeArea.height
                            z: 40
                        }
                    }
                }
            }

            Rectangle {
                id: answers
                color: "transparent"
                width: background.horizontalLayout ? background.width*0.35 : background.width
                height: background.horizontalLayout ? background.height : background.height*0.35
                anchors.left: background.horizontalLayout ? treeArea.right : board.left
                anchors.top: background.horizontalLayout ? board.top: treeArea.bottom
                border.width: 0
                Rectangle {
                    width: parent.width * 0.99
                    height: parent.height * 0.99
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"

                    Grid {
                        id: answersGrid
                        visible: activity.mode == "family" ? true : false
                        columns: 1
                        rowSpacing: 10*ApplicationInfo.ratio
                        states: [
                            State {
                                name: "anchorCenter"; when: background.horizontalLayout
                                AnchorChanges {
                                    target: answersGrid
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                }
                            },
                            State {
                                name: "anchorTop"; when: !background.horizontalLayout
                                AnchorChanges {
                                    target: answersGrid
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        ]
                        Repeater {
                            id: answersChoice
                            model: ListModel {}
                            delegate:
                                AnswerButton {
                                    id: options
                                    width: answers.width*0.75
                                    height: answers.height*Activity.answerButtonRatio
                                    textLabel: optionn
                                    isCorrectAnswer: textLabel === answer
                                    onCorrectlyPressed: bonus.good("lion")
                                    onIncorrectlyPressed: bonus.bad("lion")
                                    onPressed: items.buttonsBlocked = true
                                    blockAllButtonClicks: items.buttonsBlocked
                            }
                        }
                    }
                }
            }
        }

        GCText {
            id: question
            property string questionTopic
            visible: activity.mode == "find_relative" ? true : false
            width: background.width
            anchors.horizontalCenter: background.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            fontSize: smallSize
            text: qsTr("Select one of the pairs corresponding to: %1").arg(questionTopic)

            Rectangle {
                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                z: parent.z - 1
                radius: 10
                border.width: 1

                color: "white"
                opacity: 0.8
            }
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
            onStop: items.buttonsBlocked = false
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
