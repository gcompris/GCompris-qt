/* GCompris - RemovePupilsToGroupsDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: removePupilsToGroupsDialog

    property alias pupilsNamesText: pupilsNamesText
    property var pupilsNamesList

    signal accepted(var newGroups)

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 400
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    onOpened: {
        for(var i = 0 ; i < groupNamesListView.count ; ++ i) {
            groupNamesListView.currentIndex = i;
            groupNamesListView.currentItem.checked = false;
        }
    }

    ColumnLayout {
        height: parent.height
        width: parent.width

        Rectangle {
            id: removePupilsTextRectangle

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 40
            Layout.preferredHeight: 40
            Text {
                id: deletePupilGroupsText
                anchors.centerIn: parent
                width: parent.width * 2/3
                wrapMode: Text.WordWrap
                text: qsTr("Are you sure you want to remove the children from the following groups?")
                font.bold: true
                color: Style.colourNavigationBarBackground
                font {
                  family: Style.fontAwesome
                  pixelSize: 15
                }
            }
        }

        Rectangle {
            id: pupilsNamesTextRectangle

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 80
            Layout.preferredHeight: 100
            Text {
                id: pupilsNamesText
                anchors.centerIn: parent
                font.bold: true
                color: "grey"
                font {
                  family: Style.fontAwesome
                  pixelSize: 12
                }
            }
        }

        Rectangle {
            id: groupNamesRectangle

            Layout.preferredWidth: parent.width - Layout.leftMargin
            Layout.preferredHeight: 80
            Layout.fillHeight: true
            Layout.leftMargin: 40
            border.color: "red"
            border.width: 3

            ListView {
                id: groupNamesListView
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - 10

                model: masterController.ui_groups
                delegate: CheckDelegate {
                    id: groupSelect

                    text: modelData.name
                    width: groupNamesRectangle.width / 2
                }
            }
        }

        Rectangle {
            id: okCancelRectangle

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: okButton.height
            Layout.preferredHeight: Layout.minimumHeight

            ViewButton {
                id: okButton

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: qsTr("Ok")
                onClicked: {
                    var groupList = [];
                    // itemAtIndex(i) is Qt >= 5.13, so we workaround by looping
                    // on the currentIndex to get the information
                    for(var i = 0 ; i < groupNamesListView.count ; ++ i) {
                        groupNamesListView.currentIndex = i;
                        if(groupNamesListView.currentItem.checked) {
                            groupList.push(groupNamesListView.currentItem.text);
                        }
                    }
                    removePupilsToGroupsDialog.accepted(groupList)
                    removePupilsToGroupsDialog.close()
                }
            }

            ViewButton {
                id: cancelButton

                anchors.right: okButton.left
                anchors.bottom: parent.bottom
                text: qsTr("Cancel")

                onClicked: {
                   removePupilsToGroupsDialog.close();
                }
            }
        }
    }
}
