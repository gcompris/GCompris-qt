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
import core 1.0
import "../../core"
import "positions.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true;
    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/family/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        focus: true
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop

        property bool keyboardMode: false
        readonly property int baseMargins: 10 * ApplicationInfo.ratio

        QtObject {
            id: items
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            readonly property var levels: activity.datasets
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias score: score
            property int checkState: -1
            property int selectedPosition: -1
            property string questionText: ""
            property alias positionModels: positionModels
            property var view: items.currentLevel % 2 !== 0 ? answerViews : positionViews
            property bool buttonsBlocked: false
            property alias errorRectangle: errorRectangle
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            if((event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return) && items.view.currentItem !== null) {
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

        Keys.onReleased: (event) => {
            keyboardMode = true
            event.accepted = false
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Item {
            id: mainScreen
            height: activityBackground.height - bar.height * 1.5
            anchors.top: activityBackground.top
            anchors.left: activityBackground.left
            anchors.right: okButton.width > score.width ? okButton.left : score.left
            anchors.margins: activityBackground.baseMargins

            property bool horizontalLayout: mainScreen.width >= mainScreen.height

            Rectangle {
                id: backgroundScreen
                width: parent.width - 2 * activityBackground.baseMargins
                height: mainScreen.horizontalLayout ? parent.height * 0.6 : parent.height * 0.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: activityBackground.baseMargins
                visible: items.currentLevel % 2 !== 0 ? true : false
                color: "#55333333"
                radius: activityBackground.baseMargins

                BoxBoyPosition {
                    id: currentPosition
                    anchors.centerIn: parent
                    checkState: items.checkState
                    width: Math.min(parent.width, parent.height)
                }
            }

            GridView {
                id: answerViews
                width: backgroundScreen.width
                anchors.horizontalCenter: parent.horizontalCenter
                visible: items.currentLevel % 2 !== 0 ? true : false
                anchors.top: backgroundScreen.bottom
                anchors.bottom: parent.bottom
                anchors.margins: activityBackground.baseMargins
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
                    width: answerViews.cellWidth - activityBackground.baseMargins
                    height: answerViews.cellHeight - activityBackground.baseMargins
                    border.width: index == answerViews.currentIndex ? 3 : 0
                    border.color: "#373737"

                    property alias text: answerText.text
                    GCText {
                        id: answerText
                        text: stateName
                        fontSize: mediumSize
                        wrapMode: Text.WordWrap
                        fontSizeMode: Text.Fit
                        width: answer.width - activityBackground.baseMargins
                        height: answer.height
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        id: textArea
                        anchors.fill: parent
                        onClicked: selectCurrentItem()
                        enabled: !items.buttonsBlocked
                    }

                    function selectCurrentItem() {
                        answerViews.currentIndex = index
                        items.selectedPosition = stateId
                    }
                }
            }

            Rectangle {
                id: questionArea
                anchors.centerIn: questionItem
                width: questionItem.contentWidth + activityBackground.baseMargins * 2
                height: questionItem.contentHeight + activityBackground.baseMargins
                radius: 10
                color: "#373737"
                border.width: 2
                border.color: "#F2F2F2"
                visible: questionItem.visible
            }

            GCText {
                id: questionItem
                visible: items.currentLevel % 2 === 0 ? true : false
                anchors.top: mainScreen.top
                anchors.left: mainScreen.left
                anchors.right: mainScreen.right
                anchors.margins: activityBackground.baseMargins
                height: score.height
                text: items.questionText
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                color: "white"
            }

            ListModel {
                id: positionModels
            }

            GridView {
                id: positionViews
                anchors.top: questionArea.bottom
                anchors.topMargin: activityBackground.baseMargins
                anchors.left: parent.left
                width: parent.width
                height: parent.height - questionArea.height - activityBackground.baseMargins
                visible: items.currentLevel % 2 === 0 ? true : false
                interactive: false
                cellWidth: itemWidth
                cellHeight: itemWidth
                keyNavigationWraps: true
                model: positionModels
                layoutDirection: Qt.LeftToRight
                highlightFollowsCurrentItem: true
                focus: false
                currentIndex: -1

                property int itemWidth: Core.fitItems(positionViews.width, positionViews.height, Math.max(positionModels.count, 1))

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
                        enabled: !items.buttonsBlocked
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
        }
        
        ErrorRectangle {
            id: errorRectangle
            radius: 15
            imageSize: okButton.width

            function releaseControls() { items.buttonsBlocked = false; }

            function startAnimation() {
                errorRectangle.width = items.view.currentItem.width;
                errorRectangle.height = items.view.currentItem.height;
                if (answerViews.visible) {
                    errorRectangle.x = answerViews.x + items.view.currentItem.x;
                    errorRectangle.y = answerViews.y + items.view.currentItem.y;
                } else {
                    errorRectangle.x = mainScreen.x + positionViews.x + items.view.currentItem.x;
                    errorRectangle.y = mainScreen.y + positionViews.y + items.view.currentItem.y;
                }
                errorAnimation.restart();
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
                activityBackground.stop()
                activityBackground.start()
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
            anchors.verticalCenter: mainScreen.verticalCenter
            anchors.right: activityBackground.right
            anchors.margins: activityBackground.baseMargins
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: Math.min(70 * ApplicationInfo.ratio, activityBackground.width * 0.2)
            onClicked: Activity.verifyAnswer()
            mouseArea.enabled: !items.buttonsBlocked && items.selectedPosition != -1
        }

        Bonus {
            id: bonus
            onWin: Activity.nextLevel()
        }

        Score {
            id: score
            anchors.top: activityBackground.top
            anchors.right: activityBackground.right
            anchors.bottom: undefined
            anchors.margins: activityBackground.baseMargins
            onStop: Activity.nextSubLevel()
        }
    }
}
