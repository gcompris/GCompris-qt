/* GCompris - MoneyArea.qml
 *
 * SPDX-FileCopyrightText: 2018 Smit S. Patil <smit17av@gmial.com>
 *
 * Authors:
 *   Smit S. Patil <smit17av@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "money.js" as Activity

Rectangle {
    id: moneyAreaBody
    height: columnLayout.storeHeight
    width: columnLayout.width
    color: "#55333333"
    border.color: "black"
    border.width: 2
    radius: 5

    property alias pocketModel: pocketModel
    property alias answer: pocket
    signal transaction(int index)

    Flow {
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.fill: parent
        spacing: 5

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
                source: img
                height: columnLayout.itemSize
                width: columnLayout.itemSize
                sourceSize.height: height
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit

                property bool selected: false

                MultiPointTouchArea {
                    anchors.fill: parent
                    onReleased: moneyAreaBody.transaction(index)
                    enabled: !bonus.isPlaying
                }

                Rectangle {
                    width: parent.width * 1.1
                    height: parent.height * 1.1
                    color: "#88111111"
                    anchors.centerIn : parent
                    radius: 5
                    visible: selected
                    z: -1
                }
            }
        }
    }
}
