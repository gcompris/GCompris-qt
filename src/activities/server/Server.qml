/* GCompris - server.qml
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
/*import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Material 2.1*/

import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Material 2.1


import GCompris 1.0



import "../../core"
import "server.js" as Activity
import "components"

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
            contentFrame.replace("views/DashboardView.qml");
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }


        Connections {
            target: masterController.ui_navigationController
            onGoCreateClientView: contentFrame.replace("views/CreateClientView.qml")
            onGoDashboardView: contentFrame.replace("views/DashboardView.qml")
            onGoEditClientView: contentFrame.replace("views/EditClientView.qml", {selectedClient: client})
            onGoFindClientView: contentFrame.replace("views/FindClientView.qml")
            onGoManagePupilsView: contentFrame.replace("views/ManagePupilsView.qml")
            onGoManageGroupsView: contentFrame.replace("views/ManageGroupsView.qml")
        }


        NavigationBar {
            id: navigationBar
        }


        StackView {
            id: contentFrame
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                left: navigationBar.right
            }
            initialItem: "qrc:/gcompris/src/activities/server/views/SplashView.qml"
            clip: true
        }

/*        Drawer {
               id: drawer

               width: Math.min(background.width, background.height) / 3 * 2
               height: background.height

               ListView {
                   focus: true
                   currentIndex: -1
                   anchors.fill: parent

                   delegate: ItemDelegate {
                       width: parent.width
                       text: model.text
                       highlighted: ListView.isCurrentItem
                       onClicked: {
                           drawer.close()
                           //model.triggered()
                       }
                   }

                   model: ListModel {
                       ListElement {
                           text: qsTr("Open...")
                         //  triggered: { fileOpenDialog.open(); }
                       }
                       ListElement {
                           text: qsTr("About...")
                         //  triggered: function(){ console.log("f"); }
                       }
                   }

                   ScrollIndicator.vertical: ScrollIndicator { }
               }
        }

       ToolBar {
            Material.background: Material.Orange

            anchors.top: parent.top
            anchors.left: parent.left

            ToolButton {
                id: menuButton
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "resource/baseline-menu-24px.svg"
                onClicked: drawer.open()
            }
            Label {
                anchors.centerIn: parent
                text: "Image Viewer"
                font.pixelSize: 20
                elide: Label.ElideRight
            }
        }


        FileDialog {
                id: fileOpenDialog
                title: "Select an image file"
                folder: shortcuts.documents
                nameFilters: [
                    "Image files (*.png *.jpeg *.jpg)",
                ]
                onAccepted: {
                    image.source = fileOpenDialog.fileUrl
                }
            }*/


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
