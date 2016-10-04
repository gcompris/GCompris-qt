/* GCompris - OperationRow.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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
import "../../core"
import "guesscount-summer.js" as Activity

Row {
    id: operandRow
    spacing: 40
    property alias endResult: endResult
    property int rowResult
    property int noOfRows
    property int rowNo
    property int guesscount
    property var prevResult
    property bool complete: false
    property bool prevComplete
    property bool reparent
    Component {
        id: component1
        DropTile {
            id: operand1
            type : "operands"
            width: operandRow.width*0.1
            height: operandRow.height
            droppedItem: operand1.children[count]
            property int count: 0
            onChildrenChanged: {
                Activity.childrenChange(operand1,operandRow)
                if(operand1.count==1 && operator.count==1 && operand2.count==1)
                {
                    Activity.calculate(operand1.droppedItem.datavalue,operator.droppedItem.datavalue,operand2.droppedItem.datavalue,operandRow)
                    operandRow.complete=true
                    if(operandRow.rowNo==operandRow.noOfRows-1 && operandRow.rowResult==operandRow.guesscount)
                    {
                        Activity.checkAnswer()
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
            color: "white"
            border.color: "black"
            property alias droppedItem: tile
            property int count: operandRow.prevComplete ? 1 : 0
            GCText {
                id: tile
                property int datavalue: Number(tile.text)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fontSize: mediumSize
                text: operandRow.prevResult == 0 ? "" : operandRow.prevResult
            }
            radius: 20.0
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
            Activity.childrenChange(operator,operandRow)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].droppedItem.datavalue,operator.droppedItem.datavalue,operand2.droppedItem.datavalue,operandRow)
                operandRow.complete=true
                if(operandRow.rowNo==operandRow.noOfRows-1 && operandRow.rowResult==operandRow.guesscount)
                {
                    Activity.checkAnswer()
                }
            }
        }
    }
    DropTile {
        id: operand2
        type : "operands"
        width: operandRow.width*0.1
        height: operandRow.height
        property int count: 0
        droppedItem: operand2.children[count]
        onChildrenChanged: {
            Activity.childrenChange(operand2,operandRow)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].droppedItem.datavalue,operator.droppedItem.datavalue,operand2.droppedItem.datavalue,operandRow)
                operandRow.complete=true
                if(operandRow.rowNo==operandRow.noOfRows-1 && operandRow.rowResult==operandRow.guesscount)
                {
                    Activity.checkAnswer(operandRow)
                }
            }
        }
    }

    Rectangle {
        width: operandRow.width*0.1
        height: operandRow.height
        color: "transparent"
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: Activity.url+"equal.svg"
        }
        radius: 20.0
    }
    Rectangle {
        width: operandRow.width*0.1
        height: operandRow.height
        border.color: "black"
        GCText{
            id: endResult
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: ""
        }
        radius: 20.0
    }
    onPrevResultChanged: {
        if(!prevComplete)
        {
            endResult.text=""
            operandRow.complete=false
            operandRow.rowResult=0
        }
        else
        {
            if( operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].droppedItem.datavalue,operator.droppedItem.datavalue,operand2.droppedItem.datavalue,operandRow)
                operandRow.complete=true
            }
        }
    }
    onReparentChanged: {
        console.log('reparent   1')
        if(operandRow.reparent)
        {
            if(loader.children[0]){
                if(loader.children[0].count!=0 && rowNo==0){
                    loader.children[0].droppedItem.parent=loader.children[0].droppedItem.reparent
                }
            }
            if(operator.count!=0){
                operator.droppedItem.parent=operator.droppedItem.reparent
            }
            if(operand2.count!=0){
                operand2.droppedItem.parent=operand2.droppedItem.reparent
            }
        }
    }
}
