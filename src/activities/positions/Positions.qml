/* GCompris - Positions.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
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
            anchors.margins: GCStyle.baseMargins

            property bool horizontalLayout: mainScreen.width >= mainScreen.height

            Rectangle {
                id: backgroundScreen
                width: parent.width
                height: mainScreen.horizontalLayout ? parent.height * 0.6 : parent.height * 0.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                visible: items.currentLevel % 2 !== 0
                color: "#55333333"
                radius: GCStyle.halfMargins

                BoxBoyPosition {
                    id: currentPosition
                    anchors.centerIn: parent
                    checkState: items.checkState
                    width: Math.min(parent.width, parent.height)
                }
            }

            GridView {
                id: answerViews
                width: parent.width + GCStyle.baseMargins
                visible: backgroundScreen.visible
                anchors.top: backgroundScreen.bottom
                anchors.left: backgroundScreen.left
                anchors.bottom: parent.bottom
                anchors.topMargin: GCStyle.baseMargins
                cellWidth: mainScreen.horizontalLayout ? answerViews.width / answerViews.count : answerViews.width
                cellHeight: mainScreen.horizontalLayout ? answerViews.height : answerViews.height / answerViews.count
                keyNavigationWraps: true
                model: positionModels
                focus: false
                currentIndex: -1

                delegate: Rectangle {
                    id: answer
                    color: index == answerViews.currentIndex ? GCStyle.lightBg : "#80FFFFFF"
                    radius: GCStyle.halfMargins
                    width: answerViews.cellWidth - GCStyle.baseMargins
                    height: answerViews.cellHeight - GCStyle.baseMargins
                    border.width: index == answerViews.currentIndex ? GCStyle.thinBorder : 0
                    border.color: GCStyle.blueBorder

                    property alias text: answerText.text
                    GCText {
                        id: answerText
                        text: stateName
                        fontSize: mediumSize
                        wrapMode: Text.WordWrap
                        fontSizeMode: Text.Fit
                        width: answer.width - 2 * GCStyle.baseMargins
                        height: answer.height - GCStyle.baseMargins
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
        }

        GCTextPanel {
            id: questionPanel
            visible: items.currentLevel % 2 === 0
            panelWidth: activityBackground.width - score.width - 3 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: activityBackground.horizontalCenter
            anchors.horizontalCenterOffset: -(score.height + 2 * GCStyle.baseMargins) * 0.5
            anchors.top: mainScreen.top
            textItem.text: items.questionText
        }

        GridView {
            id: positionViews
            anchors.top: questionPanel.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.left: mainScreen.left
            width: mainScreen.width
            height: mainScreen.height - questionPanel.height - GCStyle.baseMargins
            visible: questionPanel.visible
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

            delegate: Item {
                id: posItem
                width: positionViews.itemWidth
                height: positionViews.itemWidth

                BoxBoyPosition {
                    checkState: stateId
                    width: positionViews.itemWidth
                    height: positionViews.itemWidth
                    scale: mouseArea.containsMouse?  1.1 : 1
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: selectCurrentItem()
                    enabled: !items.buttonsBlocked
                    hoverEnabled: index != positionViews.currentIndex
                }

                function selectCurrentItem() {
                    positionViews.currentIndex = index
                    items.selectedPosition = positionModels.get(index).stateId
                }
            }

            highlight: Rectangle {
                width: positionViews.itemWidth
                height: positionViews.itemWidth
                radius: GCStyle.halfMargins
                color: GCStyle.lightTransparentBg
                border.width: GCStyle.thinBorder
                border.color: GCStyle.blueBorder
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        ListModel {
            id: positionModels
        }
        
        ErrorRectangle {
            id: errorRectangle
            radius: GCStyle.halfMargins
            imageSize: Math.min(okButton.width, width, height)

            function releaseControls() { items.buttonsBlocked = false; }

            function startAnimation() {
                errorRectangle.width = items.view.currentItem.width;
                errorRectangle.height = items.view.currentItem.height;
                var itemPosition = items.view.currentItem.mapToItem(activityBackground, 0, 0)
                errorRectangle.x = itemPosition.x;
                errorRectangle.y = itemPosition.y;
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
            anchors.margins: GCStyle.baseMargins
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: Math.min(GCStyle.bigButtonHeight, activityBackground.width * 0.2)
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
            anchors.margins: GCStyle.baseMargins
            onStop: Activity.nextSubLevel()
        }
    }
}
