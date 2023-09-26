/* GCompris - Positions.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "positions.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true;
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/family/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        focus: true
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop

        property bool keyboardMode: false

        QtObject {
            id: items
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            readonly property var levels: activity.datasetLoader.data
            property GCSfx audioEffects: activity.audioEffects
            property alias score: score
            property int checkState: -1
            property int selectedPosition: -1
            property string questionText: ""
            property alias positionModels: positionModels
            property var view: items.currentLevel % 2 !== 0 ? answerViews : positionViews
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                Activity.verifyAnswer()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Left) {
                items.view.moveCurrentIndexLeft()
                items.view.currentItem.selectCurrentItem()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Right) {
                items.view.moveCurrentIndexRight()
                items.view.currentItem.selectCurrentItem()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Up) {
                items.view.moveCurrentIndexUp()
                items.view.currentItem.selectCurrentItem()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Down) {
                items.view.moveCurrentIndexDown()
                items.view.currentItem.selectCurrentItem()
                event.accepted = true
            }
        }

        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }

        Item {
            id: mainScreen
            width: background.width - okButton.width
            height: background.height - bar.height * 1.5
            anchors.top: background.top
            anchors.left: background.left

            property bool horizontalLayout: mainScreen.width >= mainScreen.height

            Rectangle {
                id: backgroundScreen
                width: parent.width * 0.7
                height: parent.height * 0.7
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30 * ApplicationInfo.ratio
                visible: items.currentLevel % 2 !== 0 ? true : false
                color: "#55333333"
                radius: 5

                BoxBoyPosition {
                    id: currentPosition
                    anchors.centerIn: parent
                    checkState: items.checkState
                    width: Math.min(parent.width, parent.height)
                    height: width
                }

                states: [
                    State {
                        name: "verticalScreen"
                        when: !mainScreen.horizontalLayout
                        PropertyChanges {
                            target: backgroundScreen
                            height: parent.height * 0.5
                        }
                    }
                ]
            }

            GridView {
                id: answerViews
                width: mainScreen.width * 0.7
                height: mainScreen.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                visible: items.currentLevel % 2 !== 0 ? true : false
                anchors.top: backgroundScreen.bottom
                anchors.topMargin: 30 * ApplicationInfo.ratio
                cellWidth: mainScreen.horizontalLayout ? answerViews.width / answerViews.count : answerViews.width
                cellHeight: mainScreen.horizontalLayout ? answerViews.height : answerViews.height / answerViews.count
                keyNavigationWraps: true
                model: positionModels
                focus: false
                currentIndex: -1

                delegate: Rectangle {
                    id: answer
                    color: index == answerViews.currentIndex ? "#FFFFFFFF" : "#80FFFFFF"
                    radius: 15
                    width: answerViews.cellWidth - 2 * ApplicationInfo.ratio
                    height: answerViews.cellHeight - 2 * ApplicationInfo.ratio
                    border.width: index == answerViews.currentIndex ? 3 : 0
                    border.color: "#373737"

                    property alias text: answerText.text
                    GCText {
                        id: answerText
                        text: stateName
                        fontSize: smallSize
                        wrapMode: Text.WordWrap
                        fontSizeMode: Text.Fit
                        width: answer.width
                        height: answer.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        id: textArea
                        anchors.fill: parent
                        onClicked: selectCurrentItem()
                        enabled: !bonus.isPlaying
                    }

                    function selectCurrentItem() {
                        answerViews.currentIndex = index
                        items.selectedPosition = stateId
                    }
                }

                states: [
                    State {
                        name: "verticalScreen"
                        when: !mainScreen.horizontalLayout
                        PropertyChanges {
                            target: answerViews
                            height: mainScreen.height * 0.3
                        }
                    }
                ]
            }

            ListModel {
                id: positionModels
            }

            GridView {
                id: positionViews
                anchors.top: questionArea.bottom
                anchors.horizontalCenter: mainScreen.horizontalCenter
                visible: items.currentLevel % 2 === 0 ? true : false
                width: mainScreen.width * 0.9
                height: mainScreen.height * 0.8
                interactive: false
                cellWidth: itemWidth
                cellHeight: itemWidth
                keyNavigationWraps: true
                model: positionModels
                layoutDirection: Qt.LeftToRight
                highlightFollowsCurrentItem: true
                focus: false
                currentIndex: -1

                property int itemWidth: Core.fitItems(positionViews.width, positionViews.height, positionViews.count)

                delegate: BoxBoyPosition {
                    id: posItem
                    checkState: stateId
                    width: positionViews.itemWidth
                    height: positionViews.itemWidth
                    scale: mouseArea.containsMouse? 1.1 : 1

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: selectCurrentItem()
                        enabled: !bonus.isPlaying
                        hoverEnabled: true
                    }

                    function selectCurrentItem() {
                        positionViews.currentIndex = index
                        items.selectedPosition = positionModels.get(index).stateId
                    }
                }

                highlight: Rectangle {
                    width: positionViews.itemWidth
                    height: positionViews.itemWidth
                    radius: 15
                    color: "#C0FFFFFF"
                    border.width: 3
                    border.color: "#373737"
                    Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                    Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
                 }
            }

            Rectangle {
                id: questionArea
                anchors.centerIn: questionItem
                width: questionItem.paintedWidth * 1.1
                height: questionItem.paintedHeight * 1.1
                radius: 10
                color: "#373737"
                border.width: 2
                border.color: "#F2F2F2"
                visible: questionItem.visible
            }

            GCText {
                id: questionItem
                visible: items.currentLevel % 2 === 0 ? true : false
                anchors.horizontalCenter: mainScreen.horizontalCenter
                anchors.top: mainScreen.top
                anchors.topMargin: background.height * 0.02
                text: items.questionText
                fontSize: smallSize
                width: parent.width * 0.8
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: "white"
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onClose: {
                home()
            }

            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        BarButton {
            id: okButton
            anchors {
                bottom: bar.top
                right: parent.right
                leftMargin: 10 * ApplicationInfo.ratio
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: (background.height - bar.height * 1.2) * 0.15
            sourceSize.width: width
            onClicked: Activity.verifyAnswer()
            mouseArea.enabled: !bonus.isPlaying
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel)
            }
        }

        Score {
            id: score
            width: background.width * 0.1
            height: background.height * 0.1
            anchors.top: background.top
            anchors.topMargin: parent.height * 0.01
            anchors.bottom: undefined
        }
    }
}
