/* GCompris - MoneyCore.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "money.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/family/resource/background.svg"
        width: parent.width
        height: parent.height
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property alias activityBackground: activityBackground
            property alias badAnswerSound: badAnswerSound
            property alias paySound: paySound
            property alias unpaySound: unpaySound
            property alias answerModel: answerArea.pocketModel
            property alias pocketModel: pocketArea.pocketModel
            property alias store: store
            property alias instructions: instructions
            property alias tux: tux
            readonly property var levels: activity.datasets
            property alias tuxMoney: tuxMoney
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int itemIndex
            property int moneyCount
            property var selectedArea
            property alias pocket: pocketArea.answer
            property alias answer: answerArea.answer
            property int mode: 1 // default is automatic
            property alias errorRectangle: errorRectangle
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: paySound
            source: Activity.url + "money1.wav"
        }

        GCSoundEffect {
            id: unpaySound
            source: Activity.url + "money2.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Column {
            id: columnLayout
            spacing: 10
            x: parent.width * 0.05
            y: parent.height * 0.05
            width: parent.width * 0.9

            // === The Answer Area ===
            MoneyArea {
                id: answerArea
                onTransaction: (index) => {
                    Activity.unpay(index)
                }

                ErrorRectangle {
                    id: errorRectangle
                    anchors.fill: parent
                    radius: 5
                    imageSize: parent.height * 0.5
                    function releaseControls() { items.buttonsBlocked = false; }
                }
            }

            // === The Store Area ===
            property int nbStoreColumns: activity.dataset === "BACK_WITHOUT_CENTS" ||
                                         activity.dataset === "BACK_WITH_CENTS" ? store.model.length + 1 : store.model.length
            //tempSpace is a workaround to replace instructionsArea.realHeight that is freezing with Qt-5.9.1
            property int tempSpace: bar.level === 1 ? 140 + columnLayout.spacing : 50
            property int storeHeight: Math.min(1000, ((parent.height * 0.95 - columnLayout.spacing * 3 - bar.height * 1.5) - tempSpace) / 3)
            property int itemStoreSize: Core.fitItems(columnLayout.width - 20, storeHeight - 20 , nbStoreColumns) - 20

            property int itemSize: Math.min(Core.fitItems(columnLayout.width - 10, storeHeight - 10, items.moneyCount) - 5, storeHeight * 0.5)

            Rectangle {
                id: storeArea
                height: columnLayout.storeHeight
                width: columnLayout.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5
                Flow {
                    id: storeAreaFlow
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 20

                    add: Transition {
                        NumberAnimation {
                            properties: "x"
                            from: parent.width * 0.05
                            duration: 300
                        }
                    }

                    Image {
                        id: tux
                        visible: activity.dataset === "BACK_WITHOUT_CENTS" ||
                                 activity.dataset === "BACK_WITH_CENTS"
                        source: "qrc:/gcompris/src/activities/mosaic/resource/tux.svg"
                        sourceSize.height: columnLayout.itemStoreSize
                        sourceSize.width: columnLayout.itemStoreSize

                        Repeater {
                            id: tuxMoney
                            Image {
                                source: modelData.img
                                sourceSize.height: columnLayout.itemStoreSize * 0.3
                                x: tux.x + index * 50
                                y: tux.y + tux.height / 2 + index * 20
                            }
                        }
                    }

                    Repeater {
                        id: store
                        Image {
                            source: modelData.img
                            sourceSize.height: columnLayout.itemStoreSize
                            sourceSize.width: columnLayout.itemStoreSize
                            GCText {
                                text: modelData.price
                                height: parent.height
                                width: parent.width
                                fontSizeMode: Text.Fit
                                font.weight: Font.DemiBold
                                style: Text.Outline
                                styleColor: "black"
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: index % 2 == 0 ?  0 : parent.height - height
                            }
                        }
                    }
                }
            }

            // == The instructions Area ==
            Rectangle {
                id: instructionsArea
                height: instructions.height
                width: columnLayout.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5
                anchors.topMargin: 4
                anchors.bottomMargin: 4
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                visible: bar.level === 1

                property int realHeight: bar.level === 1 ? height + columnLayout.spacing : 0

                GCText {
                    id: instructions
                    horizontalAlignment: Text.AlignHCenter
                    width: columnLayout.width
                    height: columnLayout.height / 6
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.Fit
                }
            }

            // === The Pocket Area ===
            MoneyArea {
                id: pocketArea
                onTransaction: (index) => Activity.pay(index)
            }
        }

        Keys.enabled: !items.buttonsBlocked

        Keys.onPressed: (event) => {
            if(event.key === Qt.Key_Tab) {
                if(items.selectedArea.count !== 0 && items.itemIndex !== -1)
                    items.selectedArea.itemAt(items.itemIndex).selected = false

                if(items.selectedArea == items.pocket) {
                    items.selectedArea = items.answer
                }
                else {
                    items.selectedArea = items.pocket
                }
                items.itemIndex = 0
            }

            if(items.selectedArea.count !== 0) {
                if(items.itemIndex >= 0)
                    items.selectedArea.itemAt(items.itemIndex).selected = false

                if(event.key === Qt.Key_Right) {
                    if(items.itemIndex != (items.selectedArea.count-1))
                        items.itemIndex++
                    else
                        items.itemIndex = 0
                }
                if(event.key === Qt.Key_Left) {
                    if(items.itemIndex > 0)
                        items.itemIndex--
                    else
                        items.itemIndex = items.selectedArea.count-1
                }
                if([Qt.Key_Space, Qt.Key_Enter, Qt.Key_Return].indexOf(event.key) != -1 && items.itemIndex !== -1 ) {
                    if(items.selectedArea == items.pocket)
                        Activity.pay(items.itemIndex)
                    else
                        Activity.unpay(items.itemIndex)
                    if(items.itemIndex > 0)
                        items.itemIndex--
                }
            }

            if(items.selectedArea.count !== 0 && items.itemIndex !== -1)
                items.selectedArea.itemAt(items.itemIndex).selected = true
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: okButton
            enabled: items.mode === 2 && !items.buttonsBlocked
            visible: items.mode === 2
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 45 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: (activityBackground.height - bar.height * 1.2) * 0.15
            onClicked: Activity.checkAnswer()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
