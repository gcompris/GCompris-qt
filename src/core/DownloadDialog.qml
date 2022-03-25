/* GCompris - DownloadDialog.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * A QML component visualizing download progress.
 * @ingroup infrastructure
 *
 * A GCDialog style dialog providing visual feedback for download progress.
 * Uses DownloadManager for download control.
 *
 * Can be conveniently instantiated dynamically using showDownloadDialog
 * from core.js.
 *
 * @inherit QtQuick.Item
 * @sa DownloadManager, showDownloadDialog
 */
Item {
    id: downloadDialog
    opacity: 0

    anchors {
        fill: parent
    }

    /**
     * type:Item
     * Parent object for the dialog in the qml hierarchy.
     */
    property Item main

    /**
     * type:bool
     * Whether to close the dialog automatically when download has finished.
     * Default is false.
     */
    property bool autohide: false;

    /**
     * type:bool
     * Whether to report download success in a Dialog.
     * Default is true.
     */
    property bool reportSuccess: true;

    /**
     * type:bool
     * Whether to report download errors in a Dialog.
     * Default is true.
     */
    property bool reportError: true;

    /**
     * type:bool
     * Whether a message has been displayed
     * we don't want to display several dialogs
     */
    property bool messageDisplayed: false;

    /**
     * type:GCDialog
     * The dialog displaying the result message
     */
    property var messageDialog: undefined;

    /**
     * type:bool
     * Whether the dialog has been created dynamically. If set to true, the
     * component takes care of destroying itself after finished.
     * Default is false.
     *
     * @sa Core.destroyDialog
     */
    property bool dynamic: false

    /**
     * type:bool
     * Whether the 'Background' button should be visible.
     * Default is true.
     */
    property alias backgroundButtonVisible: backgroundButton.visible

    /**
     * type:bool
     * Whether the 'Abort' button should be visible.
     * Default is true.
     */
    property alias abortButtonVisible: abortButton.visible

    /**
     * type:bool
     * Fixed font size used in this dialog. Note, fixed font-sizes should be
     * used in dialog components, to make sure they stay within bounds when
     * user increases font size.
     * Default is 14.
     */
    property int fixedFontSize: 14

    /// @cond INTERNAL_DOCS

    // start and stop trigs the animation FIXME: need to document?
    signal start
    signal stop

    // emitted at stop animation end
    signal close

    signal finished

    focus: true

    //We need a timer to properly get focus on this dialog and its children dialogs
    Timer {
        id: getFocusTimer
        interval: 250
        onTriggered: {
            if(!messageDisplayed) {
                downloadDialog.forceActiveFocus();
                downloadDialog.parent.Keys.enabled = false;
            } else {
                messageDialog.forceActiveFocus();
                downloadDialog.parent.Keys.enabled = false;
            }
        }
    }

    onVisibleChanged: {
        if(visible) {
            getFocusTimer.restart();
        }
    }
    onStart: {
        opacity = 1;
        getFocusTimer.restart();
    }
    onStop: {
        opacity = 0;
        parent.Keys.enabled = true;
        parent.forceActiveFocus();
    }
    onClose: {
        destroy();
        parent.Keys.enabled = true;
        parent.forceActiveFocus();
    }

    Behavior on opacity { NumberAnimation { duration: 200 } }
    onOpacityChanged: opacity === 0 ? close() : null

    function shutdown()
    {
        if (downloadDialog.dynamic)
            Core.destroyDialog(downloadDialog);
        else
            downloadDialog.close();
    }

    /// @endcond

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: "grey"

        MouseArea {
            // Empty mouseArea to prevent clicking "behind" the Dialog
            anchors.fill: parent
            enabled: downloadDialog.opacity != 0
        }
    }

    Item {
        id: instruction
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.1
        }
        width: parent.width * 0.8

        GCText {
            id: instructionTxt
            fontSize: mediumSize
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: TextEdit.WordWrap
            z: 2
            height: 60 * ApplicationInfo.ratio
            text: qsTr("Downloading...")
        }

        Rectangle {
            anchors.fill: instructionTxt
            z: 1
            opacity: 0.9
            radius: 10
            border.width: 2
            border.color: "white"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff" }
                GradientStop { position: 0.9; color: "#fff" }
                GradientStop { position: 1.0; color: "#ddd" }
            }
        }

        ProgressBar {
            id: downloadDialogProgress
            width: parent.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxt.bottom
                topMargin: 10
            }
            visible: true
            Layout.alignment: Qt.AlignHCenter
            Layout.rowSpan: 1
            Layout.fillWidth: true
            from: 0
            to: 100
            value: 0
        }

        Rectangle {
            id: buttonSelector
            width: 0
            height: 0
            color: "#803ACAFF"
            scale: 1.1
        }

        GCButton {
            id: backgroundButton
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: downloadDialogProgress.bottom
                topMargin: 10
            }
            //: Run this task in background
            text: qsTr("Background")
            fixedFontSize: downloadDialog.fixedFontSize
            theme: "highContrast"
            visible: true
            property bool selected: false;
            onClicked: downloadDialog.shutdown();
        }

        GCButton {
            id: abortButton
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: backgroundButton.bottom
                topMargin: 10
            }
            text: qsTr("Abort")
            fixedFontSize: downloadDialog.fixedFontSize
            theme: "highContrast"

            visible: true
            property bool selected: false;
            onClicked: {
                if (DownloadManager.downloadIsRunning())
                    DownloadManager.abortDownloads();
                downloadDialog.finished();
                downloadDialog.shutdown();
            }
        }

        states: [
            State {
                name: "button1Selected"
                when: backgroundButton.selected
                PropertyChanges {
                    target: buttonSelector
                    anchors.fill: backgroundButton
                }
            },
            State {
                name: "button2Selected"
                when: abortButton.selected
                PropertyChanges {
                    target: buttonSelector
                    anchors.fill: abortButton
                }
            }
        ]
    }

    Keys.onEscapePressed: {
        if(backgroundButtonVisible)
            backgroundButton.clicked();
        else if(abortButtonVisible)
            abortButton.clicked();
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Up || event.key === Qt.Key_Left) {
            if(abortButton.visible && !backgroundButton.selected && !abortButton.selected) {
                abortButton.selected = true;
            } else if(backgroundButton.visible) {
                abortButton.selected = !abortButton.selected;
                backgroundButton.selected = !backgroundButton.selected;
            } else if(abortButton.visible) {
                button1.selected = true;
            }
        }
        if(event.key === Qt.Key_Down || event.key === Qt.Key_Right) {
            if(backgroundButton.visible && !backgroundButton.selected && !abortButton.selected) {
                backgroundButton.selected = true;
            } else if(backgroundButton.visible) {
                backgroundButton.selected = !backgroundButton.selected;
                abortButton.selected = !abortButton.selected;
            } else if(abortButton.visible) {
                abortButton.selected = true;
            }
        }
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            if(backgroundButton.selected) {
                backgroundButton.clicked();
            } else if(abortButton.selected) {
                abortButton.clicked();
            } else if(backgroundButtonVisible) {
                backgroundButton.clicked();
            } else if(abortButtonVisible) {
                abortButton.clicked();
            }
        }
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Back) {
            if(backgroundButtonVisible)
                backgroundButton.clicked();
            else if(abortButtonVisible)
                abortButton.clicked();
            event.accepted = true;
        }
    }

    Connections {
        target: DownloadManager

        onError: {
            //console.warn("DownloadDialog: DM reports error: " + code + ": " + msg);
            downloadDialog.finished();
            if (downloadDialog.reportError
                    && code != 5 && !messageDisplayed) {  // no error: OperationCanceledError
                // show error message
                messageDisplayed = true;
                messageDialog = Core.showMessageDialog(downloadDialog.parent,
                                                           qsTr("Download error (code: %1): %2").arg(code).arg(msg),
                                                           "", null,
                                                           "", null,
                                                           function() {
                                                               downloadDialog.shutdown();
                                                           }
                                                           );
                getFocusTimer.restart();
            }
        }

        onDownloadProgress: downloadDialogProgress.value = 100 * bytesReceived / bytesTotal;

        onDownloadStarted: {
            //console.log("dialog: DM reports started: " + resource);
            downloadDialogProgress.value = 0;
        }

        onAllDownloadsFinished: {
            //console.log("dialog: DM all reports finished");
            downloadDialog.finished();
            if (downloadDialog.reportSuccess
                    && code != 1 && !messageDisplayed) // note: errors will be reported by the onError handler
            {
                // report success
                messageDisplayed = true;
                var infText = "";
                if (code == 0) {  // Success
                    infText = qsTr("Your download finished successfully. The data files are now available.")
                            + '\n'
                            + qsTr("Restart any currently active activity.");
                } else if (code == 2)  // NoChange
                    infText = qsTr("Your local data files are up-to-date.")

                messageDialog = Core.showMessageDialog(downloadDialog.parent,
                                                           infText,
                                                           "", null,
                                                           "", null,
                                                           function() {
                                                               downloadDialog.shutdown();
                                                           }
                                                           );
                getFocusTimer.restart();
            } else if (downloadDialog.autohide)
                downloadDialog.shutdown();
        }

        onDownloadFinished: {
            //console.log("dialog: DM reports finished: " + code);
        }
    }

}
