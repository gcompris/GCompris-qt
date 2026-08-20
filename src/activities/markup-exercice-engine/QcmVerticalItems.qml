import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property var verticalQcmOriginalContentArray: []
    property var verticalQcmContentArray: []
    property string resultMarkStatus: ""
    property var userSelections: []
    property real bottomPadding: 15

    // reset userSelections array when verticalQcmContentArray is modified.
    onVerticalQcmContentArrayChanged: {
        var initial = []
        for (var i = 0; i < verticalQcmContentArray.length; i++) {
            initial.push(false)
        }
        userSelections = initial
    }

    implicitWidth: mainRow.implicitWidth
    implicitHeight: mainRow.implicitHeight + bottomPadding

    RowLayout {
        id: mainRow

        Layout.bottomMargin: 150

        ColumnLayout {
            spacing: 8

            Repeater {
                model: root.verticalQcmContentArray

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


