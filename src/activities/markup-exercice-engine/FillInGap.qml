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

    implicitWidth: textInput.implicitWidth
    implicitHeight: textInput.implicitHeight

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    width: implicitWidth
    height: implicitHeight


    TextInput {
        id: textInput
        text: userInput.defaultDisplayString
        cursorVisible: true
        font.pixelSize : 21

        activeFocusOnTab: true

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
