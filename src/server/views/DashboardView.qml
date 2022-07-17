/* GCompris - DashboardView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../components"
import "../../core"

Item {
    id: dashboardView

    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        ColumnLayout {
            anchors.centerIn: parent
            Image {
                source: 'qrc:/gcompris/src/core/resource/gcompris.png'
                Layout.alignment: Qt.AlignCenter
            }
            Image {
                source: 'qrc:/gcompris/src/core/resource/aboutkde.png'
                Layout.alignment: Qt.AlignCenter
            }
            Text {
                id: loginLabel
                Layout.preferredHeight: 20
                Layout.preferredWidth: parent.width
                text: qsTr("Login")
                font.bold: true
                font {
                    family: Style.fontAwesome
                    pixelSize: 15
                }
            }
            UnderlinedTextInput {
                id: login
                Layout.preferredHeight: 20
                Layout.preferredWidth: parent.width
                defaultText: "tata"
            }
            Text {
                id: passwordLabel
                Layout.preferredHeight: 20
                Layout.preferredWidth: parent.width
                text: qsTr("Password")
                font.bold: true
                font {
                    family: Style.fontAwesome
                    pixelSize: 15
                }
            }
            UnderlinedTextInput {
                id: password
                Layout.preferredHeight: 20
                Layout.preferredWidth: parent.width
                echoMode: TextInput.Password
                defaultText: "tata"
            }
            RowLayout {
                ViewButton {
                    id: connectTeacher
                    text: qsTr("Connect")
                    onClicked: {
                        if(masterController.ui_databaseController.checkTeacher(login.text, password.text)) {
                            print("good boy")
                            masterController.ui_navigationController.teacherConnected();
                        }
                        else {
                            print("Either login does not exist or incorrect password")
                        }
                    }
                }
                ViewButton {
                    id: createTeacher
                    text: qsTr("Create login")
                    onClicked: {
                        print("Create teacher");
                        masterController.ui_databaseController.createTeacher(login.text, password.text);
                    }
                }
            }
        }
    }
}
