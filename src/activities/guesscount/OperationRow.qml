/* GCompris - OperationRow.qml
 *
 * SPDX-FileCopyrightText: 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "guesscount.js" as Activity

Row {
    id: operationRow
    spacing: GCStyle.baseMargins
    property alias endResult: endResult
    property int rowResult
    property int noOfRows
    property int rowNo
    property int guesscount
    property bool prevComplete
    property bool reparent
    property var prevText: ""
    property string text: endResult.text
    readonly property double tileWidth: Math.min(GCStyle.bigButtonHeight, width * 0.2 - GCStyle.baseMargins)

    function checkAnswer(firstNumber) {
        Activity.calculate(firstNumber, operator.droppedItem.datavalue, operand2.droppedItem.datavalue, operationRow)
        if(!items.solved && operationRow.rowNo == operationRow.noOfRows-1 && operationRow.rowResult == operationRow.guesscount) {
            items.solved = true
            Activity.goodAnswer()
        }
    }

    Component {
        id: component1
        DropTile {
            id: operand1
            type: "operands"
            width: operationRow.tileWidth
            height: operationRow.height
            droppedItem: operand1.children[count]
            property int count: 0
            onChildrenChanged: {
                Activity.childrenChange(operand1, operationRow)
                if(operand1.count == 1 && operator.count == 1 && operand2.count == 1) {
                    checkAnswer(operand1.droppedItem.datavalue)
                }

            }
        }
    }
    Component {
        id:component2
        Rectangle {
            id: prevResult
            width: operationRow.tileWidth
            height: operationRow.height
            color: GCStyle.paperWhite
            border.color: "orange"   //orange
            border.width: GCStyle.midBorder
            radius: GCStyle.halfMargins
            property alias droppedItem: tile
            property int count: operationRow.prevComplete ? 1 : 0
            GCText {
                id: tile
                property int datavalue: Number(tile.text)
                anchors.fill: parent
                anchors.margins: 2 * GCStyle.midBorder
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                text: prevText
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: rowNo ? component2 : component1
    }

    DropTile {
        id: operator
        type : "operators"
        width: operationRow.tileWidth
        height: operationRow.height
        property int count: 0
        droppedItem: operator.children[count]
        onChildrenChanged: {
            Activity.childrenChange(operator, operationRow)
            if(loader.children[0].count == 1 && operator.count == 1 && operand2.count == 1) {
                checkAnswer(loader.children[0].droppedItem.datavalue)
            }
        }
    }
    DropTile {
        id: operand2
        type: "operands"
        width: operationRow.tileWidth
        height: operationRow.height
        property int count: 0
        droppedItem: operand2.children[count]
        onChildrenChanged: {
            Activity.childrenChange(operand2, operationRow)
            if(loader.children[0].count == 1 && operator.count == 1 && operand2.count == 1) {
                checkAnswer(loader.children[0].droppedItem.datavalue)
            }
        }
    }

    Item {
        width: operationRow.tileWidth
        height: operationRow.height
        Rectangle {
            width: parent.width
            height: parent.height - GCStyle.baseMargins
            anchors.centerIn: parent
            radius: GCStyle.halfMargins
            color: GCStyle.paperWhite
            border.color: "#1B8BD2"  //blue
            border.width: GCStyle.midBorder
        }
        GCText {
            anchors.fill: parent
            anchors.margins: 2 * GCStyle.midBorder
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
            text: "="
        }
    }

    Rectangle {
        width: operationRow.tileWidth
        height: operationRow.height
        color: GCStyle.paperWhite
        border.color: "orange"   //orange
        border.width: GCStyle.midBorder
        radius: GCStyle.halfMargins
        GCText {
            id: endResult
            anchors.fill: parent
            anchors.margins: 2 * GCStyle.midBorder
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
            text: ""
        }
    }

    onPrevTextChanged: {
        if(prevText != "" && operator.count == 1 && operand2.count == 1) {
            checkAnswer(parseInt(prevText))
        }
    }
    onReparentChanged: {
        if(operationRow.reparent) {
            if(loader.children[0]) {
                if(loader.children[0].count != 0 && rowNo == 0) {
                    loader.children[0].droppedItem.parent = loader.children[0].droppedItem.reparent
                }
            }
            if(operator.count != 0) {
                operator.droppedItem.destroy()
            }
            if(operand2.count != 0) {
                operand2.droppedItem.parent = operand2.droppedItem.reparent
            }
        }
    }
}
