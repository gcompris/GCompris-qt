/* GCompris - core.js
 *
 * Copyright (C) 2014
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *   Holger Kaelberer <holger.k@elberer.de>
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

/*
  This file contains all javascript methods that can be used by more than one
  activity.
  */

.pragma library
.import QtQuick.Dialogs 1.2 as Dialog
.import QtQml 2.2 as Qml
.import GCompris 1.0 as GCompris

/*
  function shuffle()
  Shuffle the array passed in parameter and returns it.
*/
function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

// from soundutil.c
/** return a string representing of a letter or a number audio file
 *  get alphabet sound file name
 *
 * the returned sound has the suffix .ogg
 *
 * \return a newly allocated string of the form U0033.ogg
 */
function getSoundFilenamForChar(c)
{
    var result = "U";
    var codeHex = c.toLowerCase().charCodeAt(0).toString(16).toUpperCase();
    while (codeHex.length < 4) {
        codeHex = "0" + codeHex;
    }
    result += codeHex + ".ogg";
    return result;
}

/* Helper funciton to workaround dialog-handler being triggered twice in
 * Qt 5.3 (bug #35933) */
function callMeOnce(_dialog, _func)
{
    var called = false;
    var dialog = _dialog;
    var func = _func;
    return function() {
        if (!called) {
            func();
            called = true;
            destroyDialog(dialog);
        }
    }
}

function populateDialogButtons(dialog, buttonHandler)
{
    for(var button in buttonHandler) {
        // AcceptRole:
        if (button == Dialog.StandardButton.Ok ||
            button == Dialog.StandardButton.Ignore)
            dialog.onAccepted.connect(callMeOnce(dialog, buttonHandler[button]));
        // RejectRole:
        else if (button == Dialog.StandardButton.Cancel ||
                button == Dialog.StandardButton.Abort)
            dialog.onRejected.connect(callMeOnce(dialog, buttonHandler[button]));
        // YesRole:
        else if (button == Dialog.StandardButton.Yes)
            dialog.onYes.connect(callMeOnce(dialog, buttonHandler[button]));
        // NoRole:
        else if (button == Dialog.StandardButton.No)
            dialog.onNo.connect(callMeOnce(dialog, buttonHandler[button]));
        else {
            throw new Error("Invalid standardButton: " + button);
        }
        dialog.standardButtons |= button;
    }
}

/** Create and present a MessageDialog with the given parameters
 * 
 * Instantiates a Messagedialog object dynamically as child of the  passed
 * parent object. After on of the buttons passed in the buttonHandler parameter
 * has been pressed the dialog will be closed and destroyed automatically.
 * 
 * @param parent QML parent object
 * @param title Title
 * @param text  Text
 * @param informativeText  Informative text
 * @param icon A QQuickStandardIcon::Icon
 * @param buttonHandler Object defining a Standardbutton-to-signalhandler
 *                      mapping. Note that max. one button of each
 *                      QMessageBox::ButtonRole are allowed as keys.
 * @returns The MessageDialog object upon success, null otherwise 
 */
function showMessageDialog(parent, title, text, informativeText, icon, buttonHandler) {
    var qmlStr = 
          'import QtQuick 2.0\n'
        + 'import QtQuick.Dialogs 1.2\n'
        + 'MessageDialog {\n'
        + '    visible: false\n'
        + '    modality: Qt.WindowModal\n'
        + '    title: "' + title +'"\n'
        + '    text: "' + text + '"\n'
        + '    informativeText: "' + informativeText + '"\n'
        + '    icon: StandardIcon.Information\n'
        + ' }\n';
    //console.log("creating dialog " + qmlStr);
    
    var dialog = null;
    try {
        dialog = Qt.createQmlObject(qmlStr, parent);
        dialog.icon = icon;
        dialog.standardButtons = 0;
        populateDialogButtons(dialog, buttonHandler);
        dialog.open();
    } catch (e) {
        console.error("core.js: Error creating a MessageDialog: " + e);
        if (dialog)
            dialog.destroy();
        return null;
    }
    //console.log("created MessageDialog " + dialog);
    return dialog;
}

/** Destroy a dialog
 * 
 * @param dialog A dynamically created MessageDialog or DownloadDialog
 */
function destroyDialog(dialog) {
    //console.log("destroying dialog " + dialog);
    if (dialog) {
        dialog.close();
        dialog.destroy();
    }
}

var downloadDialogComponent = null;

/** Create and present a DownloadDialog with the given parameters
 * 
 * Instantiates a DownloadDialog object dynamically as child of the  passed
 * parent object.
 * 
 * @param parent QML parent object
 * @param properties Object with property-value pairs used to parametrize the new
 *                   object. Used directly as properties parameter of 
 *                   Component.createObject(); 
 */
function showDownloadDialog(parent, properties) {
    var dialog = null;
    try {
        if (!downloadDialogComponent) {
            downloadDialogComponent = Qt.createComponent("qrc:/gcompris/src/core/DownloadDialog.qml");
            if (downloadDialogComponent.status != Qml.Component.Ready) {
                downloadDialogComponent = null;
                throw new Error("Error creating DownloadDialog component");
            }
        }
        properties.dynamic = true;
        dialog = downloadDialogComponent.createObject( parent, properties);
        dialog.open();
    } catch (e) {
        console.error("core.js: Error creating a DownloadDialog: " + e);
        if (dialog)
            dialog.destroy();
        return null;
    }
    //console.log("created DownloadDialog " + dialog);
    return dialog;
}

function checkForVoices(parent)
{
    if (!GCompris.DownloadManager.haveLocalResource(
            GCompris.DownloadManager.getVoicesResourceForLocale(
                    GCompris.ApplicationInfo.localeShort))) {
        var buttonHandler = new Array();
        var dialog;
        buttonHandler[Dialog.StandardButton.Ok] = function() {};
        dialog = showMessageDialog(parent, qsTr("Missing sound files!"),
                qsTr("This activity makes use of language specific sound files, that are not yet installed on your system."),
                qsTr("For downloading the needed sound files go to the preferences dialog."),
                Dialog.StandardIcon.Information,
                buttonHandler);
    }
}

function quit(parent)
{
    console.log("core.js: about to quit");
    
    if (GCompris.DownloadManager.downloadIsRunning()) {
        var dialog = showDownloadDialog(parent, { 
            text: qsTr("Download in progress.<br/>'Abort' it to quit immediately."),
            autohide: true,
            reportError: false,
            reportSuccess: false,
            backgroundButtonVisible: false
        });
        dialog.finished.connect(function() {Qt.quit();});
    } else
        Qt.quit();
}
