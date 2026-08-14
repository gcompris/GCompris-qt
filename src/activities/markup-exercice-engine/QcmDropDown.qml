import QtQuick 2.12
import QtQuick.Controls

import "markup-exercice-engine.js" as Activity

Rectangle {
    id: qcm
    property string text
    property string answer
    property var comboboxContentArray: []
    property var comboboxOriginalContentArray: []
    property var userAnswer
    property var userAnswerIndex
    property string resultMarkStatus



    objectName: "qcm"
    color: "lightblue"

    width: qcmComboBox.width
    height: 20 //qcmComboBox.cursorRectangle.height  //todo

    userAnswer: qcmComboBox.currentValue
    userAnswerIndex: qcmComboBox.currentIndex

    ComboBox {
        id: qcmComboBox

        z: 100
        height: 25
        implicitWidth: contentItem.implicitWidth + leftPadding + indicator.width

        contentItem: Text {
                text: qcmComboBox.displayText
                font: qcmComboBox.font
                color: qcmComboBox.enabled ? "black" : "gray"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
        }

        model: qcm.comboboxContentArray

        onActivated: {
            console.log("Exercice Type:", currentText)
            Activity.exerciceType = currentText
        }
    }

    SuccessFailMark {
        id: successFailMarkItem
        z: 200
        x: qcm.width - 10
        resultMarkStatus: qcm.resultMarkStatus
    }


}
