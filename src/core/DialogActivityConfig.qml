/* GCompris - DialogActivityConfig.qml
 *
 * Copyright (C) 2014 Johnny Jazeix
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
import GCompris 1.0

Rectangle {
    id: dialogActivityContent
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title: {
        if(activityInfo)
        qsTr("%1 configuration").arg(activityInfo.title)
        else
        qsTr("Configuration")
    }
    property alias titleIcon: titleIcon.source
    property alias active: loader.active
    property alias loader: loader
    property alias configItem: loader.item
    property QtObject activityInfo: ActivityInfoTree.currentActivity
    property string activityName: ""

    property var dataToSave

    signal close
    signal start
    signal pause
    signal play
    signal stop
    signal saveData
    signal loadData
    property Component content

    function getInitialConfiguration() {
        if(activityName == "") {
            activityName = ActivityInfoTree.currentActivity.name.split('/')[0];
        }
        dataToSave = ApplicationSettings.loadActivityConfiguration(activityName)
        loadData()
    }

    Row {
        visible: dialogActivityContent.active
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogActivityContent.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                Image {
                    id: titleIcon
                    anchors {
                        left: parent.left
                        top: parent.top
                        margins: 4 * ApplicationInfo.ratio
                    }
                }

                GCText {
                    id: title
                    text: dialogActivityContent.title
                    width: dialogActivityContent.width - 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    fontSize: 20
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogActivityContent.width - 30
                height: dialogActivityContent.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    clip: true
                    contentHeight: contentItem.childrenRect.height + 40 * ApplicationInfo.ratio
                    Loader {
                        id: loader
                        active: false
                        sourceComponent: dialogActivityContent.content
                        property alias rootItem: dialogActivityContent
                    }
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    GCButtonCancel {
        onClose: {
            saveData()
            ApplicationSettings.saveActivityConfiguration(activityName, dataToSave)
            parent.close()
        }
    }

}
