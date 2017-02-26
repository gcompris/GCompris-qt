/* GCompris - Menu.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import "../../core"
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.2

/**
 * GCompris' top level menu screen.
 *
 * Displays a grid of available activities divided subdivided in activity
 * categories/sections.
 *
 * The visibility of the section row is toggled by the setting
 * ApplicationSettings.sectionVisible.
 *
 * The list of available activities depends on the following settings:
 *
 * * ApplicationSettings.showLockedActivities
 * * ApplicationSettings.filterLevelMin
 * * ApplicationSettings.filterLevelMax
 *
 * @inherit QtQuick.Item
 */
ActivityBase {
    id: activity
    focus: true
    activityInfo: ActivityInfoTree.rootMenu
    onBack: {
        pageView.pop(to);
        // Restore focus that has been taken by the loaded activity
        if(pageView.currentItem == activity)
            focus = true;
    }

    onHome: {
        if(pageView.depth === 1) {
            Core.quit(main);
        }
        else {
            pageView.pop();
            // Restore focus that has been taken by the loaded activity
            if(pageView.currentItem == activity)
                focus = true;
        }
    }

    onDisplayDialog: pageView.push(dialog)

    onDisplayDialogs: {
        var toPush = new Array();
        for (var i = 0; i < dialogs.length; i++) {
            toPush.push({item: dialogs[i]});
        }
        pageView.push(toPush);
    }

    // @cond INTERNAL_DOCS
    property string url: "qrc:/gcompris/src/activities/menu/resource/"

    property variant actions: [
        {
            view: "Broadcast",
            text: qsTr("Broadcast")
        },
        {
            view: "Clients",
            text: qsTr("Connected clients")
        },
        {
            view: "Configurations",
            text: qsTr("Configurations")
        },
        {
            view: "ServerConfiguration",
            text: qsTr("Server Configuration")
        },
        {
            view: "Groups",
            text: qsTr("Groups")
        },
        {
            view: "Users",
            text: qsTr("Users")
        },
        {
            view:"ActivityConfiguration",
            text: qsTr("Send Dataset")
        },
        {
            view: "LoginList",
            text: qsTr("Send Login List")

        },
        {
            view: "Results",
            text: qsTr("Activity Results")
        }

    ]

    pageComponent: Image {
        id: background
        source: activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        height: main.height
        fillMode: Image.PreserveAspectCrop

        function loadActivity() {
            // @TODO init of item would be better in setsource but it crashes on Qt5.6
            // https://bugreports.qt.io/browse/QTBUG-49793
            activityLoader.item.loading = loading
            activityLoader.item.menu = activity
            pageView.push(activityLoader.item)
        }

        Loader {
            id: activityLoader
            asynchronous: true
            onStatusChanged: {
                if (status == Loader.Loading) {
                    loading.start();
                } else if (status == Loader.Ready) {
                    loading.stop();
                    loadActivity();
                } else if (status == Loader.Error)
                    loading.stop();
            }
        }

        Loading {
            id: loading
        }

        // Filters
        property bool horizontal: main.width > main.height

        property bool keyboardMode: false
        Keys.onPressed: {
            if(event.key === Qt.Key_Space && actionGrid.currentItem) {
                actionGrid.currentItem.selectCurrentItem()
            }
        }
        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onEnterPressed: actionGrid.currentItem.selectCurrentItem();
        Keys.onReturnPressed: actionGrid.currentItem.selectCurrentItem();
        Keys.onRightPressed: actionGrid.moveCurrentIndexRight();
        Keys.onLeftPressed: actionGrid.moveCurrentIndexLeft();
        Keys.onDownPressed: if(!actionGrid.atYEnd) actionGrid.moveCurrentIndexDown();
        Keys.onUpPressed: if(!actionGrid.atYBeginning) actionGrid.moveCurrentIndexUp();

        GridView {
            id: actionGrid
            model: actions
            width: main.width
            height: main.height

            interactive: false
            keyNavigationWraps: true
            property int initialX: 4
            property int initialY: 4

            cellWidth: width
            cellHeight: 80
            Component {
                id: actionDelegate
                Button {
                    id: backgroundAction
                    style: GCButtonStyle {}
                    onClicked: {
                        selectCurrentItem()
                    }
                    text: modelData.text
                    function selectCurrentItem() {
                        if(modelData.view === "Broadcast") {
                            print("sending broadcast to find clients")
                            Server.broadcastDatagram()
                        }
                        else if(modelData.view === "ActivityConfiguration") {
                            Server.sendConfiguration()
                        }
                        else if(modelData.view === "LoginList") {
                            login.visible = true

                        }

                        else {
                            activityLoader.setSource("qrc:/gcompris/src/server/views/" + modelData.view + ".qml", {})
                            print("select: " + text + " - load " + activityLoader.source)
                            if (activityLoader.status == Loader.Ready) loadActivity()
                        }
                    }
                }
            }

            delegate: actionDelegate
            highlight: Item {
                width: actionGrid.cellWidth
                height: actionGrid.cellHeight

                Rectangle {
                    anchors.fill: parent
                    color:  "#99FFFFFF"
                }
                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    anchors.fill: parent
                }
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        Bar {
            id: bar
            // No exit button on mobile, UI Guidelines prohibits it
            content: BarEnumContent {
                value: help | about | (ApplicationInfo.isMobile ? 0 : exit)
            }
            anchors.bottom: parent.bottom
            onAboutClicked: {
                displayDialog(dialogAbout)
            }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }

            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.loader.item.loadFromConfig()
                displayDialog(dialogActivityConfig)
            }
        }
    }

    DialogAbout {
        id: dialogAbout
        onClose: home()
    }

    DialogHelp {
        id: dialogHelp
        onClose: home()
        activityInfo: ActivityInfoTree.rootMenu
    }
    Item {
        id: login
        visible: false
        width: parent.width/3
        height: parent.height/2
        anchors.centerIn:  parent
        property string mode: ""
        Rectangle {
            id: loginRect
            anchors.fill: parent
            color: "black"
            opacity: 0.4
            Button {
                id: chooseGroups
                width: parent.width/1.5
                style: GCButtonStyle {
                    theme: "highContrast"
                }
                text: qsTr("Choose Groups")
                height: parent.height/4
                anchors.top: parent.top
                anchors.topMargin: height
                anchors.horizontalCenter:  parent.horizontalCenter

            }
            Button {
                id: sendToAll
                width: parent.width/1.5
                height: parent.height/4
                anchors.horizontalCenter:  parent.horizontalCenter
                text: qsTr("Send to all")
                anchors.top: chooseGroups.bottom
                anchors.topMargin: height/2
                style: GCButtonStyle {
                    theme: "highContrast"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        // show the confirmation box
                        confirmationBox.visible = true
                        login.visible = false
                        login.mode = "sendtoall"
                    }
                }
            }
        }
        GCButtonCancel {
            id: cancel
            anchors.left: login.right
            anchors.right: undefined
            anchors.top: undefined
            visible: login.visible
            anchors.bottom: login.top
            onClose: {
                login.visible = false
            }
        }

    }
    Rectangle {
        id: confirmationBox
        width: parent.width/2
        height: parent.height/4
        anchors.centerIn: parent
        color: "black"
        opacity: 0.4
        visible: false
        GCText {
            text: {
                if (login.mode === "sendtoall")
                    return "Are you sure you want to send  login list to all the clients ?"

                else
                    return ""
            }
            color: "black"
            font.bold: true
            width: parent.width
            font.weight: Font.ExtraBold
            wrapMode: Text.Wrap
            font.pixelSize: 25
            anchors.centerIn: parent
        }

        Button {
            id: yes
            anchors.bottom: parent.bottom
            height: parent.height/5
            width: parent.width/2
            style: GCButtonStyle {
                theme: "highContrast"
            }
            text: qsTr("YES")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        if (login.mode === "sendtoall")
                        {
                            Server.sendLoginList()
                        }
                        confirmationBox.visible = false

                    }
                }
        }
        Button {
            id: no
            anchors.bottom: parent.bottom
            height: parent.height/5
            anchors.left: yes.right
            width: parent.width/2
            style: GCButtonStyle {
                theme: "highContrast"
            }

            text: qsTr("NO")
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    login.visible = true
                    confirmationBox.visible = false
                }
            }
        }
    }

}
