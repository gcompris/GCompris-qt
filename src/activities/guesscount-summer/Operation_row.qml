import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row{
    id: operation_row
    spacing: 40
    property alias end_result: end_result
    property int row_result
    property int row_no
    property var prev_result
    property bool complete: false
    property var prev_complete
    Component{
        id: component1
        DropTile {
            id: operand1
            type : "operands"
            width: 100
            height: 100
            dropped_item: operand1.children[count]
            property int count: 0
            onChildrenChanged: {
                Activity.children_change(operand1,operation_row)
                if(operand1.count==1 && operator.count==1 && operand2.count==1)
                {
                    Activity.calculate(operand1.dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                    operation_row.complete=true
                }

            }
        }
    }
    Component{
        id:component2
        Rectangle {
            id: prev_result
            width: 100
            height: 100
            color: "white"
            border.color: "black"
            property alias dropped_item: tile
            property int count: 1
            GCText{
                id: tile
                property int datavalue: Number(tile.text)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fontSize: mediumSize
                text: operation_row.prev_result == 0 ? "" : operation_row.prev_result
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
        dropped_item: operator.children[count]
        onChildrenChanged: {
            Activity.children_change(operator,operation_row)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                operation_row.complete=true
            }

        }
    }
    DropTile {
        id: operand2
        type : "operands"
        width: 100
        height: 100
        property int count: 0
        dropped_item: operand2.children[count]
        onChildrenChanged: {
            Activity.children_change(operand2,operation_row)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                operation_row.complete=true
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
    onPrev_completeChanged: {
        if(!prev_complete)
        {
            end_result.text=""
            operation_row.complete=false
        }
        else
        {
            operation_row.complete=true
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
            }
        }

    }
}
