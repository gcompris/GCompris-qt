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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0
import QtQuick.Controls.Styles 1.4
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: creationHandler

    width: parent.width
    height: parent.height
    color: "#ABCDEF"
    border.color: "white"
    border.width: 2
    radius: 20
    visible: false
    z: 2000
    focus: true

    onVisibleChanged: {
        if(visible) {
            creationHandler.forceActiveFocus();
            parent.Keys.enabled = false;
            dialogOpened = false;
        } else {
            parent.Keys.enabled = true;
            parent.forceActiveFocus();
        }
    }

    signal close
    signal fileLoaded(var data, var filePath)

    onClose: {
        fileNameInput.focus = false
        fileNameInput.text = ""
        visible = false
        viewContainer.selectedFileIndex = -1
        creationsList.flick(0, 1400)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: viewContainer.selectedFileIndex = -1
    }


    property var dataToSave
    property bool isSaveMode: false
    property bool dialogOpened: false
    readonly property string activityName: ActivityInfoTree.currentActivity.name.split('/')[0]
    readonly property string sharedDirectoryPath: ApplicationSettings.userDataPath + "/" + activityName + "/"
    readonly property string fileSavePath: "file://" + sharedDirectoryPath + '/' + fileNameInput.text + ".json"

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

    Timer {
        id: restoreFocusTimer
        interval: 500
        onTriggered: {
            dialogOpened = false;
        }
    }

    Timer {
        id: writeDataTimer
        interval: 500
        onTriggered:  {
            writeData();
        }
    }

    function refreshWindow(filterText) {
        var pathExists = file.exists(sharedDirectoryPath)
        if(!pathExists)
            return

        fileNames.clear()

        var files = directory.getFiles(sharedDirectoryPath)
        for(var i = 0; i < files.length; i++) {
            if(filterText === undefined || filterText === "" ||
              (files[i].toLowerCase()).indexOf(filterText) !== -1)
                fileNames.append({ "name": files[i] })
        }
    }

    function loadWindow() {
        creationHandler.visible = true
        creationHandler.isSaveMode = false
        fileNameInput.forceActiveFocus()
        refreshWindow()
    }

    function loadFile(fileName) {
        var filePath = "file://" + sharedDirectoryPath + fileNames.get(viewContainer.selectedFileIndex).name
        var data = parser.parseFromUrl(filePath)
        creationHandler.fileLoaded(data, filePath)
        creationHandler.close()
    }

    function deleteFile() {
        dialogOpened = true;
        var filePath = "file://" + sharedDirectoryPath + fileNames.get(viewContainer.selectedFileIndex).name
        if(file.rmpath(filePath)) {
            Core.showMessageDialog(creationHandler,
                                   qsTr("%1 deleted successfully!").arg(filePath),
                                   qsTr("Ok"), null, "", null, function() { restoreFocusTimer.restart(); });
        }
        else {
            Core.showMessageDialog(creationHandler,
                                   qsTr("Unable to delete %1!").arg(filePath),
                                   qsTr("Ok"), null, "", null, function() { restoreFocusTimer.restart(); });
        }

        viewContainer.selectedFileIndex = -1
        refreshWindow()
    }

    function saveWindow(data) {
        creationHandler.visible = true
        creationHandler.isSaveMode = true
        creationHandler.dataToSave = data
        fileNameInput.forceActiveFocus()
        refreshWindow()
    }

    function saveFile() {
        if(activityName === "" || fileNameInput.text === "")
            return

        if(!file.exists(sharedDirectoryPath))
            file.mkpath(sharedDirectoryPath)

        if(file.exists(fileSavePath)) {
            replaceFileDialog();
        }
        else
            writeData()
    }

    function replaceFileDialog() {
        dialogOpened = true;
        Core.showMessageDialog(creationHandler,
                               qsTr("A file with this name already exists. Do you want to replace it?"),
                               qsTr("Yes"), function() { writeDataTimer.restart(); }, qsTr("No"), function() { restoreFocusTimer.restart(); }, null);
    }

    function writeData() {
        dialogOpened = true;
        file.write(JSON.stringify(creationHandler.dataToSave), fileSavePath);
        Core.showMessageDialog(creationHandler,
                               qsTr("Saved successfully!"),
                               qsTr("Ok"), null, "", null, function() { restoreFocusTimer.restart(); });
        refreshWindow();
    }

    function searchFiles() {
        viewContainer.selectedFileIndex = -1
        refreshWindow(fileNameInput.text.toLowerCase())
    }

    TextField {
        id: fileNameInput
        width: parent.width / 2
        font.pointSize: NaN
        font.pixelSize: height * 0.6
        height: saveButton.height
        anchors.verticalCenter: saveButton.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        verticalAlignment: TextInput.AlignVCenter
        selectByMouse: true
        maximumLength: 15
        placeholderText: creationHandler.isSaveMode ? qsTr("Enter file name") : qsTr("Search")
        onTextChanged: {
            if(!creationHandler.isSaveMode)
                searchFiles()
        }
        style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
                border.color: "black"
                border.width: 1
                radius: fileNameInput.height / 4
            }
        }
    }

    Button {
        id: saveButton
        width: 70 * ApplicationInfo.ratio
        height: Math.min(creationHandler.height / 15, cancelButton.height)
        visible: creationHandler.isSaveMode
        text: qsTr("Save")
        style: GCButtonStyle {
            theme: "highContrast"
        }
        anchors.verticalCenter: cancelButton.verticalCenter
        anchors.left: fileNameInput.right
        anchors.leftMargin: 20
        onClicked: saveFile()
    }

    property real cellWidth: 50 * ApplicationInfo.ratio
    property real cellHeight: cellWidth * 1.3

    Rectangle {
        id: viewContainer
        anchors.top: cancelButton.bottom
        anchors.topMargin: 10
        anchors.bottom: buttonRow.top
        anchors.margins: 20
        border.color: "black"
        border.width: 2
        radius: 20
        anchors.left: parent.left
        anchors.right: parent.right

        property int selectedFileIndex: -1

        MouseArea {
            anchors.fill: parent
            onClicked: viewContainer.selectedFileIndex = -1
        }

        GridView {
            id: creationsList
            model: fileNames
            flickDeceleration: 1500
            width: parent.width - 10
            height: parent.height - 10
            interactive: true
            cellHeight: creationHandler.cellHeight
            cellWidth: creationHandler.cellWidth
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 5
            clip: true

            MouseArea {
                anchors.fill: parent
                enabled: !creationHandler.isSaveMode
                onClicked: {
                    var itemIndex = creationsList.indexAt(mouseX, mouseY+creationsList.contentY)
                    if(itemIndex == -1)
                        viewContainer.selectedFileIndex = -1
                    else
                        viewContainer.selectedFileIndex = itemIndex
                }
            }

            delegate: Item {
                height: creationHandler.cellHeight
                width: creationHandler.cellWidth
                readonly property string fileName: fileName.text
                Rectangle {
                    anchors.fill: parent
                    visible: index === viewContainer.selectedFileIndex
                    color: "#E77936"
                    opacity: 0.4
                    radius: 10
                }

                Image {
                    id: fileIcon
                    width: creationHandler.cellWidth
                    height: parent.height / 1.5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    source: "qrc:/gcompris/src/core/resource/file_icon.svg"
                }

                GCText {
                    id: fileName
                    anchors.top: fileIcon.bottom
                    height: parent.height - fileIcon.height - 15
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
            text: qsTr("Load")
            enabled: viewContainer.selectedFileIndex != -1
            style: GCButtonStyle {
                theme: "highContrast"
            }
            onClicked: creationHandler.loadFile()
        }

        Button {
            id: deleteButton
            width: 70 * ApplicationInfo.ratio
            height: creationHandler.height / 15
            text: qsTr("Delete")
            enabled: viewContainer.selectedFileIndex != -1
            style: GCButtonStyle {
                theme: "highContrast"
            }
            onClicked: deleteFile()
        }
    }

    GCButtonCancel {
        id: cancelButton
        onClose: {
            parent.close()
        }
    }

    // The scroll buttons
    GCButtonScroll {
        anchors.right: viewContainer.right
        anchors.rightMargin: 5 * ApplicationInfo.ratio
        anchors.bottom: viewContainer.bottom
        anchors.bottomMargin: 5 * ApplicationInfo.ratio
        onUp: creationsList.flick(0, 1000)
        onDown: creationsList.flick(0, -1000)
        upVisible: creationsList.visibleArea.yPosition <= 0 ? false : true
        downVisible: creationsList.visibleArea.yPosition + creationsList.visibleArea.heightRatio >= 1 ? false : true
    }

    Keys.onEscapePressed: {
        cancelButton.close();
    }

    Keys.onTabPressed: {
        return;
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Left) {
            if(viewContainer.selectedFileIndex > 0) {
                viewContainer.selectedFileIndex -= 1;
            } else {
                viewContainer.selectedFileIndex = creationsList.count - 1;
            }
        }
        if(event.key === Qt.Key_Right) {
            if(viewContainer.selectedFileIndex < creationsList.count - 1) {
                viewContainer.selectedFileIndex += 1;
            } else {
                viewContainer.selectedFileIndex = 0;
            }
        }
        if(event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
            if(!dialogOpened)
                fileNameInput.forceActiveFocus();
        }
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            if(saveButton.visible && !dialogOpened) {
                saveButton.clicked();
            } else if(buttonRow.visible && viewContainer.selectedFileIndex != -1){
                loadButton.clicked();
            }
        }
        else if(event.key === Qt.Key_Back) {
            cancelButton.close();
            event.accepted = true;
        }
    }
}
