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

Rectangle {
    id: moneyAreaBody
    width: parent.width
    color: "#55333333"
    border.color: GCStyle.darkerBorder
    border.width: GCStyle.thinnestBorder
    radius: GCStyle.halfMargins

    property alias pocketModel: pocketModel
    property alias answer: pocket
    required property int itemSize
    signal transaction(int index)

    Flow {
        anchors.fill: parent
        anchors.margins: GCStyle.halfMargins
        spacing: GCStyle.halfMargins

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: 0
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
                height: moneyAreaBody.itemSize
                width: moneyAreaBody.itemSize
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit

                property bool selected: false

                MultiPointTouchArea {
                    anchors.fill: parent
                    onReleased: moneyAreaBody.transaction(index)
                    enabled: !bonus.isPlaying
                }

                Rectangle {
                    width: parent.width + GCStyle.halfMargins
                    height: width
                    color: GCStyle.whiteBg
                    opacity: 0.5
                    anchors.centerIn : parent
                    radius: GCStyle.halfMargins
                    visible: selected
                    z: -1
                }
            }
        }
    }
}
