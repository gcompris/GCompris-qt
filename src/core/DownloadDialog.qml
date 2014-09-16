/* GCompris - DownloadDialog.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import "qrc:/gcompris/src/core/core.js" as Core

Dialog {
    id: downloadDialog

    title: qsTr("Download in progress")
    modality: Qt.ApplicationModal

    property alias text: downloadDialogText.text
    property bool autohide: false;      ///< whether to close the dialog automatically when download has finished
    property bool reportSuccess: true;  ///< whether to report succesful  
    property bool reportError: true;
    property bool dynamic: false        ///< whether created dynamically
    property alias backgroundButtonVisible: backgroundButton.visible
    property alias abortButtonVisible: abortButton.visible
    
    signal finished;
    
    function shutdown()
    {
        if (downloadDialog.dynamic)
            Core.destroyDialog(downloadDialog);
        else
            downloadDialog.close();
    }

    Connections {
        target: DownloadManager
        
        onError: {
            //console.warn("DownloadDialog: DM reports error: " + code + ": " + msg);
            downloadDialog.finished();
            if (downloadDialog.reportError
                && code != 5) {  // no error: OperationCanceledError
                // show error message
                downloadDialog.close();
                var buttonHandler = new Array();
                buttonHandler[StandardButton.Ignore] = function() {
                    downloadDialog.shutdown();
                };
                var messageDialog = Core.showMessageDialog(downloadDialog,
                    qsTr("Download error"),
                    code + ": " + msg,
                    "",
                    StandardIcon.Warning,
                    buttonHandler
                );
            } else 
                downloadDialog.shutdown();
        }
        
        onDownloadProgress: downloadDialogProgress.value = 100 * bytesReceived / bytesTotal;
        
        onDownloadStarted: {
            //console.log("dialog: DM reports started: " + resource);
            downloadDialogProgress.value = 0;
        }

        onDownloadFinished: {
            //console.log("dialog: DM reports finished: " + code);
            downloadDialog.finished();
            if (downloadDialog.reportSuccess
                && code != 1) // note: errors will be reported by the onError handler
            {
                // report success
                downloadDialog.close();
                var text;
                var infText = "";
                if (code == 0) {  // Success
                    text = qsTr("Your download finished successfully. The sound files are now available.");
                    infText = qsTr("Restart any currently active activity.");
                } else if (code == 2)  // NoChange
                    text = qsTr("Your local sound files are up-to-date.")

                var buttonHandler = new Array();
                buttonHandler[StandardButton.Ok] = function() {
                    downloadDialog.shutdown();
                };
                var messageDialog = Core.showMessageDialog(downloadDialog,
                    qsTr("Download finished"),
                    text,
                    infText,
                    StandardIcon.Information,
                    buttonHandler
                );
            } else if (downloadDialog.autohide)
                downloadDialog.shutdown();
        }
    }

    ColumnLayout {
        id: downloadColumn
        width: parent.width
        GCText {
            id: downloadDialogText
            width: parent.width
            text: qsTr("Downloading ...")
            textFormat: Text.StyledText
            Layout.rowSpan: 1
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
        ProgressBar {
            id: downloadDialogProgress
            visible: true
            Layout.alignment: Qt.AlignHCenter
            Layout.rowSpan: 1
            Layout.fillWidth: true
            minimumValue: 0
            maximumValue: 100
            value: 0
        }
        RowLayout {
            id: buttonRow
            Layout.alignment: Qt.AlignHCenter
            Layout.rowSpan: 1
            Layout.fillWidth: true
            
            Button {
                id: backgroundButton
                text: "Background"
                style: GCButtonStyle {}
                visible: true
                onClicked: downloadDialog.shutdown();
            }
            Button {
                id: abortButton
                text: "Abort"
                style: GCButtonStyle {}
                visible: true
                onClicked: {
                    if (DownloadManager.downloadIsRunning())
                        DownloadManager.abortDownloads();
                    downloadDialog.finished();
                    downloadDialog.shutdown();
                }
            }
        }
    }
}
