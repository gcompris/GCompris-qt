/* GCompris - DevicesView.qml
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import CM 1.0

import "../components"
import "../../core"

Item {
    id: devicesView

    TopBanner {
        id: topBanner
        text: qsTr("Connect devices")
    }

    ManageGroupsBar {
        id: pupilsNavigationBar
        anchors.top: topBanner.bottom
    }

    Rectangle {
        id: devicesViewRectangle
        anchors.left: pupilsNavigationBar.right
        anchors.top: topBanner.bottom
        anchors.bottom: parent.bottom
        width: devicesView.width / 2

        ColumnLayout {
            id: pupilsDetailsColumn

            spacing: 2
            anchors.top: parent.top
            width: parent.width

            property int pupilNameColWidth : pupilsDetailsColumn.width / 3

            //pupils header
            Rectangle {
                id: pupilsHeaderRectangle

                height: 60
                width: parent.width

                Rectangle {
                    id: pupilNameHeader
                    width: devicesViewRectangle.width - 10
                    height: parent.height
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: Style.colourNavigationBarBackground
                        text: qsTr("Pupils Names")
                        font.bold: true
                        leftPadding: 60
                        topPadding: 20
                    }
                }
            }

            //pupils data
            Repeater {
                id: pupilsDetailsRepeater

                model: masterController.ui_users

                Rectangle {
                    id: pupilDetailsRectangle

                    property alias pupilNameCheckBox: pupilNameCheckBox

                    property bool editPupilRectangleVisible: false
                    property bool optionsPupilRectangleVisible: false

                    width: devicesViewRectangle.width
                    height: 40

                    border.color: "green"
                    border.width: 5

                    MouseArea {
                        id: pupilDetailsRectangleMouseArea
                        anchors.right: pupilDetailsRectangle.right
                        anchors.top: pupilDetailsRectangle.top
                        height: pupilDetailsRectangle.height
                        width: parent.width

                        hoverEnabled: true
                        onEntered: {
                            pupilDetailsRectangle.color = Style.colourPanelBackgroundHover
                            pupilDetailsRectangle.editPupilRectangleVisible = true
                            pupilDetailsRectangle.optionsPupilRectangleVisible = true

                        }
                        onExited: {
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
                                    text: modelData.name
                                    anchors.verticalCenter: parent.verticalCenter
                                    leftPadding: 20
                                }
                            }

                            Rectangle {
                                id: pupilStatus
                                Layout.alignment: Qt.AlignLeft
                                height: parent.height - 10
                                Layout.minimumWidth: height
                                radius: width/2
                                border.color: "black"
                                color: modelData.status == ConnectionStatus.NOT_CONNECTED ? "white" :
                                       modelData.status == ConnectionStatus.BAD_PASSWORD_INPUTTED ? "yellow" :
                                       modelData.status == ConnectionStatus.CONNECTED ? "green" :
                                       modelData.status == ConnectionStatus.ALREADY_CONNECTED ? "red" :
                                       modelData.status == ConnectionStatus.DISCONNECTED ? "grey" : "red"
                            }
                        }
                    }
                }
            }
        }
        Column {
            anchors.left: devicesViewRectangle.right
            anchors.right: parent.right
            Label {
                text: qsTr("Broadcast ip")
            }
            TextInput {
                id: broadcastIpText
                // todo set default from conf, get a list of possible ip from https://doc.qt.io/qt-5/qnetworkinterface.html?
                text: "255.255.255.255"
            }

            Label {
                text: qsTr("Device id")
            }
            TextInput {
                id: deviceIdText
                text: "test"
            }

            ViewButton {
                id: connectDevicesButton

                text: qsTr("Connect devices")

                onClicked: {
                    networkController.broadcastDatagram(broadcastIpText.text, deviceIdText.text);
                }
            }
            ViewButton {
                id: loginListButton

                text: qsTr("Send login list")

                onClicked: {
                    var users = masterController.ui_users;
                    var usersList = [];
                    for(var i = 0 ; i < users.length; ++ i) {
                        if(users[i].status != ConnectionStatus.CONNECTED && users[i].status != ConnectionStatus.ALREADY_CONNECTED) {
                            usersList.push(users[i].name);
                        }
                    }

                    networkController.sendLoginList(usersList);
                }
            }
            ViewButton {
                id: disconnectButton

                text: qsTr("Disconnect selected pupils")

                onClicked: {
                    var usersList = [];
                    for(var i = 0 ; i < pupilsDetailsRepeater.count ; ++ i) {
                        if(pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.checked) {
                            usersList.push(pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.text);
                        }
                    }
                    networkController.disconnectSession(usersList);
                }
            }
            ViewButton {
                id: disconnectAllButton

                text: qsTr("Disconnect everybody")

                onClicked: {
                    var usersList = [];
                    for(var i = 0 ; i < pupilsDetailsRepeater.count ; ++ i) {
                        usersList.push(pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.text);
                    }
                    networkController.disconnectSession(usersList);
                }
            }
        }
    }
}
