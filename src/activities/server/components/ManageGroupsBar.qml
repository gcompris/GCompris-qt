import QtQuick 2.9
import QtQuick.Layouts 1.12
//import QtQuick.Controls 1.4
import "../../../core"
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.3

import "../components"

import "../server.js" as Activity

Item {
    id: pupilsNavigationBarItem
    property bool isCollapsed: true
    property int groupTextMargin: 30

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
    }
    width: Style.widthNavigationButton

    Rectangle {
        id: pupilsNavigationRectangle
        width: parent.width
        height: parent.height
        color: Style.colourBackground
        border.width: 1
        border.color: "lightgrey"

        ColumnLayout{
            id: groupNames

            spacing: 2
            anchors.top: parent.top
            width: parent.width - 10


            //groups header
            Rectangle {

                id: test
                height: 60
                width: parent.width

                RowLayout {
                    width: parent.width
                    height: parent.height

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsNavigationRectangle.width/5
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Style.colourNavigationBarBackground
                            font {
                                family: Style.fontAwesome
                                pixelSize: Style.pixelSizeNavigationBarIcon/2
                            }
                            text: "\uf0c0"
                            font.bold: true
                            leftPadding: 20
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        implicitHeight: 60
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            leftPadding: 10
                            topPadding: 20
                            text: qsTr("Groups")
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                        }
                    }
                }
            }






            //groups names
            Repeater {
                id: groupsNamesRepeater
                model: Activity.groupsNamesArray

                Rectangle {
                    width: groupNames.width
                    Layout.preferredHeight: 40

                    RowLayout {
                        width: pupilsNavigationRectangle.width - 10
                        height: 40

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsNavigationRectangle.width/5
                            Text {
                                text: "\uf054"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 20
                                color: "grey"
                                font {
                                    family: Style.fontAwesome
                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                }
                            }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            height: 40
                            Text {
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                color: "grey"
                                leftPadding: 5
                                elide: Text.ElideRight
                            }
                        }
                        Rectangle {
                            id: elipsis
                            Layout.minimumWidth: pupilsNavigationRectangle.width/5
                            Layout.fillHeight: true
                            height: 40
                            Text {
                                id: elipsisText
                                text: "\uf142"   //elipsis-v
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "grey"
                                font {
                                    family: Style.fontAwesome
                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2    //? see with style
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    elipsisText.color = Style.colourNavigationBarBackground
                                   /* modifyGroupCommandsRectangle.anchors.right = parent.anchors.right
                                    modifyGroupCommandsRectangle.anchors.top = parent.anchors.top
                                    modifyGroupCommandsRectangle.height = parent.height
                                    modifyGroupCommandsRectangle.width = 50*/
                                    //modifyGroupCommandsRectangle.focus = true
                                    //modifyGroupCommandsRectangle.visible = true

                                    modifyGroupCommandsRectangle.open()


                                }
                                onEntered: { elipsisText.color = Style.colourNavigationBarBackground
                                modifyGroupCommandsRectangle.visible = true }
                                onExited: { elipsisText.color = "grey"
                                    modifyGroupCommandsRectangle.visible = false
                                }


                                Rectangle {
                                    id: modifyGroupCommandsRectangle

                                    anchors.centerIn: parent
                                    visible: false
                                    height: parent.height
                                    width: 100
                                  //  focus: true
                                  //  modal: true




                                    RowLayout {
                                        width: pupilsNavigationRectangle.width/3
                                        height: parent.height
                                        //anchors.fill: parent

                                        Rectangle {
                                            id: editIconRectangle
                                            Layout.preferredWidth: 30
                                            Layout.preferredHeight: editIcon.height


                                            color: "red"
                                            Text {
                                                id: editIcon
                                                //anchors.verticalCenter: parent.verticalCenter
                                                //anchors.horizontalCenter: parent.horizontalCenter
                                                text: "\uf304"
                                                color: "grey"
                                                font {
                                                    family: Style.fontAwesome
                                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                                }
                                            }
                                            MouseArea {
                                               anchors.fill: parent
                                               hoverEnabled: true
                                               onClicked: {
                                                   addAGroupText.color = Style.colourNavigationBarBackground
                                                   addGroupDialog.open()
                                                   console.log("clicked ...")
                                               }
                                             //  onEntered: { editIconRectangle.color = Style.colourNavigationBarBackground }
                                             //  onExited: { editIconRectangle.color = Style.colourBackground }
                                            }
                                        }
                                        Rectangle {
                                            Layout.preferredWidth: 30
                                            Layout.preferredHeight: editIcon.height

                                            Text {
                                                id: trashIcon
                                                //anchors.verticalCenter: parent.verticalCenter
                                                //anchors.horizontalCenter: parent.horizontalCenter
                                                text: "\uf2ed"
                                                color: "grey"
                                                font {
                                                    family: Style.fontAwesome
                                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                                }
                                            }
                                            MouseArea {
                                               anchors.fill: parent
                                               hoverEnabled: true
                                               onClicked: {
                                                   addAGroupText.color = Style.colourNavigationBarBackground
                                                   addGroupDialog.open()
                                                   console.log("clicked ...")
                                               }
                                            //   onEntered: { editIconRectangle.color = Style.colourNavigationBarBackground }
                                            //   onExited: { editIconRectangle.color = Style.colourBackground }
                                            }
                                        }
                                    }

                                }


                            }




                        }
                    }

                }
            }
        }

        Rectangle {
            id: addAGroupLabelRectangle

            anchors.top: groupNames.bottom
            anchors.left: parent.left

            width: parent.width - 10
            height: 40

            Text {
                id: addAGroupText
                text: "\uf067" + qsTr("Add a group")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5
                color: "grey"
                font {
                    family: Style.fontAwesome
                    pixelSize: Style.pixelSizeNavigationBarIcon / 3   //? see with style
                }         
            }

            MouseArea {
               anchors.fill: parent
               hoverEnabled: true
               onClicked: {
                   addAGroupText.color = Style.colourNavigationBarBackground
                   addGroupDialog.open()
                   console.log("clicked ...")
               }
               onEntered: { addAGroupText.color = Style.colourNavigationBarBackground }
               onExited: { addAGroupText.color = "grey" }
            }

            Popup {
                id: addGroupDialog

                anchors.centerIn: Overlay.overlay
                width: 600
                height: 200
                modal: true
                focus: true
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                Text {
                    id: addGroupDialogText

                    x: parent.width / 10
                    y: parent.height / 8
                    text: qsTr("Add a group name")
                    font.bold: true
                    font {
                        family: Style.fontAwesome
                        pixelSize: 20
                    }
                }

                TextInput {
                    id: groupNamesTextInput

                    x: parent.width / 10
                    y: parent.height / 3
                    text: qsTr("Group name")
                    cursorVisible: false
                    font {
                        family: Style.fontAwesome
                        pixelSize: 20
                    }
                    selectByMouse: true
                    focus: true

                    Component.onCompleted: groupNamesTextInput.selectAll()

                }

                Rectangle {
                    id: groupNameTextInputRectangle

                    anchors.top: groupNamesTextInput.bottom
                    anchors.left: groupNamesTextInput.left
                    width: addGroupDialog.width * 4/6
                    height: 3
                    color: Style.colourNavigationBarBackground
                }

                ViewButton {
                    id: saveButton

                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    text: qsTr("Save")
                    onClicked: {
                       console.log("save...")
                       Activity.groupsNamesArray.push(groupNamesTextInput.text)
                       console.log(Activity.groupsNamesArray)
                       groupsNamesRepeater.model = Activity.groupsNamesArray

                       addGroupDialog.close();
                    }
                }

                ViewButton {
                    id: cancelButton

                    anchors.right: saveButton.left
                    anchors.bottom: parent.bottom
                    text: qsTr("Cancel")

                    onClicked: {
                       console.log("cancel...")
                       addGroupDialog.close();
                    }
                }
            }
        }
    }
}
