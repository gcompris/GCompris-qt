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
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: downloadDialog
    opacity: 0

    anchors {
        fill: parent
    }

    property Item main
    property bool autohide: false;      ///< whether to close the dialog automatically when download has finished
    property bool reportSuccess: true;  ///< whether to report successful
    property bool reportError: true;
    property bool dynamic: false        ///< whether created dynamically
    property alias backgroundButtonVisible: backgroundButton.visible
    property alias abortButtonVisible: abortButton.visible
    property int fixedFontSize: 14      ///< fixed font-size used in this dialog

    // start and stop trigs the animation
    signal start
    signal stop

    // emitted at stop animation end
    signal close

    signal finished

    onStart: opacity = 1
    onStop: opacity = 0
    onClose: destroy()

    Behavior on opacity { NumberAnimation { duration: 200 } }
    onOpacityChanged: opacity === 0 ? close() : null

    function shutdown()
    {
        if (downloadDialog.dynamic)
            Core.destroyDialog(downloadDialog);
        else
            downloadDialog.close();
    }

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
            text: qsTr("Downloading ...")
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
            minimumValue: 0
            maximumValue: 100
            value: 0
        }

        Button {
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
            style: GCButtonStyle {
                fixedFontSize: downloadDialog.fixedFontSize
            }
            visible: true
            onClicked: downloadDialog.shutdown();
        }

        Button {
            id: abortButton
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: backgroundButton.bottom
                topMargin: 10
            }
            text: qsTr("Abort")
            style: GCButtonStyle {
                fixedFontSize: downloadDialog.fixedFontSize
            }
            visible: true
            onClicked: {
                if (DownloadManager.downloadIsRunning())
                    DownloadManager.abortDownloads();
                downloadDialog.finished();
                downloadDialog.shutdown();
            }
        }

    }

    Connections {
        target: DownloadManager

        onError: {
            //console.warn("DownloadDialog: DM reports error: " + code + ": " + msg);
            downloadDialog.finished();
            if (downloadDialog.reportError
                    && code != 5) {  // no error: OperationCanceledError
                // show error message
                var messageDialog = Core.showMessageDialog(main,
                                                           qsTr("Download error") + code + ": " + msg,
                                                           "", null,
                                                           "", null,
                                                           function() {
                                                               downloadDialog.shutdown();
                                                           }
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
                downloadDialog.stop();
                var infText = "";
                if (code == 0) {  // Success
                    infText = qsTr("Your download finished successfully. The sound files are now available.")
                            + '\n'
                            + qsTr("Restart any currently active activity.");
                } else if (code == 2)  // NoChange
                    infText = qsTr("Your local sound files are up-to-date.")

                var messageDialog = Core.showMessageDialog(main,
                                                           infText,
                                                           "", null,
                                                           "", null,
                                                           null
                                                           );
            } else if (downloadDialog.autohide)
                downloadDialog.shutdown();
        }
    }

}
