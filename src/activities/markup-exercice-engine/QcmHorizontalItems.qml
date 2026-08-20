import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property var horizontalQcmOriginalContentArray: []
    property var horizontalQcmContentArray: []
    property string resultMarkStatus: ""
    property var userSelections: []
    property real bottomPadding: 15

    // Reset userSelections array when horizontalQcmContentArray is modified
    onHorizontalQcmContentArrayChanged: {
        var initial = []
        for (var i = 0; i < horizontalQcmContentArray.length; i++) {
            initial.push(false)
        }
        userSelections = initial
    }

    implicitWidth: mainRow.implicitWidth
    implicitHeight: mainRow.implicitHeight + bottomPadding

    RowLayout {
        id: mainRow
        spacing: 10
        anchors.top: parent.top
        anchors.left: parent.left

        // Alignement horizontal des boutons
        RowLayout {
            spacing: 8

            Repeater {
                model: root.horizontalQcmContentArray

                Button {
                    id: choiceButton

                    text: modelData
                    checkable: true
                    checked: root.userSelections[index] || false

                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 40

                    background: Rectangle {
                        radius: 8
                        color: choiceButton.checked ? "#7A7CF5" : "#F0F0F0"
                        border.color: choiceButton.checked ? "#4D4FB8" : "#999"
                        border.width: 1
                    }

                    onClicked: {
                        var updated = Array.from(root.userSelections)
                        updated[index] = choiceButton.checked
                        root.userSelections = updated
                        root.resultMarkStatus = ""
                    }
                }
            }
        }

        SuccessFailMark {
            id: successFailMarkItem
            Layout.alignment: Qt.AlignVCenter
            resultMarkStatus: root.resultMarkStatus
        }
    }
}