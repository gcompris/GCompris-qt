import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import CM 1.0
import "../components"
import "../../../core"
import QtQuick.Controls 2.2
import "."
import "../server.js" as Activity



Item {
    id: managePupilsView


    signal pupilsNamesListSelected(var pupilsNamesList)


    Connections {
        target: masterController.ui_navigationController
        onGoAddPupilDialog: addPupilDialog.open()
        onGoAddPupilsFromListDialog: addPupilsFromListDialog.open()
        onGoRemovePupilsDialog: removePupilsDialog.open()
    }


    ListView {
        id: selectedPupilsListview
    }


    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            anchors.centerIn: parent
            text: "Manage Pupils View"
        }
    }

    TopBanner {
        id: topBanner

        text: "Groups and pupils management"
    }

    ManageGroupsBar {
        id: pupilsNavigationBar

        anchors.top: topBanner.bottom
    }

    Rectangle {
        id: managePupilsViewRectangle

        anchors.left: pupilsNavigationBar.right
        anchors.top: topBanner.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: managePupilsView.width  - pupilsNavigationBar.width

        //color: "red"


        ColumnLayout{
            id: pupilsDetailsColumn

            spacing: 2
            anchors.top: parent.top
            width: parent.width

            property int pupilNameColWidth : pupilsDetailsColumn.width/3
            property int yearOfBirthColWidth : pupilsDetailsColumn.width/8


            //pupils header
            Rectangle {
                id: pupilsHeaderRectangle

                height: 60
                width: parent.width


                RowLayout {
                    width: managePupilsViewRectangle.width - 10
                    height: parent.height

                    Rectangle {
                        id: pupilNameHeader
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: Style.colourNavigationBarBackground
                            text: "Pupils Names"
                            font.bold: true
                            leftPadding: 60
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        id: yearOfBirthHeader
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth     //any way to find "year of birth text width" if translations ?
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Year of Birth"
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        id: pupilGroupsHeader
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            leftPadding: 10
                            text: "Groups"
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                            topPadding: 20
                        }
                    }
                }
            }

            //pupils data
            Repeater {
                id: pupilsDetailsRepeater

                model: Activity.pupilsNamesArray

                Rectangle {
                    id: pupilDetailsRectangle

                    //property alias pupilNameCheckBox: pupilDetailsRectangle.pupilDetailsRectangleMouseArea.pupilDetailsRectangleRowLayout.pupilName.pupilNameCheckBox

                    property alias pupilNameCheckBox: pupilNameCheckBox

                    property bool editPupilRectangleVisible: false
                    property bool optionsPupilRectangleVisible: false

                    width: managePupilsViewRectangle.width
                    height: 40

                    border.color: "green"
                    border.width: 5

                    MouseArea {
                        id: pupilDetailsRectangleMouseArea
                        anchors.right: pupilDetailsRectangle.right //right: pupilCommandOptions.right
                        anchors.top: pupilDetailsRectangle.top
                        height: pupilDetailsRectangle.height
                        width: parent.width

                        hoverEnabled: true
                        onEntered: {    //modifyPupilCommandsRectangle.visible = true
                                        pupilDetailsRectangle.color = Style.colourPanelBackgroundHover
                                        pupilDetailsRectangle.editPupilRectangleVisible = true
                                        pupilDetailsRectangle.optionsPupilRectangleVisible = true

                        }
                        onExited: {
                                        ///modifyPupilCommandsRectangle.visible = false
                                        pupilDetailsRectangle.color = Style.colourBackground
                                        pupilDetailsRectangle.editPupilRectangleVisible = false
                                        pupilDetailsRectangle.optionsPupilRectangleVisible = false
                        }

                        RowLayout {
                            id: pupilDetailsRectangleRowLayout

                            width: parent.width
                            height: 40

                            Rectangle {
                                id: pupilName
                                Layout.alignment: Qt.AlignLeft
                                Layout.fillHeight: true
                                Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                                color: "transparent"
                                CheckBox {
                                    id: pupilNameCheckBox
                                    text: modelData[0]
                                    anchors.verticalCenter: parent.verticalCenter
                                    leftPadding: 20
                                }
                            }
                            Rectangle {
                                id: yearOfBirth
                                Layout.fillHeight: true
                                Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth   //any way to find "year of birth text width" if translations ?
                                color: "transparent"
                                Text {
                                    id: yearText
                                    text: modelData[1]
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: "grey"
                                }
                            }
                            Rectangle {
                                id: groups
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                height: 40
                                color: "transparent"
                                Text {
                                    id: groupsText
                                    text: modelData[2]
                                    leftPadding: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "grey"
                                }
                            }
                            Rectangle {
                                id: editPupilRectangle
                                Layout.minimumWidth: 50
                                //Layout.alignment: Qt.AlignRight
                                Layout.fillHeight: true
                                height: 40

                                visible: pupilDetailsRectangle.editPupilRectangleVisible
                                color: "transparent"
                                Text {
                                    id: editIcon
                                    text: "\uf304"
                                    anchors.centerIn: parent
                                    color: "grey"
                                    font {
                                       family: Style.fontAwesome
                                       pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                    }
                                }
                                MouseArea {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    height: parent.height
                                    width: parent.width

                                    //anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: {    //modifyPupilCommandsRectangle.visible = true
                                                    editIcon.color = Style.colourNavigationBarBackground //Style.colourPanelBackgroundHover
                                                    //pupilDetailsRectangle.editPupilRectangleVisible = true
                                                    //pupilDetailsRectangle.optionsPupilRectangleVisible = true
                                                    print("sdfsfsdf")
                                    }
                                    onExited: {
                                                    ///modifyPupilCommandsRectangle.visible = false
                                                    editIcon.color = Style.colourCommandBarFontDisabled //Style.colourBackground
                                                    //pupilDetailsRectangle.editPupilRectangleVisible = false
                                                    //pupilDetailsRectangle.optionsPupilRectangleVisible = false
                                    }
                                    onClicked: {
                                        modifyPupilDialog.pupilName = modelData[0]
                                        modifyPupilDialog.groupsNames = modelData[2]
                                        modifyPupilDialog.pupilsListIndex = index
                                        modifyPupilDialog.open()
                                    }
                               }
                            }
                            Rectangle {
                                id: optionsPupilRectangle
                                Layout.minimumWidth: 50
                                Layout.alignment: Qt.AlignRight
                                Layout.fillHeight: true
                                height: 40

                                visible: pupilDetailsRectangle.optionsPupilRectangleVisible
                                color: "transparent"
                                Text {
                                    id: optionsIcon
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
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    height: parent.height
                                    width: parent.width

                                    hoverEnabled: true
                                    onClicked: {
                                        modifyPupilGroupsDialog.open()
                                    }

                                    onEntered: {
                                        //modifyPupilCommandsRectangle.visible = true
                                        optionsIcon.color = Style.colourNavigationBarBackground //Style.colourPanelBackgroundHover
                                        //pupilDetailsRectangle.editPupilRectangleVisible = true
                                        //pupilDetailsRectangle.optionsPupilRectangleVisible = true
                                        print("sdfsfsdf")

                                    }
                                    onExited: {
                                        ///modifyPupilCommandsRectangle.visible = false
                                        optionsIcon.color = Style.colourCommandBarFontDisabled //Style.colourBackground
                                        //pupilDetailsRectangle.editPupilRectangleVisible = false
                                        //pupilDetailsRectangle.optionsPupilRectangleVisible = false
                                    }
                               }
                            }
                        }
                    }

                    ModifyPupilGroupsDialog {
                        id: modifyPupilGroupsDialog
                    }

                    AddModifyPupilDialog {
                        id: modifyPupilDialog

                        label: qsTr("Modify the name or the groups")

                        onAccepted: {
                            pupilsDetailsRepeater.model = Activity.pupilsNamesArray
                            //pupilDetailsRectangle.update()  //? does not work
                        }
                    }
                }
            }
        }
    }

    CommandBar {
        commandList: masterController.ui_commandController.ui_managePupilsViewContextCommands
    }


    AddModifyPupilDialog {
        id: addPupilDialog

        label: qsTr("Add pupil name and its group(s)")

        onAccepted: {
            pupilsDetailsRepeater.model = Activity.pupilsNamesArray
        }


    }


    AddPupilsFromListDialog {
        id: addPupilsFromListDialog

        onPupilsDetailsAdded: {
            pupilsDetailsRepeater.model = Activity.pupilsNamesArray
        }

    }

    RemovePupilsDialog {
        id: removePupilsDialog

        onOpened: {
            var pupilsNamesList = []
            for(var i = 0 ; i < pupilsDetailsRepeater.count ; i ++) {
                if (pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.checked === true) {
                    console.log("test" + pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.text)
                    pupilsNamesList.push(pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.text)
                }
            }
            console.log(pupilsNamesList)
            managePupilsView.pupilsNamesListSelected(pupilsNamesList)
            var pupilsNamesListStr = ""
            for(i = 0 ; i < pupilsNamesList.length ; i++) {
                console.log("++--------" + pupilsNamesList[i])

                pupilsNamesListStr = pupilsNamesListStr + pupilsNamesList[i] + "\r\n"
            }

            pupilsNamesText.text = pupilsNamesListStr

            console.log("----------")
            console.log(pupilsNamesListStr)

        }

        onAccepted: {
            var pupilsNamesToRemoveList = []
            for(var i = pupilsDetailsRepeater.count-1; i >= 0; i--) {
                if (pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.checked === true) {
                    Activity.pupilsNamesArray.splice(i,1)

                    console.log("removed" + pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.text)
                }
            }
            pupilsDetailsRepeater.model = Activity.pupilsNamesArray
        }

    }
}
