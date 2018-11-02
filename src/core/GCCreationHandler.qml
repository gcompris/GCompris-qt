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
import "qrc:/gcompris/src/core/core.js" as Core

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

    onClose: {
        visible = false
        fileNameInput.text = qsTr("Enter file name")
    }

    property string activityName: ""
    property var dataToSave
    property bool isSaveMode: false
    readonly property string sharedDirectoryPath: ApplicationInfo.getSharedWritablePath() + "/" + activityName + "/"

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

    Loader {
        id: replaceFileDialog
        sourceComponent: GCDialog {
            parent: activity.main
            message: qsTr("A file with this name already exists. Do you want to replace it?")
            button1Text: qsTr("Yes")
            button2Text: qsTr("No")
            onButton1Hit: {
                writeData()
                active = false
            }
            onButton2Hit: active = false
        }
        anchors.fill: parent
        focus: true
        active: false
        onStatusChanged: if (status == Loader.Ready) item.start()
    }

    function refreshWindow() {
        var pathExists = file.exists(sharedDirectoryPath)
        if(!pathExists)
            return

        fileNames.clear()

        var files = directory.getFiles(sharedDirectoryPath)
        for(var i = 2; i < files.length; i++) {
            fileNames.append({ "name": files[i] })
        }
    }

    function loadWindow() {
        creationHandler.visible = true
        creationHandler.isSaveMode = false

        refreshWindow()
    }

    function loadFile(fileName) {
        // Will be modified.
        var data = parser.parseFromUrl("file://" + sharedDirectoryPath + fileName)
        creationHandler.fileLoaded(data)
    }

    function saveWindow(data) {
        creationHandler.visible = true
        creationHandler.isSaveMode = true
        creationHandler.dataToSave = data
        refreshWindow()
    }

    function saveFile() {
        if(activityName === "" || fileNameInput.text === "")
            return

        if(!file.exists(sharedDirectoryPath))
            file.mkpath(sharedDirectoryPath)

        if(file.exists("file://" + sharedDirectoryPath + '/' + fileNameInput.text + ".json")) {
            replaceFileDialog.active = true
        }
        else
            writeData()
    }

    function writeData() {
        file.write(JSON.stringify(creationHandler.dataToSave), "file://" + sharedDirectoryPath + '/' + fileNameInput.text + ".json")
        Core.showMessageDialog(creationHandler,
                               qsTr("Saved successfully!"),
                               "", null, "", null, null);
        refreshWindow()
    }

    function searchFiles() {
        if(fileNameInput.text === "") {
            refreshWindow()
            return
        }

        var pathExists = file.exists(sharedDirectoryPath)
        if(!pathExists)
            return

        fileNames.clear()

        var files = directory.getFiles(sharedDirectoryPath)
        var textToSearch = fileNameInput.text.toLowerCase()

        for(var i = 2; i < files.length; i++) {
            if((files[i].toLowerCase()).indexOf(textToSearch) !== -1)
                fileNames.append({ "name": files[i] })
        }
    }

    Rectangle {
        id: textField
        width: parent.width / 2
        height: saveButton.height
        anchors.verticalCenter: saveButton.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        border.width: 1
        border.color: "black"
        TextInput {
        	id: fileNameInput
        	text: qsTr("Enter file name")
        	font.pointSize: 28
        	anchors.fill: parent
        	verticalAlignment: TextInput.AlignVCenter
        	visible: textField.visible
        	leftPadding: 10
        	selectByMouse: true
            maximumLength: 15
            onTextChanged: {
                if(!creationHandler.isSaveMode)
                    searchFiles()
    	    }
        }
    }

    Button {
        id: saveButton
        width: 50 * ApplicationInfo.ratio
        height: creationHandler.height / 15
        visible: creationHandler.isSaveMode
        text: qsTr("Save")
        style: GCButtonStyle {
            theme: "highContrast"
        }
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.left: textField.right
        anchors.leftMargin: 20
        onClicked: saveFile()
    }

    property real cellWidth: 50 * ApplicationInfo.ratio
    property real cellHeight: cellWidth

    Rectangle {
        id: viewContainer
        anchors.top: cancelButton.bottom
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
                readonly property string fileName: fileName.text
                Item {
                    id: fileIcon
                    width: creationHandler.cellWidth
                    height: parent.height / 1.4
                    Image {
                        source: "qrc:/gcompris/src/core/resource/FileIcon.svg"
                        anchors.fill: parent
                    }
                }

                GCText {
                    id: fileName
                    anchors.top: fileIcon.bottom
                    height: parent.height - parent.height / 1.4
                    width: creationHandler.cellWidth
                    font.pointSize: tinySize
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    // Exclude ".json" while displaying file name
                    text: name.slice(0, name.length - 5)
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
        visible: !creationHandler.isSaveMode
        Button {
            id: loadButton
            width: 70 * ApplicationInfo.ratio
            height: creationHandler.height / 15
            text: "Load"
            style: GCButtonStyle {
                theme: "highContrast"
            }
        }

        Button {
            id: deleteButton
            width: 70 * ApplicationInfo.ratio
            height: creationHandler.height / 15
            text: "Delete"
            style: GCButtonStyle {
                theme: "highContrast"
            }
        }
    }

    GCButtonCancel {
        id: cancelButton
        onClose: {
            parent.close()
        }
    }
}
