import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "markup-exercice-engine.js" as Activity

Rectangle {
    id: userInput
    property string text
    property string defaultDisplayString
    property string expectedAnswer
    property string resultMarkStatus

    objectName: "fillInGap"
    color: "lightblue"

    implicitWidth: textInput.implicitWidth + 20
    implicitHeight: textInput.implicitHeight

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    width: implicitWidth
    height: implicitHeight


    TextInput {
        id: textInput
        text: userInput.defaultDisplayString
        cursorVisible: true
        font.pixelSize : 17

        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2  // Remonte le texte de 2 pixels (ajustez selon le besoin)

        activeFocusOnTab: true

        onActiveFocusChanged: {
            if (activeFocus) {
                selectAll()
            }
        }

        onEditingFinished: {
            userInput.defaultDisplayString = text
            console.log("---------------- textinput text:")
            console.log(text)
        }

        selectByMouse: true

        mouseSelectionMode: TextInput.SelectWords

    }

    SuccessFailMark {
        id: successFailMarkItem
        z: 200
        x: userInput.width - 10
        resultMarkStatus: userInput.resultMarkStatus
    }

}
