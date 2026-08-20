import QtQuick
import QtQuick.Controls
import "markup-exercice-engine.js" as Activity



Rectangle {
    id: qcm

    property alias comboboxContentArray: qcmComboBox.model
    property var comboboxOriginalContentArray: []
    property string resultMarkStatus

    readonly property alias userAnswer: qcmComboBox.currentText
    readonly property alias userAnswerIndex: qcmComboBox.currentIndex

    color: "transparent" // Ou retire la propriété si non nécessaire
    width: qcmComboBox.width
    height: 25

    ComboBox {
        id: qcmComboBox

        z: 100
        height: parent.height
        implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding + indicator.width

        contentItem: Text {
            text: qcmComboBox.displayText
            font: qcmComboBox.font
            color: qcmComboBox.enabled ? "black" : "gray"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

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


