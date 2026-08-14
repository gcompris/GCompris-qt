import QtQuick 2.12
import QtQuick.Controls


Item {
    id: successFailMarkItem

    property string resultMarkStatus: "success"  // Default state

    Rectangle {
        id: markCircle

        width: 15
        height: 15
        radius: 20
        color: "red" //isSuccess ? "#7CB342" : "#FF5722"  // green for success, red for fail
        z: 200

        Text {
            anchors.centerIn: parent
            color: "white"
            font.bold: true
            font.pointSize: 12


            text: {
                if (successFailMarkItem.resultMarkStatus === "success") {
                    markCircle.visible = true
                    markCircle.color = "green"
                    return "✓"

                }
                if (successFailMarkItem.resultMarkStatus === "failure") {
                    markCircle.visible = true
                    markCircle.color = "red"
                    return "✘"
                }
                else {
                    markCircle.visible = false
                    return ""
                }
            }

        }
    }
}
