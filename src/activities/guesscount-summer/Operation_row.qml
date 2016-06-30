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
        property bool drop: false
        onDropped: {
            if(operand1.drop==false)
            {
                operand1.drop=true
                console.log(operand1.children[1].datavalue)
                if(operand1.drop && operator.drop && operand2.drop)
                {
                    operation_row.row_result=Activity.calculate(operand1.children[1].datavalue,operator.children[1].datavalue,operand2.children[1].datavalue,operation_row.row_result)
                    console.log(operation_row.row_result)
                    end_result.children[1].text=Number(operation_row.row_result).toString()
                    // check if integer
                    /*if(Activity.check_if_not_integer(row4))
                    {
                        dialog.visible=true
                        audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                        row4.children[5].children[0].text=" "
                    }
                    row5.enabled=true
                    Activity.check_answer(row4,items,1)*/
                }
            else
            {
                operand1.children[1].parent=operand1.children[1].reparent
            }
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
        property bool drop: false
        onDropped: {
            if(operator.drop==false)
            {
                operator.drop=true
                console.log(operator.children[1].datavalue)

            }
            else
            {
                operator.children[1].parent=operator.children[1].reparent
            }

        }
    }
    DropTile {
        id: operand2
        type : "operands"
        width: 100
        height: 100
        property bool drop: false
        onDropped: {
            if(operand2.drop==false)
            {
                operand2.drop=true
                console.log(operand2.children[1].datavalue)
            }
            else
            {
                operand2.children[1].parent=operand2.children[1].reparent
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
        id: end_result
        width: 100
        height: 100
        border.color: "black"
        GCText{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: ""
        }
        radius: 20.0
    }
}
