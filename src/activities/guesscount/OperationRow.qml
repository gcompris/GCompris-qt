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
import "../../core"
import "guesscount.js" as Activity

Row {
    id: operandRow
    spacing: 20
    property alias endResult: endResult
    property int rowResult
    property int noOfRows
    property int rowNo
    property int guesscount
    property bool complete
    property bool prevComplete
    property bool reparent
    property var prevText: ""
    property string text: endResult.text
    Component {
        id: component1
        DropTile {
            id: operand1
            type: "operands"
            width: operandRow.width*0.1
            height: operandRow.height
            droppedItem: operand1.children[count]
            property int count: 0
            onChildrenChanged: {
                Activity.childrenChange(operand1, operandRow)
                if(operand1.count == 1 && operator.count == 1 && operand2.count == 1) {
                    Activity.calculate(operand1.droppedItem.datavalue, operator.droppedItem.datavalue, operand2.droppedItem.datavalue, operandRow)
                    if(operandRow.rowNo == operandRow.noOfRows-1 && operandRow.rowResult == operandRow.guesscount) {
                        Activity.checkAnswer(operandRow)
                    }
                }

            }
        }
    }
    Component {
        id:component2
        Rectangle {
            id: prevResult
            width: operandRow.width*0.1
            height: operandRow.height
            color: "orange"   //orange
            radius: 10
            Rectangle {
                width: parent.width - anchors.margins
                height: parent.height - anchors.margins
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: parent.height/4
                radius: 10
                color: "#E8E8E8" //paper white
            }
            property alias droppedItem: tile
            property int count: operandRow.prevComplete ? 1 : 0
            GCText {
                id: tile
                property int datavalue: Number(tile.text)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fontSize: mediumSize
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
        width: operandRow.width*0.1
        height: operandRow.height
        property int count: 0
        droppedItem: operator.children[count]
        onChildrenChanged: {
            Activity.childrenChange(operator, operandRow)
            if(loader.children[0].count == 1 && operator.count == 1 && operand2.count == 1)
            {
                Activity.calculate(loader.children[0].droppedItem.datavalue, operator.droppedItem.datavalue, operand2.droppedItem.datavalue, operandRow)
                if(operandRow.rowNo == operandRow.noOfRows-1 && operandRow.rowResult == operandRow.guesscount)
                {
                    Activity.checkAnswer(operandRow)
                }
            }
        }
    }
    DropTile {
        id: operand2
        type: "operands"
        width: operandRow.width*0.1
        height: operandRow.height
        property int count: 0
        droppedItem: operand2.children[count]
        onChildrenChanged: {
            Activity.childrenChange(operand2, operandRow)
            if(loader.children[0].count == 1 && operator.count == 1 && operand2.count == 1) {
                Activity.calculate(loader.children[0].droppedItem.datavalue, operator.droppedItem.datavalue, operand2.droppedItem.datavalue, operandRow)
                operandRow.complete = true
                if(operandRow.rowNo == operandRow.noOfRows-1 && operandRow.rowResult == operandRow.guesscount) {
                    Activity.checkAnswer(operandRow)
                }
            }
        }
    }

    Rectangle {
        width: operandRow.width*0.1
        height: operandRow.height
        color: "transparent"
        radius: 10
        Rectangle {
        width: parent.width * 0.8
        height: parent.height * 0.8
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 10
        color: "#1B8BD2"  //blue
            Rectangle {
                width: parent.width - anchors.margins
                height: parent.height - anchors.margins
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: parent.height/4
                radius: 10
                color: "#E8E8E8" //paper white
            }
        }
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "="
            fontSize: mediumSize
        }
    }

    Rectangle {
        width: operandRow.width*0.1
        height: operandRow.height
        color: "orange"   //orange
        radius: 10
        Rectangle {
            width: parent.width - anchors.margins
            height: parent.height - anchors.margins
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: parent.height/4
            radius: 10
            color: "#E8E8E8" //paper white
        }
        GCText {
            id: endResult
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: ""
        }
    }

    onPrevTextChanged: {
        if(items.solved) {
            return
        }
        if(!prevComplete) {
            endResult.text = ""
            operandRow.complete = false
        }
        else {
            if(operator.count == 1 && operand2.count == 1) {
                Activity.calculate(parseInt(prevText), operator.droppedItem.datavalue, operand2.droppedItem.datavalue, operandRow)
                operandRow.complete = true
                if(operandRow.rowNo == operandRow.noOfRows-1 && operandRow.rowResult == operandRow.guesscount) {
                    Activity.checkAnswer(operandRow)
                }
            }
        }
    }
    onReparentChanged: {
        if(operandRow.reparent) {
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
