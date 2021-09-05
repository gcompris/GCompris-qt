import QtQuick 2.6
import "../../core"
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../server.js" as Activity

Popup {
    id: addPupilsFromListDialog

    signal pupilsDetailsAdded()

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ColumnLayout {
        height: parent.height

        width: parent.width

        Rectangle {
            id: addPupilsFromListTextRectangle

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 40
            Layout.preferredHeight: 40
            Text {
                id: deletePupilGroupsText
                anchors.centerIn: parent
                text: qsTr("Add Pupils From List")
                font.bold: true
                color: Style.colourNavigationBarBackground
                font {
                  family: Style.fontAwesome
                  pixelSize: 15
                }
            }
        }

        Rectangle {

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 80
            Layout.preferredHeight: 100
            Text {
                anchors.centerIn: parent
                text: qsTr("Format:\nPatrick Dummy;2003\nPatricia Brown;2004\nor\nPatrick Dummy;2003;2nd grade-music-sport\nPatricia Brown;2004;2nd grade-music-art")
                font.bold: true
                color: "grey"
                font {
                  family: Style.fontAwesome
                  pixelSize: 12
                }
            }
        }


        Rectangle {
            id: textEditRectangle

            Layout.preferredWidth: parent.width - 20
            Layout.minimumWidth: parent.width - 20
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            border.color: "grey"
            border.width: 1

            Flickable {
                 id: flick

                 anchors.fill: parent
                 contentWidth: edit.paintedWidth
                 contentHeight: edit.paintedHeight
                 clip: true

                 function ensureVisible(r)
                 {
                     if (contentX >= r.x)
                         contentX = r.x;
                     else if (contentX+width <= r.x+r.width)
                         contentX = r.x+r.width-width;
                     if (contentY >= r.y)
                         contentY = r.y;
                     else if (contentY+height <= r.y+r.height)
                         contentY = r.y+r.height-height;
                 }

                 TextEdit {
                     id: edit
                     width: textEditRectangle.width
                     focus: true
                     wrapMode: TextEdit.Wrap
                     onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

                     color: "black"

                     text: Activity.debugString


                 }
            }
        }

        Rectangle {
            id: okCancelRectangle

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: saveButton.height
            Layout.preferredHeight: Layout.minimumHeight

            ViewButton {
                id: saveButton

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: qsTr("Save")
                onClicked: {

              //      var lines = edit.text.split('\n')

                    Activity.addPupilsNamesFromList(edit.text)

                    //console.log("---- " + lines)
                    addPupilsFromListDialog.pupilsDetailsAdded()
                    addPupilsFromListDialog.close();

                }

            }

            ViewButton {
                id: cancelButton

                anchors.right: saveButton.left
                anchors.bottom: parent.bottom
                text: qsTr("Cancel")

                onClicked: {
                   console.log("cancel...")
                   addPupilsFromListDialog.close();
                }
            }
        }
    }
}
