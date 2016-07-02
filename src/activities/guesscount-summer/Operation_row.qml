import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row{
    id: operation_row
    spacing: 40
    property int row_result
    property int row_no
    property var prev_object
   Component{
       id: component1
       //property alias operand1: operand1
    DropTile {
        id: operand1
        type : "operands"
        width: 100
        height: 100
        //visible: row_no ? false : true
        dropped_item: operand1.children[1]
        property int count: 0
        onDropped: {
            Activity.drop_item(operand1)
            if(operand1.count==1 && operator.count==1 && operand2.count==1)
            {
                operation_row.row_result=Activity.calculate(operand1.dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row.row_result)
                end_result.text=Qt.binding(function() { return operation_row.row_result.toString() })
            }
        }
        onChildrenChanged: Activity.children_change(operand1,end_result)
    }
   }
    Component{
        id:component2
        //property alias prev_result: prev_result
        Rectangle {
        id: prev_result
        width: 100
        height: 100
        color: "white"
        border.color: "black"
        property var dropped_item: tile
        //visible: row_no ? true : false
        GCText{
            id: tile
            property var datavalue: Number(tile.text)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: ''
        }
        radius: 20.0
    }
    }

    Loader{
        id: loader
    sourceComponent: row_no ? component2 : component1
    }

    DropTile {
        id: operator
        type : "operators"
        width: 100
        height: 100
        property int count: 0
        dropped_item: operator.children[1]
        onDropped: {
            Activity.drop_item(operator)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                operation_row.row_result=Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row.row_result)
                console.log('operation_row.row_result')
                end_result.text=Qt.binding(function() { return operation_row.row_result.toString() })
            }
        }
        onChildrenChanged: Activity.children_change(operator,end_result)
    }
    DropTile {
        id: operand2
        type : "operands"
        width: 100
        height: 100
        property int count: 0
        dropped_item: operand2.children[1]
        onDropped: {
            Activity.drop_item(operand2)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                operation_row.row_result=Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row.row_result)
                end_result.text=Qt.binding(function() { return operation_row.row_result.toString() })
            }
        }
        onChildrenChanged: Activity.children_change(operand2,end_result)
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
