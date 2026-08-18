import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "markup-exercice-engine.js" as Activity


Item {
    id: root
    property var values: []        // e.g. ["*Option A", "Option B", "Option C", "*Option D"]
    property var answers: []       // stores true/false values derived from '*'
    property int selectedIndex: -1 // currently selected button index
    property int buttonHeight: 40

    signal optionSelected(int index, bool isCorrect)

    // width: parent ? parent.width : 400
    // height: 60

    // Layout.preferredWidth: implicitWidth
    // Layout.preferredHeight: implicitHeight

    implicitWidth: buttonRow.implicitWidth
    implicitHeight: buttonRow.implicitHeight

    Column {
        id: buttonRow
        topPadding: 20
        anchors.left: parent.left
        spacing: 10

        Repeater {
            model: root.values.length

            Button {
                id: choiceButton
                width: 200
                height: root.buttonHeight
                checkable: true
                checked: index === root.selectedIndex

                // Extract clean text without '*' and store correct flag
                property bool isCorrect: root.values[index].startsWith("*")
                text: isCorrect ? root.values[index].substring(1) : root.values[index]

                background: Rectangle {
                    radius: 8
                    color: choiceButton.checked ? "#7A7CF5" : "#f0f0f0"
                    border.color: "#999"
                    border.width: 1
                }

                onClicked: {
                    if (root.selectedIndex === index) {
                        root.selectedIndex = -1
                    } else {
                        root.selectedIndex = index
                    }
                    root.optionSelected(index, isCorrect)
                }
            }
        }
    }

    Component.onCompleted: {
        // Initialize answers array
        answers = values.map(v => v.startsWith("*"))
    }
}
