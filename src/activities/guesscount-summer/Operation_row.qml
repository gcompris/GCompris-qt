import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row{
    id: operation_row
    spacing: 40
    property alias end_result: end_result
    property int row_result
    property int no_of_rows
    property int row_no
    property int guesscount
    property var prev_result
    property bool complete: false
    property bool prev_complete
    property bool reparent
    Component{
        id: component1
        DropTile {
            id: operand1
            type : "operands"
            width: operation_row.width*0.1
            height: operation_row.height
            dropped_item: operand1.children[count]
            property int count: 0
            onChildrenChanged: {
                Activity.children_change(operand1,operation_row)
                if(operand1.count==1 && operator.count==1 && operand2.count==1)
                {
                    Activity.calculate(operand1.dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                    operation_row.complete=true
                    if(operation_row.row_no==operation_row.no_of_rows-1 && operation_row.row_result==operation_row.guesscount)
                    {
                        Activity.check_answer()
                    }
                }

            }
        }
    }
    Component{
        id:component2
        Rectangle {
            id: prev_result
            width: operation_row.width*0.1
            height: operation_row.height
            color: "white"
            border.color: "black"
            property alias dropped_item: tile
            property int count: operation_row.prev_complete ? 1 : 0
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
        width: operation_row.width*0.1
        height: operation_row.height
        property int count: 0
        dropped_item: operator.children[count]
        onChildrenChanged: {
            Activity.children_change(operator,operation_row)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                operation_row.complete=true
                if(operation_row.row_no==operation_row.no_of_rows-1 && operation_row.row_result==operation_row.guesscount)
                {
                    Activity.check_answer()
                }
            }

        }
    }
    DropTile {
        id: operand2
        type : "operands"
        width: operation_row.width*0.1
        height: operation_row.height
        property int count: 0
        dropped_item: operand2.children[count]
        onChildrenChanged: {
            Activity.children_change(operand2,operation_row)
            if(loader.children[0].count==1 && operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                operation_row.complete=true
                if(operation_row.row_no==operation_row.no_of_rows-1 && operation_row.row_result==operation_row.guesscount)
                {
                    Activity.check_answer(operation_row)
                }
            }

        }
    }

    Rectangle {
        width: operation_row.width*0.1
        height: operation_row.height
        color: "transparent"
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: Activity.url+"equal.svg"
        }
        radius: 20.0
    }
    Rectangle {
        width: operation_row.width*0.1
        height: operation_row.height
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
            operation_row.row_result=0
        }
        else
        {
            if( operator.count==1 && operand2.count==1)
            {
                Activity.calculate(loader.children[0].dropped_item.datavalue,operator.dropped_item.datavalue,operand2.dropped_item.datavalue,operation_row)
                operation_row.complete=true
            }
        }


    }
    onReparentChanged: {
        console.log('reparent   1')
        if(operation_row.reparent)
        {
            if(row_no==0)
            {
                loader.children[0].dropped_item.parent=loader.children[0].dropped_item.reparent
            }
            operator.dropped_item.parent=operator.dropped_item.reparent
            operand2.dropped_item.parent=operand2.dropped_item.reparent
        }

    }
}
