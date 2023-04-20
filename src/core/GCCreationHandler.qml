/* GCompris - GCCreationHandler.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
// TextField
import QtQuick.Controls 2.12
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
            keyboardCreation.populate();
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
        height: cancelButton.height * 0.5
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
        color: "black"
        background: Rectangle {
            border.color: "black"
            border.width: 1
            radius: fileNameInput.height / 4
        }
    }

    GCButton {
        id: saveButton
        height: fileNameInput.height
        visible: creationHandler.isSaveMode
        text: qsTr("Save")
        theme: "highContrast"
        anchors.verticalCenter: cancelButton.verticalCenter
        anchors.left: fileNameInput.right
        anchors.right: cancelButton.left
        anchors.margins: 20 * ApplicationInfo.ratio
        onClicked: saveFile()
    }

    property real cellWidth: 50 * ApplicationInfo.ratio
    property real cellHeight: cellWidth * 1.3

    Rectangle {
        id: viewContainer
        anchors.top: cancelButton.bottom
        anchors.bottom: buttonRow.top
        anchors.margins: 10 * ApplicationInfo.ratio
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
                    if(itemIndex === -1)
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
        spacing: 20 * ApplicationInfo.ratio
        anchors.horizontalCenter: viewContainer.horizontalCenter
        anchors.bottom: keyboardCreation.top
        anchors.bottomMargin: 10 * ApplicationInfo.ratio
        visible: !creationHandler.isSaveMode
        GCButton {
            id: loadButton
            width: viewContainer.width * 0.5 - 20 * ApplicationInfo.ratio
            height: saveButton.height
            text: qsTr("Load")
            enabled: viewContainer.selectedFileIndex != -1
            theme: "highContrast"
            onClicked: creationHandler.loadFile()
        }

        GCButton {
            id: deleteButton
            width: loadButton.width
            height: saveButton.height
            text: qsTr("Delete")
            enabled: viewContainer.selectedFileIndex != -1
            theme: "highContrast"
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
        upVisible: creationsList.atYBeginning ? false : true
        downVisible: creationsList.atYEnd ? false : true
    }

    VirtualKeyboard {
        id: keyboardCreation
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        visible: ApplicationSettings.isVirtualKeyboard && !ApplicationInfo.isMobile && !dialogOpened
        onKeypress: {
            var textArray = fileNameInput.text.split("");
            var cursorPosition = fileNameInput.cursorPosition
            if(text == backspace) {
                --cursorPosition;
                textArray.splice(cursorPosition , 1);
            }
            else {
                textArray.splice(cursorPosition, 0, text);
                ++cursorPosition;
            }
            fileNameInput.text = textArray.join("");
            fileNameInput.cursorPosition = cursorPosition;
        }
        shiftKey: true
        onError: console.log("VirtualKeyboard error: " + msg);
        readonly property string newline: "\u21B2"

        function populate() {
            layout = [
            [
                { label: "0" },
                { label: "1" },
                { label: "2" },
                { label: "3" },
                { label: "4" },
                { label: "5" },
                { label: "6" },
                { label: "7" },
                { label: "8" },
                { label: "9" }
            ],
            [
                { label: "A" },
                { label: "B" },
                { label: "C" },
                { label: "D" },
                { label: "E" },
                { label: "F" },
                { label: "G" },
                { label: "H" },
                { label: "I" }
            ],
            [
                { label: "J" },
                { label: "K" },
                { label: "L" },
                { label: "M" },
                { label: "N" },
                { label: "O" },
                { label: "P" },
                { label: "Q" },
                { label: "R" }
            ],
            [
                { label: "S" },
                { label: "T" },
                { label: "U" },
                { label: "V" },
                { label: "W" },
                { label: "X" },
                { label: "Y" },
                { label: "Z" },
                { label: " " },
                { label: backspace }
            ]
        ]
        }
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
        else if(event.key === Qt.Key_Delete) {
            if(buttonRow.visible && viewContainer.selectedFileIndex != -1){
                deleteButton.clicked();
            }
        }
        else if(event.key === Qt.Key_Back) {
            cancelButton.close();
            event.accepted = true;
        }
    }
}
