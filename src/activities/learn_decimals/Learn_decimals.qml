/* GCompris - learn_decimals.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"
import "learn_decimals.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool isSubtractionMode: false
    property bool isAdditionMode: false

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        property bool horizontalLayout: background.width >= background.height
        property bool scoreAtBottom: (bar.width * 6 + okButton.width * 1.5 + score.width) < background.width

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property bool isSubtractionMode: activity.isSubtractionMode
            property bool isAdditionMode: activity.isAdditionMode
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias numpad: numpad
            property var levels: activity.datasetLoader.data
            property alias draggedItems: draggedItems
            property alias droppedItems: droppedItems
            property alias largestNumberRepresentation: largestNumberRepresentation
            property alias tutorialImage: tutorialImage
            property alias scrollBar: bottomRectangle.scrollBar
            property string largestNumber
            property string smallestNumber
            property bool helper: false
            property bool typeResult: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            visible: true
            z: 5
            Tutorial {
                id: tutorialSection
                useImage: false
                tutorialDetails: isSubtractionMode ? Activity.subtractionInstructions : isAdditionMode ? Activity.additionInstructions : Activity.tutorialInstructions
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                }
            }
        }
        // Tutorial section ends

        Item {
            id: decimalNumber
            width: parent.width / 2.3
            height: parent.height / 12
            anchors.horizontalCenter: background.horizontalCenter
            anchors.top: background.top
            anchors.topMargin: 2 * ApplicationInfo.ratio

            GCText {
                anchors.fill: parent
                text: isSubtractionMode ? qsTr("Display the result of: %1 - %2").arg(items.largestNumber).arg(items.smallestNumber) : isAdditionMode ? qsTr("Display the result of: %1 + %2").arg(items.largestNumber).arg(items.smallestNumber) : qsTr("Display the number: %1").arg(items.largestNumber)
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.DemiBold
                style: Text.Outline
                styleColor: "black"
                color: "white"
            }
        }

        ListModel {
            id: droppedItems
        }

        Rectangle {
            id: topRectangle
            visible: !isSubtractionMode
            anchors.top: decimalNumber.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 10

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: topRectangle
                        width: background.width * 0.7
                        height: background.height * 0.35
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.horizontalCenter: background.horizontalCenter
                    }
                },
                State {
                    when: !background.horizontalLayout && !items.typeResult
                    PropertyChanges {
                        target: topRectangle
                        width: background.width * 0.6
                        height: background.height * 0.6
                        anchors.rightMargin: 10 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: background.right
                        anchors.horizontalCenter: undefined
                    }
                },
                State {
                    when: !background.horizontalLayout && items.typeResult
                    PropertyChanges {
                        target: topRectangle
                        width: background.width * 0.7
                        height: background.height * 0.6
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.horizontalCenter: background.horizontalCenter
                    }
                }
            ]

            DropArea {
                id: dropArea
                anchors.fill: parent

                readonly property int maxDroppedItems: 6
                onDropped: {
                    if(droppedItems.count === dropArea.maxDroppedItems) return;
                    droppedItems.append( {"selectedSquareNumbers": bottomRectangle.currentStep + 1 } );
                    timer.restart()
                }
            }

            Timer {
                id: timer
                interval: 1000
                onTriggered: {
                    if(droppedItems.count == 1) return;
                    Activity.organizeDroppedBars();
                }
            }

            SingleBar {
                id: answerZone
                width: background.horizontalLayout ? topRectangle.width * 0.5 : topRectangle.width * 0.85
                height: topRectangle.height
                anchors.horizontalCenter: topRectangle.horizontalCenter
                anchors.top: topRectangle.top
                anchors.topMargin: background.horizontalLayout ? topRectangle.height * 0.1 : topRectangle.height * 0.125
                anchors.bottom: topRectangle.bottom
                anchors.bottomMargin: background.horizontalLayout ? topRectangle.height * 0.1 : topRectangle.height * 0.125
                cellWidth: background.horizontalLayout ? answerZone.width : answerZone.width * 0.16
                cellHeight: background.horizontalLayout ? answerZone.height * 0.16 : answerZone.height
                flow: background.horizontalLayout? GridView.LeftToRight : GridView.TopToBottom
                selectedModel: droppedItems
                isAnswerRepresentation: true
                isUnselectedBar: false
            }
        }

        ListModel {
            id: draggedItems
        }

        Rectangle {
            id: bottomRectangle
            visible: !isSubtractionMode && !items.typeResult
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 10

            property alias scrollBar: scrollBar

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangle
                        width: background.width * 0.7
                        height: background.height * 0.2
                        anchors.topMargin: 10 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: bottomRectangle
                        anchors.top: topRectangle.bottom
                        anchors.horizontalCenter: background.horizontalCenter
                    }
                },
                State {
                    when: !background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangle
                        width: background.width * 0.3
                        height: background.height * 0.6
                        anchors.topMargin: 5 * ApplicationInfo.ratio
                        anchors.rightMargin: 10 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: bottomRectangle
                        anchors.right: topRectangle.left
                        anchors.top: decimalNumber.bottom
                    }
                }
            ]

            property int currentStep: scrollBar.currentStep

            SingleBar {
                id: selectedBar
                width: bottomRectangle.width * 0.5
                height: background.horizontalLayout ? bottomRectangle.height * 0.5 : bottomRectangle.height * 0.75
                anchors.horizontalCenter: background.horizontalLayout ? bottomRectangle.horizontalCenter : undefined
                anchors.verticalCenter: bottomRectangle.verticalCenter
                anchors.right: background.horizontalLayout ? undefined : bottomRectangle.right
                anchors.rightMargin: 7 * ApplicationInfo.ratio
                cellWidth: background.horizontalLayout ? selectedBar.width * 0.1 : selectedBar.width * 0.55
                cellHeight: background.horizontalLayout ? selectedBar.height * 0.5 : selectedBar.height * 0.1
                selectedModel: draggedItems
                isAnswerRepresentation: false
                isUnselectedBar: false

                Drag.active: dragArea.drag.active

                states: [
                    State {
                        when: dragArea.drag.active
                        ParentChange {
                            target: selectedBar
                            parent: topRectangle
                        }
                    }
                ]
            }

            SingleBar {
                id: unselectedBar
                width: bottomRectangle.width * 0.5
                height: background.horizontalLayout ? bottomRectangle.height * 0.5 : bottomRectangle.height * 0.75
                anchors.horizontalCenter: background.horizontalLayout ? bottomRectangle.horizontalCenter : undefined
                anchors.verticalCenter: bottomRectangle.verticalCenter
                anchors.right: background.horizontalLayout ? undefined : bottomRectangle.right
                anchors.rightMargin: 7 * ApplicationInfo.ratio
                cellWidth: background.horizontalLayout ? selectedBar.width * 0.1 : selectedBar.width * 0.55
                cellHeight: background.horizontalLayout ? selectedBar.height * 0.5 : selectedBar.height * 0.1
                selectedModel: draggedItems
                isAnswerRepresentation: false
                isUnselectedBar: true
                z: -10
            }

            MouseArea {
                id: dragArea
                width: selectedBar.width
                height: selectedBar.height
                anchors.fill: selectedBar
                anchors.centerIn: parent
                drag.target: selectedBar

                onReleased: {
                    selectedBar.Drag.drop()
                    bottomRectangle.resetArrowPosition()
                }
            }

            Item {
               id: scrollBar

               states: [
                   State {
                       when: background.horizontalLayout
                       PropertyChanges {
                           target: scrollBar
                           width: unselectedBar.width
                           height: unselectedBar.height * 0.5
                           x: unselectedBar.x
                           y: unselectedBar.y + 35 * ApplicationInfo.ratio
                       }
                       AnchorChanges {
                           target: scrollBar
                           anchors.horizontalCenter: parent.horizontalCenter
                       }
                   },
                   State {
                       when: !background.horizontalLayout
                       PropertyChanges {
                           target: scrollBar
                           width: unselectedBar.width * 0.5
                           height: unselectedBar.height
                           x: unselectedBar.x - 40 * ApplicationInfo.ratio
                           y: unselectedBar.y
                       }
                       AnchorChanges {
                           target: scrollBar
                           anchors.verticalCenter: parent.verticalCenter
                       }
                   }
               ]

               property double horizontalBarLimit: unselectedBar.x + scrollBar.width * 0.5 - arrow.width / 2
               property double verticalBarLimit: unselectedBar.y + scrollBar.height * 0.8 - arrow.height / 2
               property alias arrowX: arrow.x
               property alias arrowY: arrow.y
               property int currentStep: 0

               Image {
                   id: arrow
                   source: "qrc:/gcompris/src/core/resource/bar_down.svg"
                   sourceSize.width: background.horizontalLayout ? scrollBar.width * 0.22 : scrollBar.width
                   sourceSize.height: background.horizontalLayout ? scrollBar.height : scrollBar.width

                   states: [
                       State {
                           when: background.horizontalLayout
                           PropertyChanges {
                               target: arrow
                               rotation: 180
                               x: 0
                           }
                           AnchorChanges {
                               target: arrow
                               anchors.verticalCenter: parent.verticalCenter
                               anchors.horizontalCenter: undefined
                           }
                       },
                       State {
                           when: !background.horizontalLayout
                           PropertyChanges {
                               target: arrow
                               rotation: -90
                               y: 0
                           }
                           AnchorChanges {
                               target: arrow
                               anchors.verticalCenter: undefined
                               anchors.horizontalCenter: parent.horizontalCenter
                           }
                       }
                   ]

                   MouseArea {
                       width: parent.width * 1.5
                       height: parent.height * 1.5
                       anchors.centerIn: parent
                       drag.target: arrow
                       onPositionChanged: {
                           if(background.horizontalLayout) {
                               //range of the horizontal scrolling
                               if(arrow.x < 0) {
                                   arrow.x = 0
                               }
                               else if(arrow.x > scrollBar.horizontalBarLimit) {
                                   arrow.x = scrollBar.horizontalBarLimit
                               }

                               scrollBar.currentStep = Math.round(arrow.x / scrollBar.horizontalBarLimit * (Activity.squaresNumber - 1));
                               arrow.x = (scrollBar.currentStep * scrollBar.horizontalBarLimit) / (Activity.squaresNumber - 1);
                           }
                           else {
                               // range of the vertical scrolling
                               if(arrow.y < 0) {
                                   arrow.y = 0
                               }
                               else if(arrow.y > scrollBar.verticalBarLimit) {
                                   arrow.y = scrollBar.verticalBarLimit
                               }

                               scrollBar.currentStep = Math.round(arrow.y / scrollBar.verticalBarLimit * (Activity.squaresNumber - 1));
                               arrow.y = (scrollBar.currentStep * scrollBar.verticalBarLimit) / (Activity.squaresNumber - 1);
                           }

                           Activity.changeSingleBarVisibility(scrollBar.currentStep + 1)
                       }
                   }

                   GCText {
                       id: text
                       visible: items.helper
                       fontSize: regularSize
                       text: Activity.toDecimalLocaleNumber((scrollBar.currentStep + 1) / Activity.squaresNumber)
                       font.bold: true
                       style: Text.Outline
                       styleColor: "white"
                       color: "black"
                       wrapMode: Text.WordWrap
                       fontSizeMode: Text.Fit
                       verticalAlignment: Text.AlignVCenter
                       horizontalAlignment: Text.AlignHCenter
                       anchors.fill: parent
                       rotation: background.horizontalLayout ? 180 : 90
                   }
               }

               onWidthChanged: {
                   if(items.draggedItems.count != 0) {
                       bottomRectangle.resetArrowPosition()
                   }
               }
               onHeightChanged: {
                   if(items.draggedItems.count != 0) {
                       bottomRectangle.resetArrowPosition()
                   }
               }
            }

            function resetArrowPosition() {
                if(background.horizontalLayout) {
                    scrollBar.arrowX = 0
                }
                else {
                    scrollBar.arrowY = 0
                }
                Activity.changeSingleBarVisibility(1)
                scrollBar.currentStep = 0
            }
        }

        ListModel {
            id: largestNumberRepresentation
        }

        Rectangle {
            id: mainRectangle
            visible: isSubtractionMode
            width: background.width * 0.7
            height: background.height * 0.6
            anchors.top: decimalNumber.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            anchors.horizontalCenter: background.horizontalCenter
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 10

            MultipleBars {
                id: multipleBars
            }
        }

        Rectangle {
            id: answerBackground
            visible: items.typeResult
            width: mainRectangle.width * 0.7
            height: mainRectangle.height * 0.13
            anchors.top: mainRectangle.bottom
            anchors.topMargin: ApplicationInfo.ratio
            color: "#f2f2f2"
            border.color: "black"
            border.width: 2
            radius: 10

            property string userEntry

            GCText {
                id: userEntryText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                color: "#373737"
                text: qsTr("Enter the result: %1").arg(answerBackground.userEntry)
            }
        }

        NumPad {
            id: numpad
            displayDecimalButton: true
            onAnswerChanged: {
                answerBackground.userEntry = answer
            }
            maxDigit: 3
            opacity: items.typeResult ? 1 : 0
            columnWidth: 60 * ApplicationInfo.ratio
            enableInput: !bonus.isPlaying
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                if(items.typeResult) {
                    Activity.verifyNumberTyping(answerBackground.userEntry)
                }
                else {
                    Activity.verifyNumberRepresentation()
                }
            }
            else {
               numpad.updateAnswer(event.key, true);
            }
        }

        Keys.onReleased: {
            if(items.typeResult) {
                numpad.updateAnswer(event.key, false);
            }
        }

        states: [
            State {
                when: background.scoreAtBottom
                AnchorChanges {
                    target: answerBackground
                    anchors.left: undefined
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: bar.verticalCenter
                    anchors.bottom: undefined
                    anchors.right: background.right
                    anchors.left: undefined
                }
                PropertyChanges {
                    target: okButton
                    anchors.bottomMargin: 0
                    anchors.rightMargin: okButton.width * 0.5
                    anchors.verticalCenterOffset: -10
                }
            },
            State {
                when: !background.scoreAtBottom
                AnchorChanges {
                    target: answerBackground
                    anchors.left: mainRectangle.left
                    anchors.horizontalCenter: undefined
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                    anchors.bottom: bar.top
                    anchors.right: mainRectangle.right
                    anchors.left: undefined
                }
                PropertyChanges {
                    target: okButton
                    anchors.bottomMargin: okButton.height * 0.2
                    anchors.rightMargin: 0
                    anchors.verticalCenterOffset: 0
                }
            }
        ]

        Image {
            id: hint
            source:"qrc:/gcompris/src/core/resource/bar_hint.svg"
            visible: !isSubtractionMode && !items.typeResult
            sourceSize.width: okButton.width
            sourceSize.height: okButton.height
            fillMode: Image.PreserveAspectFit
            anchors.right: okButton.left
            anchors.rightMargin: okButton.width * 0.3
            anchors.verticalCenter: okButton.verticalCenter

            MouseArea {
                id: hintMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: items.helper = !items.helper
            }

            states: State {
                when: hintMouseArea.containsMouse
                PropertyChanges {
                    target: hint
                    scale: 1.1
                }
            }
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


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar

            content: tutorialImage.visible ? tutorialBar : (items.isSubtractionMode || items.isAdditionMode) ? withConfig : withoutConfig

            property BarEnumContent tutorialBar: BarEnumContent { value: help | home }

            // Used in case of addition and subtraction mode.
            property BarEnumContent withConfig: BarEnumContent { value: help | home | level | activityConfig }

            // Used in case of basic mode.
            property BarEnumContent withoutConfig: BarEnumContent { value: help | home | level }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                if(tutorialImage.visible) {
                    tutorialImage.visible = false;
                }
                activity.home()
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: (background.height - bar.height * 1.2) * 0.15
            sourceSize.width: width
            onClicked: items.typeResult? Activity.verifyNumberTyping(answerBackground.userEntry) : Activity.verifyNumberRepresentation()
            mouseArea.enabled: !bonus.isPlaying
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            id: score
            visible: !tutorialImage.visible && !isAdditionMode && !isSubtractionMode
            height: okButton.height * 0.9
            anchors.top: undefined
            anchors.bottom: undefined
            anchors.right: hint.visible ? hint.left : okButton.left
            anchors.verticalCenter: okButton.verticalCenter
        }
    }

}
