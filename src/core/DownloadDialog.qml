/* GCompris - DownloadDialog.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0
import QtQuick.Layouts
import QtQuick.Controls.Basic
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
        color: GCStyle.grayedBg

        MouseArea {
            // Empty mouseArea to prevent clicking "behind" the Dialog
            anchors.fill: parent
            enabled: downloadDialog.opacity != 0
        }
    }

    Item {
        id: instruction
        anchors.fill: parent
        anchors.margins: GCStyle.baseMargins * 2

        Rectangle {
            id: instructionTxtBg
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.whiteBorder
            color: GCStyle.lightBg
        }

        GCText {
            id: instructionTxt
            fontSize: mediumSize
            color: GCStyle.darkText
            anchors.fill: instructionTxtBg
            anchors.margins: GCStyle.baseMargins
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: TextEdit.WordWrap
            text: qsTr("Downloading...")
        }

        GCProgressBar {
            id: downloadDialogProgress
            width: parent.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxtBg.bottom
                topMargin: GCStyle.halfMargins
            }
            visible: true
            Layout.alignment: Qt.AlignHCenter
            Layout.rowSpan: 1
            Layout.fillWidth: true
            from: 0
            to: 100
            value: 0
        }

        GCButton {
            id: backgroundButton
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: downloadDialogProgress.bottom
                topMargin: GCStyle.halfMargins
            }
            //: Run this task in background
            text: qsTr("Background")
            fixedFontSize: downloadDialog.fixedFontSize
            theme: "highContrast"
            visible: true
            onClicked: downloadDialog.shutdown();
        }

        GCButton {
            id: abortButton
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: backgroundButton.bottom
                topMargin: GCStyle.halfMargins
            }
            text: qsTr("Abort")
            fixedFontSize: downloadDialog.fixedFontSize
            theme: "highContrast"

            visible: true
            onClicked: {
                if (DownloadManager.downloadIsRunning())
                    DownloadManager.abortDownloads();
                downloadDialog.finished();
                downloadDialog.shutdown();
            }
        }
    }

    Keys.onEscapePressed: {
        if(backgroundButtonVisible)
            backgroundButton.clicked();
        else if(abortButtonVisible)
            abortButton.clicked();
    }

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Up || event.key === Qt.Key_Left) {
            if(abortButton.visible && !backgroundButton.selected && !abortButton.selected) {
                abortButton.selected = true;
            } else if(backgroundButton.visible) {
                abortButton.selected = !abortButton.selected;
                backgroundButton.selected = !backgroundButton.selected;
            } else if(abortButton.visible) {
                abortButton.selected = true;
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

    Keys.onReleased: (event) => {
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

        function onError(code, msg) {
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

        function onDownloadProgress(bytesReceived, bytesTotal) { downloadDialogProgress.value = 100 * bytesReceived / bytesTotal; }

        function onDownloadStarted(resource) {
            //console.log("dialog: DM reports started: " + resource);
            downloadDialogProgress.value = 0;
        }

        function onAllDownloadsFinished(code) {
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

        function onDownloadFinished(code) {
            //console.log("dialog: DM reports finished: " + code);
        }
    }

}
