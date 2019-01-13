/* GCompris - MoneyCore.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

import "../../core"
import "money.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "/background.svg"
        sourceSize.width: parent.width
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
            property GCSfx audioEffects: activity.audioEffects
            property alias answerModel: answerArea.pocketModel
            property alias pocketModel: pocketArea.pocketModel
            property alias store: store
            property alias instructions: instructions
            property alias tux: tux
            property alias tuxMoney: tuxMoney
            property alias bar: bar
            property alias bonus: bonus
            property int itemIndex
            property var selectedArea
            property alias pocket: pocketArea.answer
            property alias answer: answerArea.answer
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        Column {
            id: columnLayout
            spacing: 10
            x: parent.width * 0.05
            y: parent.height * 0.05
            width: parent.width * 0.9

            property int nbColumns: 5
            property int nbLines: 2
            property int itemWidth:
                Math.min(width / nbColumns - 10 - 10 / nbColumns,
                         parent.height * 0.4 / nbLines - 10 - 10 / nbLines)
            property int itemHeight: itemWidth * 0.59

            // === The Answer Area ===
            MoneyArea {
                id: answerArea
                onTransaction: Activity.unpay(index)
            }

            // === The Store Area ===
            property int nbStoreColumns: activity.dataset === "BACK_WITHOUT_CENTS" ||
                                         activity.dataset === "BACK_WITH_CENTS" ? store.model.length + 1 : store.model.length
            //tempSpace is a workaround to replace instructionsArea.realHeight that is freezing with Qt-5.9.1
            property int tempSpace: bar.level === 1 ? 140 + columnLayout.spacing : 0
            property int itemStoreWidth:
                Math.min((columnLayout.width - storeAreaFlow.spacing * nbStoreColumns) / nbStoreColumns,
                         (parent.height - answerArea.height -
                          pocketArea.height - bar.height) * 0.8) - tempSpace
            property int itemStoreHeight: itemStoreWidth

            Rectangle {
                id: storeArea
                height: (columnLayout.itemStoreHeight + 10)
                width: columnLayout.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5

                Flow {
                    id: storeAreaFlow
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    anchors.fill: parent
                    spacing: 40

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
                        source: Activity.url + "/tux.svg"
                        sourceSize.height:  columnLayout.itemStoreHeight
                        sourceSize.width:  columnLayout.itemStoreHeight
                        Repeater {
                            id: tuxMoney
                            Image {
                                source: Activity.url + modelData.img
                                sourceSize.height:  columnLayout.itemStoreHeight * 0.4
                                x: tux.x + index * 20
                                y: tux.y + tux.height / 2 + index * 20
                            }
                        }
                    }

                    Repeater {
                        id: store
                        Image {
                            source: Activity.url + modelData.img
                            sourceSize.height: columnLayout.itemStoreHeight
                            sourceSize.width: columnLayout.itemStoreHeight
                            GCText {
                                text: modelData.price
                                fontSize: 16
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
                onTransaction: Activity.pay(index)
            }
        }


        Keys.onPressed: {
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

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
