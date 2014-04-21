/* GCompris - MoneyCore.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "qrc:/gcompris/src/core"
import "money.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property variant dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "/background.svgz"
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
            property alias answerModel: answerModel
            property alias pocketModel: pocketModel
            property alias store: store
            property alias instructions: instructions
            property alias tux: tux
            property alias tuxMoney: tuxMoney
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        Column {
            id: column
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
            Rectangle {
                height: (column.itemHeight + 10) * column.nbLines
                width: column.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5

                Flow {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 10

                    add: Transition {
                        NumberAnimation {
                            properties: "x"
                            from: parent.width * 0.05
                            easing.type: Easing.InOutQuad
                        }
                    }

                    move: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Repeater {
                        id: answer
                        model: ListModel { id: answerModel }
                        Image {
                            source: Activity.url + img
                            sourceSize.height: column.itemHeight
                            height: column.itemHeight

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Activity.unpay(index)
                            }
                        }
                    }
                }
            }

            // === The Store Area ===
            property int nbStoreColumns: 4
            property int itemStoreWidth:
                Math.min(width / nbStoreColumns - 10 - 10 / nbStoreColumns,
                         parent.height * 0.18 - 10 - 10)
            property int itemStoreHeight: itemStoreWidth

            Rectangle {
                height: (column.itemStoreHeight + 10)
                width: column.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5

                Flow {
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
                        source: Activity.url + "/tux.svgz"
                        sourceSize.height:  column.itemStoreHeight
                        Repeater {
                            id: tuxMoney
                            Image {
                                source: Activity.url + modelData.img
                                sourceSize.height:  column.itemStoreHeight * 0.4
                                x: tux.x + index * 20
                                y: tux.y + tux.height / 2 + index * 20
                            }
                        }
                    }

                    Repeater {
                        id: store
                        Image {
                            source: Activity.url + modelData.img
                            sourceSize.height:  column.itemStoreHeight
                            Text {
                                text: modelData.price + " €"
                                font.pointSize: 20
                                font.weight: Font.DemiBold
                                style: Text.Outline
                                styleColor: "black"
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }

            // == The instructions Area ==
            Rectangle {
                height: instructions.height
                width: column.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5
                anchors.topMargin: 4
                anchors.bottomMargin: 4
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                Text {
                    id: instructions
                    horizontalAlignment: Text.AlignHCenter
                    width: column.width
                    wrapMode: Text.WordWrap
                }
            }

            // === The Pocket Area ===
            Rectangle {
                height: (column.itemHeight + 10) * column.nbLines
                width: column.width
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5

                Flow {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 10

                    add: Transition {
                        NumberAnimation {
                            properties: "x"
                            from: parent.width * 0.05
                            easing.type: Easing.InOutQuad
                        }
                    }

                    move: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Repeater {
                        id: pocket
                        model: ListModel { id: pocketModel }
                        Image {
                            source: Activity.url + img
                            sourceSize.height:  column.itemHeight
                            height: column.itemHeight

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Activity.pay(index)
                            }
                        }
                    }
                }
            }

        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
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
