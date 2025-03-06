/* GCompris - family.qml
 *
 * SPDX-FileCopyrightText: 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *
 *   Rajdeep Kaur <rajdeep.kaur@kde.org>
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../core"
import "family.js" as Activity

ActivityBase {
    id: activity

    property string mode: "family"

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "background.svg"
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        readonly property bool horizontalLayout: layoutArea.width >= layoutArea.height

        readonly property real nodeSize: Math.min(treeArea.width / 8, treeArea.height * 0.2)

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias nodeRepeater: nodeRepeater
            property alias answersChoice: answersChoice
            property alias edgeRepeater: edgeRepeater
            property alias ringRepeater: ringRepeater
            property alias dataset: dataset
            property string mode: activity.mode
            property alias questionTopic: instructionPanel.questionTopic
            property alias selectedPairs: selectedPairs
            property bool buttonsBlocked: false
            property point meLabelPosition: [0,0]
            property int meLabelSide: 0
            property point questionMarkPosition: [0,0]
            property int questionMarkSide: 0
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
                items.buttonsBlocked = true;
                if (firstNodePointer.nodeWeight == (secondNodePointer.nodeWeight * -1) && firstNodePointer.nodeWeight != 0) {
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
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        Item {
            id: treeArea
            anchors.fill: layoutArea
            anchors.topMargin: activity.mode == "find_relative" ?
                instructionPanel.height + GCStyle.baseMargins :
                (activityBackground.horizontalLayout ? 0 : questionArea.height)
            anchors.rightMargin: activityBackground.horizontalLayout && activity.mode == "family" ?
                questionArea.width + GCStyle.baseMargins : 0

            Item {
                id: treeItem
                width: activityBackground.nodeSize * 8
                height: activityBackground.nodeSize * 5
                anchors.centerIn: parent

                Repeater {
                    id: edgeRepeater
                    model: ListModel {}
                    delegate: Rectangle {
                        id: edge
                        required property int _x1
                        required property int _x2
                        required property int _y1
                        required property int _y2
                        opacity: 1
                        x: (_x1 - 0.5) * activityBackground.nodeSize - GCStyle.thickerBorder * 0.5
                        y: (_y1 - 0.5) * activityBackground.nodeSize - GCStyle.thickBorder * 0.5
                        width: _x1 === _x2 ? GCStyle.thickerBorder :
                            (_x2 - _x1) * activityBackground.nodeSize
                        height: _y1 === _y2 ? GCStyle.thickerBorder :
                            (_y2 - _y1) * activityBackground.nodeSize
                        color: GCStyle.darkBorder
                    }
                }

                Repeater {
                    id: ringRepeater
                    model: ListModel {}
                    delegate: Image {
                        id: ring
                        required property int ringX
                        required property int ringY
                        source: Activity.url + "rings.svg"
                        width: activityBackground.nodeSize * 0.4
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        fillMode: Image.PreserveAspectFit
                        x: (ringX + 0.3) * activityBackground.nodeSize
                        y: (ringY + 0.3) * activityBackground.nodeSize
                    }
                }

                Repeater {
                    id: nodeRepeater
                    model: ListModel {}
                    delegate:
                    Node {
                        id: currentPointer
                        x: xPosition * activityBackground.nodeSize
                        y: yPosition * activityBackground.nodeSize
                        width: activityBackground.nodeSize
                        height: activityBackground.nodeSize
                        nodeImageSource: Activity.url + nodeValue
                        border.color: GCStyle.darkBorder
                        border.width: GCStyle.thickBorder
                        color: "#7CD5F5"
                        state:  currentState
                        enabled: !items.buttonsBlocked

                        states: [
                            State {
                                name: "active"
                                PropertyChanges {
                                    currentPointer {
                                        border.color: "#e1e1e1"
                                    }
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
                                    currentPointer {
                                        border.color: "#e77936"
                                        color: "#BAE4F3"
                                    }
                                }
                            }
                        ]
                    }
                }

                Rectangle {
                    id: me
                    visible: dataset.levelElements[bar.level-1].captions[0] !== undefined && activity.mode == "family"
                    x: (items.meLabelSide === 0 ? -width : activityBackground.nodeSize) + items.meLabelPosition.x * activityBackground.nodeSize
                    y: items.meLabelPosition.y * activityBackground.nodeSize
                    width: activityBackground.nodeSize * 0.8
                    height: activityBackground.nodeSize * 0.4
                    radius: GCStyle.halfMargins
                    color: GCStyle.lightBg
                    border.width: GCStyle.thinnestBorder
                    border.color: GCStyle.blueBorder

                    GCText {
                        id: meLabel
                        text: qsTr("Me")
                        color: GCStyle.darkText
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                        anchors.leftMargin: GCStyle.tinyMargins
                        anchors.rightMargin: GCStyle.tinyMargins
                    }
                }

                Rectangle {
                    id: questionmark
                    visible: dataset.levelElements[bar.level-1].captions[1] !== undefined && activity.mode == "family"
                    x: (items.questionMarkSide === 0 ? -width : activityBackground.nodeSize) + items.questionMarkPosition.x * activityBackground.nodeSize
                    y: items.questionMarkPosition.y * activityBackground.nodeSize

                    width: activityBackground.nodeSize * 0.4
                    height: width

                    radius: width * 0.5
                    color: GCStyle.lightBg
                    border.color: "#e77936"
                    GCText {
                        id: qLabel
                        text: qsTr("?")
                        color: GCStyle.darkText
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }
                }
            }
        }

        Item {
            id: questionArea
            anchors.right: layoutArea.right
            anchors.top: layoutArea.top
            width: activityBackground.horizontalLayout ? layoutArea.width * 0.3 : layoutArea.width
            height: activityBackground.horizontalLayout ? layoutArea.height : layoutArea.height * 0.3

            readonly property int buttonWidth: Math.min(450 * ApplicationInfo.ratio,
                                                        questionArea.width)
            readonly property int buttonHeight: Math.min(GCStyle.bigButtonHeight,
                    questionArea.height / Math.max(1, answersChoice.count) - GCStyle.halfMargins)

            Grid {
                id: answersGrid
                visible: activity.mode == "family" ? true : false
                columns: 1
                rowSpacing: GCStyle.halfMargins
                width: childrenRect.width
                height: childrenRect.height
                anchors.centerIn: parent

                Repeater {
                    id: answersChoice
                    model: ListModel {}
                    delegate:
                    AnswerButton {
                        id: options
                        width: questionArea.buttonWidth
                        height: questionArea.buttonHeight
                        textLabel: optionText
                        isCorrectAnswer: textLabel === answer
                        onCorrectlyPressed: bonus.good("lion")
                        onIncorrectlyPressed: bonus.bad("lion")
                        onPressed: items.buttonsBlocked = true
                        blockAllButtonClicks: items.buttonsBlocked
                    }
                }
            }
        }

        GCTextPanel {
            id: instructionPanel
            property string questionTopic
            visible: activity.mode == "find_relative" ? true : false
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: qsTr("Select one of the pairs corresponding to: %1").arg(questionTopic)
            textItem.color: GCStyle.darkText
            color: GCStyle.lightBg
            border.color: GCStyle.blueBorder
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
