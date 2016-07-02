import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row{
    id: operation_row
    spacing: 40
    property int row_result
    property int row_no
    DropTile {
        id: operand1
        type : "operands"
        width: 100
        height: 100
        visible: row_no ? false : true
        dropped_item: operand1.children[1]
        property int count: 0
        onDropped: {
            console.log('drop')
            if(operand1.count==0)
            {
                console.log('inc 1')
              operand1.count+=1
                }
            else if(operand1.count==1)
            {
                console.log('reparent')
                operand1.dropped_item.parent=operand1.dropped_item.reparent
                }
            console.log(operand1.dropped_item.datavalue)
            if(operand1.count==1 && operator.count==1 && operand2.count==1)
            {
                console.log('add')
                operation_row.row_result=Activity.calculate(operand1.dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row.row_result)
                end_result.text=Qt.binding(function() { return operation_row.row_result.toString() })
            }
        }
        onChildrenChanged: {
            console.log('parent change')

            if(!operand1.dropped_item && operand1.count)
            {
                console.log('dec 1')
                operand1.count-=1
            }
            console.log(operand1.count +'     count')
                if(operand1.count==0 || operator.count==0 || operand2.count==0)
            {
                    console.log('clear')
                end_result.text=Qt.binding(function() { return '' })
            }
        }
    }
    Rectangle {
        id: prev_result
        width: 100
        height: 100
        color: "white"
        border.color: "black"
        visible: row_no ? true : false
        GCText{
            id: tile
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: ''
        }
        radius: 20.0
    }

    DropTile {
        id: operator
        type : "operators"
        width: 100
        height: 100
        property int count: 0
        dropped_item: operator.children[1]
        onDropped: {
            if(!operator.count)
            {
                operator.count+=1
                console.log(operator.dropped_item.datavalue)
            }
            else
            {
                operator.dropped_item.parent=operator.dropped_item.reparent
            }

        }
    }
    DropTile {
        id: operand2
        type : "operands"
        width: 100
        height: 100
        property int count: 0
        dropped_item: operand2.children[1]
        onDropped: {
            if(!operand2.count)
            {
                operand2.count+=1
                console.log(operand2.dropped_item.datavalue)
            }
            else
            {
                operand2.dropped_item.parent=operand2.dropped_item.reparent
            }

        }
    }

    Rectangle {
        width: 100
        height: 100
        color: "transparent"
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: Activity.url+"equal.svg"
        }
        radius: 20.0
    }
    Rectangle {
        width: 100
        height: 100
        border.color: "black"
        GCText{
            id: end_result
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: ""
        }
        radius: 20.0
    }
}
