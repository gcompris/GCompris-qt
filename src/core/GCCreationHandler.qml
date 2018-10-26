/* GCompris - GCCreationHandler.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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

import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0

Rectangle {
    id: creationHandler

    width: parent.width
    height: parent.height
    color: "yellow"
    border.color: "black"
    border.width: 2
    radius: 20
    visible: false
    z: 2000

    signal close
    signal fileLoaded(var data)

    onClose: visible = false

    property string activity_name: ""
    readonly property string sharedDirectoryPath: ApplicationInfo.getSharedWritablePath() + "/" + activity_name + "/"

    ListModel {
        id: fileNames
    }

    Directory {
        id: directory
    }

    File {
        id: file
        onError: console.error("File error: " + msg);
    }

    JsonParser {
        id: parser
        onError: console.error("Error parsing JSON: " + msg);
    }

    function open(activity_name) {
        creationHandler.activity_name = activity_name
        var pathExists = file.exists(sharedDirectoryPath)
        console.log(pathExists)
        if(!pathExists)
            return

        var files = directory.getFiles(sharedDirectoryPath)
        for(var i = 2; i < files.length; i++) {
            console.log(files[i])
            fileNames.append({ "name": files[i] })
        }
    }

    function loadFile(fileName) {
        // Will be modified.
        var data = parser.parseFromUrl("file://" + sharedDirectoryPath + fileName)
        creationHandler.fileLoaded(data)
    }

    property real cellWidth: viewContainer.width / 10
    property real cellHeight: viewContainer.height / 10

    Rectangle {
        id: viewContainer
        anchors.top: cancel.bottom
        anchors.bottom: buttonRow.top
        anchors.margins: 20
        border.color: "black"
        border.width: 2
        radius: 20
        anchors.left: parent.left
        anchors.right: parent.right

        GridView {
            id: creationsList
            model: fileNames
            width: parent.width
            height: parent.height
            interactive: true
            cellHeight: creationHandler.cellHeight
            cellWidth: creationHandler.cellWidth

            delegate: Item {
                height: creationHandler.cellHeight
                width: creationHandler.cellWidth
                readonly property string fileName: txt.text
                Item {
                    id: fileIcon
                    width: creationHandler.cellWidth
                    height: parent.height / 1.4
                    Image {
                        source: "qrc:/gcompris/src/core/resource/FileIcon.svg"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Text {
                    id: txt
                    anchors.top: fileIcon.bottom
                    height: parent.height - parent.height / 1.4
                    width: creationHandler.cellWidth
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: name
                }
            }
        }
    }

    Row {
        id: buttonRow
        x: parent.width / 20
        spacing: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        Button {
            id: loadButton
            width: creationHandler.width / 15
            height: creationHandler.height / 15
            text: "Load"
            style: GCButtonStyle {
                theme: "highContrast"
            }
        }

        Button {
            id: deleteButton
            width: creationHandler.width / 15
            height: creationHandler.height / 15
            text: "Delete"
            style: GCButtonStyle {
                theme: "highContrast"
            }
        }
    }

    GCButtonCancel {
        id: cancel
        onClose: parent.close()
    }
}
