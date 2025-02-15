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
import core 1.0
// TextField
import QtQuick.Controls.Basic
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: creationHandler

    width: parent.width
    height: parent.height
    color: GCStyle.lightBlueBg
    visible: false
    z: 2000
    focus: true

    // used in Sketch activity
    property bool imageMode: false
    property var fileExtensions: []
    property string fileToOverwrite: ""

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
    signal saved

    onClose: {
        fileNameInput.focus = false
        fileNameInput.text = ""
        visible = false
        creationsList.currentIndex = -1
        fileNames.clear()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: creationsList.currentIndex = -1
    }

    property var dataToSave
    property bool isSaveMode: false
    property bool dialogOpened: false
    readonly property string activityName: ActivityInfoTree.currentActivity.name.split('/')[0]
    readonly property string sharedDirectoryPath: ApplicationSettings.userDataPath + "/" + activityName + "/"
    readonly property string fileName: imageMode ? fileNameInput.text + ".png" : fileNameInput.text + ".json"
    readonly property string filePrefix: sharedDirectoryPath.startsWith("/") ? "file://" : "file:///"
    readonly property string fileSavePath: filePrefix + sharedDirectoryPath + fileName

    ListModel {
        id: fileNames
    }

    Directory {
        id: directory
    }

    File {
        id: file
        onError: (msg) => console.error("File error: " + msg);
    }

    JsonParser {
        id: parser
        onError: (msg) => console.error("Error parsing JSON: " + msg);
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

    Timer {
        id: deleteFileTimer
        interval: 500
        onTriggered: {
            deleteFile();
        }
    }

    Timer {
        id: refreshTimer
        interval: 500
        onTriggered: {
            refreshWindow();
        }
    }

    function resetFileToOverwrite() {
        fileToOverwrite = "";
    }

    function cancelOverwriteFile() {
        resetFileToOverwrite();
        restoreFocusTimer.restart();
    }

    function refreshWindow(filterText) {
        var pathExists = file.exists(sharedDirectoryPath)
        if(!pathExists)
            return

        fileNames.clear()

        var files = null
        if(fileExtensions.length > 0) {
            files = directory.getFiles(sharedDirectoryPath, fileExtensions)
        } else {
            files = directory.getFiles(sharedDirectoryPath)
        }
        for(var i = 0; i < files.length; i++) {
            if(filterText === undefined || filterText === "" ||
              (files[i].toLowerCase()).indexOf(filterText) !== -1) {
                fileNames.append({ "name": files[i] })
            }
        }
        if(fileToOverwrite != "") {
            resetFileToOverwrite();
        }
    }

    function loadWindow() {
        creationHandler.visible = true
        creationHandler.isSaveMode = false
        fileNameInput.forceActiveFocus()
        refreshWindow()
    }

    function loadFile(fileName) {
        var filePath = filePrefix + sharedDirectoryPath + fileNames.get(creationsList.currentIndex).name
        var data = null
        if(!imageMode) {
            var data = parser.parseFromUrl(filePath)
        }
        creationHandler.fileLoaded(data, filePath)
        creationHandler.close()
    }

    function deleteFile() {
        dialogOpened = true;
        var filePath = filePrefix + sharedDirectoryPath + fileNames.get(creationsList.currentIndex).name
        if(file.rmpath(filePath)) {
            Core.showMessageDialog(creationHandler,
                                   qsTr("%1 deleted successfully!").arg(filePath),
                                   qsTr("OK"), null, "", null, function() { restoreFocusTimer.restart(); });
        }
        else {
            Core.showMessageDialog(creationHandler,
                                   qsTr("Unable to delete %1!").arg(filePath),
                                   qsTr("OK"), null, "", null, function() { restoreFocusTimer.restart(); });
        }

        creationsList.currentIndex = -1
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
            fileToOverwrite = fileName
            replaceFileDialog();
        }
        else
            writeData()
    }

    function replaceFileDialog() {
        dialogOpened = true;
        Core.showMessageDialog(creationHandler,
                               qsTr("A file with this name already exists. Do you want to replace it?"),
                               qsTr("Yes"), function() { writeDataTimer.restart(); }, qsTr("No"), function() { cancelOverwriteFile(); }, null);
    }

    function confirmFileDeleteDialog() {
        dialogOpened = true;
        Core.showMessageDialog(creationHandler,
                               qsTr("Do you really want to delete this file?"),
                               qsTr("Yes"), function() { deleteFileTimer.restart(); }, qsTr("No"), function() { restoreFocusTimer.restart(); }, null);
    }

    function writeData() {
        dialogOpened = true;
        if(imageMode) {
            file.copy(creationHandler.dataToSave, fileSavePath);
        } else {
            file.write(JSON.stringify(creationHandler.dataToSave), fileSavePath);
        }
        Core.showMessageDialog(creationHandler,
                               qsTr("Saved successfully!"),
                               qsTr("OK"), function() { close(); }, "", null, function() { restoreFocusTimer.restart(); });
        saved();
        refreshTimer.restart();
    }

    function searchFiles() {
        creationsList.currentIndex = -1
        refreshWindow(fileNameInput.text.toLowerCase())
    }

    Rectangle {
        id: fileNameBackground
        width: Math.floor(parent.width * 0.5)
        height: Math.floor(cancelButton.height * 0.7)
        anchors.verticalCenter: saveButton.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: GCStyle.halfMargins
        border.color: GCStyle.darkerBorder
        border.width: GCStyle.thinnestBorder
        radius: GCStyle.halfMargins

        TextField {
            id: fileNameInput
            anchors.fill: parent
            font.pointSize: NaN
            font.pixelSize: fileNameBackground.height * 0.6
            topPadding: 0
            bottomPadding: 0
            selectByMouse: true
            maximumLength: 20
            placeholderText: creationHandler.isSaveMode ? qsTr("Enter file name") : qsTr("Search")
            onTextChanged: {
                if(!creationHandler.isSaveMode)
                    searchFiles()
            }
            color: GCStyle.darkerText
            background.visible: false
        }
    }

    GCButton {
        id: saveButton
        height: fileNameBackground.height
        visible: creationHandler.isSaveMode
        text: qsTr("Save")
        theme: "highContrast"
        anchors.verticalCenter: cancelButton.verticalCenter
        anchors.left: fileNameBackground.right
        anchors.right: cancelButton.left
        anchors.margins: GCStyle.halfMargins
        onClicked: saveFile()
        enabled: fileNameInput.text != ""
    }

    property real cellWidth: Math.min(Math.floor(creationsList.width  * 0.2), creationsList.height)
    property real cellHeight: cellWidth

    Rectangle {
        id: viewContainer
        anchors.top: cancelButton.bottom
        anchors.bottom: buttonRow.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: GCStyle.halfMargins
        border.color: GCStyle.darkerBorder
        border.width: GCStyle.thinnestBorder
        radius: GCStyle.halfMargins

        MouseArea {
            anchors.fill: parent
            onClicked: creationsList.currentIndex = -1
        }

        GridView {
            id: creationsList
            model: fileNames
            maximumFlickVelocity: creationHandler.height
            boundsBehavior: Flickable.StopAtBounds
            anchors.fill: parent
            anchors.margins: GCStyle.halfMargins
            anchors.rightMargin: GCStyle.halfMargins + scrollButtons.width
            interactive: true
            cellHeight: creationHandler.cellHeight
            cellWidth: creationHandler.cellWidth
            clip: true
            onCurrentIndexChanged: positionViewAtIndex(currentIndex, GridView.Contain)
            keyNavigationWraps: true
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlight: Rectangle {
                height: creationHandler.cellHeight
                width: creationHandler.cellWidth
                color: GCStyle.highlightColor
                radius: GCStyle.halfMargins
            }
            delegate: Item {
                height: creationHandler.cellHeight
                width: creationHandler.cellWidth
                readonly property string fileName: fileName.text
                Image {
                    id: fileIcon
                    width: creationHandler.cellWidth - GCStyle.baseMargins
                    height: (creationHandler.cellHeight - GCStyle.halfMargins * 3) * 0.75
                    anchors.top: parent.top
                    anchors.topMargin: GCStyle.halfMargins
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    // the empty file is used to make a switch to reload overwritten image
                    source: creationHandler.imageMode ?
                        (fileName.text == creationHandler.fileToOverwrite ? "qrc:/gcompris/src/core/resource/empty.svg" : filePrefix + sharedDirectoryPath + fileName.text) :
                        "qrc:/gcompris/src/core/resource/file_icon.svg"
                }

                GCText {
                    id: fileName
                    anchors.top: fileIcon.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    font.pointSize: regularSize
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    // Exclude ".json" while displaying file name if not imageMode
                    text: creationHandler.imageMode ? name :
                        name.slice(0, name.length - 5)
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: !creationHandler.isSaveMode
                onClicked: {
                    creationsList.currentIndex = creationsList.indexAt(mouseX, mouseY+creationsList.contentY)
                }
            }
        }
    }

    Row {
        id: buttonRow
        spacing: GCStyle.halfMargins
        anchors.horizontalCenter: creationHandler.horizontalCenter
        anchors.bottom: keyboardCreation.top
        anchors.bottomMargin: GCStyle.halfMargins
        visible: !creationHandler.isSaveMode
        GCButton {
            id: loadButton
            width: (viewContainer.width - GCStyle.baseMargins) * 0.5
            height: buttonRow.visible ? Math.min(saveButton.height, safeSizeHint.height * 0.3) : 0
            text: qsTr("Load")
            enabled: creationsList.currentIndex != -1
            theme: "highContrast"
            onClicked: creationHandler.loadFile()
        }

        GCButton {
            id: deleteButton
            width: loadButton.width
            height: loadButton.height
            text: qsTr("Delete")
            enabled: creationsList.currentIndex != -1
            theme: "highContrast"
            onClicked: confirmFileDeleteDialog()
        }
    }

    GCButtonCancel {
        id: cancelButton
        onClose: {
            parent.close()
        }
    }

    Item {
        id: safeSizeHint
        anchors.top: cancelButton.bottom
        anchors.bottom: keyboardCreation.top
        anchors.right: parent.right
        width: GCStyle.thinnestBorder
    }

    // The scroll buttons
    GCButtonScroll {
        id: scrollButtons
        height: Math.min(defaultHeight, viewContainer.height)
        width: Math.min(defaultWidth, viewContainer.height * widthRatio)
        anchors.right: viewContainer.right
        anchors.bottom: viewContainer.bottom
        anchors.margins: GCStyle.halfMargins
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
        onError: (msg) => console.log("VirtualKeyboard error: " + msg);
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

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Left) {
            creationsList.moveCurrentIndexLeft();
        } else if(event.key === Qt.Key_Right) {
            creationsList.moveCurrentIndexRight();
        } else if(event.key === Qt.Key_Up) {
            creationsList.moveCurrentIndexUp();
        } else if(event.key == Qt.Key_Down) {
            creationsList.moveCurrentIndexDown();
        }
    }

    Keys.onReleased: (event) => {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            if(dialogOpened) {
                return
            } else if(saveButton.visible) {
                saveButton.clicked();
            } else if(buttonRow.visible && creationsList.currentIndex != -1){
                loadButton.clicked();
            }
        }
        else if(event.key === Qt.Key_Delete) {
            if(buttonRow.visible && creationsList.currentIndex != -1){
                deleteButton.clicked();
            }
        }
        else if(event.key === Qt.Key_Back) {
            cancelButton.close();
            event.accepted = true;
        }
    }
}
