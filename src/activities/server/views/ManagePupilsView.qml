import QtQuick 2.12
import QtQuick.Layouts 1.12

import CM 1.0
import "../components"
import "../../../core"
import QtQuick.Controls 2.2
import "."



Item {

  //  property Client newClient: masterController.ui_newClient

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
    }

    PupilsNavigationBar {
        id: pupilsNavigationBar

        anchors.top: topBanner.bottom

    }

    Rectangle {
        id: managePupilsViewRectangle

        anchors.left: pupilsNavigationBar.right
        anchors.top: topBanner.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        //color: "red"

        ColumnLayout{
            id: pupilsDetailsColumn

            spacing: 2
            anchors.top: parent.top
            width: parent.width - 10

            property int pupilNameColWidth : pupilsDetailsColumn.width/3
            property int yearOfBirthColWidth : pupilsDetailsColumn.width/8


            //groups header
            Rectangle {
                id: test

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
                            leftPadding: 20
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

            //groups names
            Repeater {
                id: repeater
                model: [["Thomas petit","2004","CP, CE1, CE2"],["Georges Grand","2007","CE1, CE2, CM1"]]

                Rectangle {
                    width: parent.width
                    Layout.preferredHeight: 40

                    RowLayout {
                        width: managePupilsViewRectangle.width - 10
                        height: 40

                        Rectangle {
                            id: pupilName
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                            Text {
                                text: modelData[0]
                                //anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 20
                                color: "grey"
                            }
                        }
                        Rectangle {
                            id: yearOfBirth
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth   //any way to find "year of birth text width" if translations ?
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
                            Text {
                                id: elipsisText
                                text: modelData[2]
                                leftPadding: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: "grey"
                            }
                        }
                    }
                }
            }
        }


    }


/*    ScrollView {
        id: scrollView
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            //bottom: commandBar.top
            margins: Style.sizeScreenMargin
        }
        clip: true

        Column {
            spacing: Style.sizeScreenMargin
            width: scrollView.width

            Panel {
                headerText: "Client Details"
                contentComponent:
                    Column {
                        spacing: Style.sizeControlSpacing
                        StringEditorSingleLine {
                            stringDecorator: newClient.ui_reference
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }
                        StringEditorSingleLine {
                            stringDecorator: newClient.ui_name
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }
                    }
            }
            AddressEditor {
                address: newClient.ui_supplyAddress
                headerText: "Supply Address"
            }
            AddressEditor {
                address: newClient.ui_billingAddress
                headerText: "Billing Address"
            }
        }
    }


    CommandBar {
        commandList: masterController.ui_commandController.ui_createClientViewContextCommands
    }*/
}
