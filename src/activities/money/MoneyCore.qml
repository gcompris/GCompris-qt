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
            spacing: GCStyle.halfMargins
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.5

            property int nbStoreColumns: tux.visible ? store.model.length + 1 : store.model.length
            property real storeHeight: instructionsArea.visible ?
                (columnLayout.height - 3 * columnLayout.spacing) / 3.5 :
                (columnLayout.height - 2 * columnLayout.spacing) / 3
            property int storeItemSize: Math.floor(
                Core.fitItems(storeArea.width - GCStyle.halfMargins,
                storeHeight - GCStyle.halfMargins, nbStoreColumns) - GCStyle.halfMargins)

            property int itemSize: Math.floor(
                Math.min(Core.fitItems(columnLayout.width - GCStyle.halfMargins,
                    storeHeight - GCStyle.halfMargins, items.moneyCount) - GCStyle.halfMargins,
                    (storeHeight - GCStyle.halfMargins) * 0.5 - GCStyle.halfMargins))

            // === The Answer Area ===
            MoneyArea {
                id: answerArea
                height: columnLayout.storeHeight
                itemSize: columnLayout.itemSize
                onTransaction: (index) => {
                    Activity.unpay(index)
                }

                ErrorRectangle {
                    id: errorRectangle
                    anchors.fill: parent
                    radius: GCStyle.halfMargins
                    imageSize: parent.height * 0.5
                    function releaseControls() { items.buttonsBlocked = false; }
                }
            }

            // === The Store Area ===
            Rectangle {
                id: storeArea
                height: columnLayout.storeHeight
                width: okButton.visible ? columnLayout.width - okButton.width - GCStyle.halfMargins :
                        columnLayout.width
                color: "#55333333"
                border.color: GCStyle.darkerBorder
                border.width: GCStyle.thinnestBorder
                radius: GCStyle.halfMargins

                Flow {
                    id: storeAreaFlow
                    anchors.fill: parent
                    anchors.margins: GCStyle.halfMargins
                    spacing: GCStyle.halfMargins

                    add: Transition {
                        NumberAnimation {
                            properties: "x"
                            from: 0
                            duration: 300
                        }
                    }

                    Image {
                        id: tux
                        visible: activity.dataset === "BACK_WITHOUT_CENTS" ||
                                 activity.dataset === "BACK_WITH_CENTS"
                        source: "qrc:/gcompris/src/activities/mosaic/resource/tux.svg"
                        sourceSize.height: columnLayout.storeItemSize
                        sourceSize.width: columnLayout.storeItemSize

                        Repeater {
                            id: tuxMoney
                            Image {
                                source: modelData.img
                                sourceSize.height: columnLayout.storeItemSize * 0.3
                                x: tux.x + index * sourceSize.height
                                y: tux.y + (tux.height + index * sourceSize.height) * 0.5
                            }
                        }
                    }

                    Repeater {
                        id: store
                        Image {
                            source: modelData.img
                            sourceSize.height: columnLayout.storeItemSize
                            sourceSize.width: columnLayout.storeItemSize
                            GCText {
                                text: modelData.price
                                anchors.fill: parent
                                fontSizeMode: Text.Fit
                                font.weight: Font.DemiBold
                                style: Text.Outline
                                styleColor: GCStyle.darkerBorder
                                color: GCStyle.whiteText
                            }
                        }
                    }
                }

                BarButton {
                    id: okButton
                    enabled: items.mode === 2 && !items.buttonsBlocked
                    visible: items.mode === 2
                    anchors {
                        left: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: GCStyle.halfMargins
                    }
                    source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                    width: Math.min(GCStyle.bigButtonHeight, parent.height)
                    onClicked: Activity.checkAnswer()
                }
            }

            // == The instructions Area ==
            Rectangle {
                id: instructionsArea
                height: columnLayout.storeHeight * 0.5
                width: columnLayout.width
                color: "#55ffffff"
                border.color: GCStyle.darkerBorder
                border.width: GCStyle.thinnestBorder
                radius: GCStyle.halfMargins
                visible: bar.level === 1

                GCText {
                    id: instructions
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    anchors.margins: GCStyle.baseMargins
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.Fit
                }
            }

            // === The Pocket Area ===
            MoneyArea {
                id: pocketArea
                height: columnLayout.storeHeight
                itemSize: columnLayout.itemSize
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
