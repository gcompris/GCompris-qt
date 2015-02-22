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

/** Create and present a MessageDialog with the given parameters
 * 
 * Instantiates a Messagedialog object dynamically as child of the  passed
 * parent object. After on of the buttons passed in the buttonHandler parameter
 * has been pressed the dialog will be closed and destroyed automatically.
 * 
 * @param parent QML parent object
 * @param informativeText  Informative text
 * @param button1Text the text of the first button
 * @param button1Callback the callback of the first button
 * @param button2Text the text of the second button
 * @param button2Callback the callback of the second button
 * @param closeCallback the callback of the close button
 * @returns The MessageDialog object upon success, null otherwise
 */
function showMessageDialog(parent, informativeText,
                           button1Text, button1Callback,
                           button2Text, button2Callback,
                           closeCallback) {
    var qmlStr =
          'import QtQuick 2.0\n'
        + 'GCDialog {\n'
        + '    message: "' + informativeText + '"\n'
        + '    button1Text: "' + button1Text + '"\n'
        + '    button2Text: "' + button2Text + '"\n'
        + ' }\n';
    
    var dialog = null;
    try {
        dialog = Qt.createQmlObject(qmlStr, parent);
        if(button1Callback)
            dialog.button1Hit.connect(button1Callback);
        if(button2Callback)
            dialog.button2Hit.connect(button2Callback);
        if(closeCallback)
            dialog.close.connect(closeCallback);
        dialog.start();
    } catch (e) {
        console.error("core.js: Error creating a MessageDialog: " + e);
        if (dialog)
            dialog.destroy();
        return null;
    }
    return dialog;
}

/** Destroy a dialog
 * 
 * @param dialog A dynamically created MessageDialog or DownloadDialog
 */
function destroyDialog(dialog) {
    if (dialog) {
        dialog.stop();
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
                throw new Error("Error creating DownloadDialog component: "
                        + downloadDialogComponent.errorString());
                downloadDialogComponent = null;
            }
        }
        properties.dynamic = true;
        dialog = downloadDialogComponent.createObject( parent, properties);
        dialog.main = parent
        dialog.start();
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
                    GCompris.ApplicationSettings.locale))) {
        showMessageDialog(parent,
                qsTr("Missing sound files!") + '\n'
                + qsTr("This activity makes use of language specific sound files, that are not yet installed on your system.")
                + '\n'
                + qsTr("For downloading the needed sound files go to the preferences dialog."),
                "", null,
                "", null,
                null);
    }
}

var aboutToQuit = false;
function quit(parent)
{
    if (aboutToQuit)  // don't execute concurrently
        return;
    aboutToQuit = true;
    if (GCompris.DownloadManager.downloadIsRunning()) {
        var dialog = showDownloadDialog(parent, {
            text: qsTr("Download in progress")
                  + '\n'
                  + qsTr("Download in progress.<br/>'Abort' it to quit immediately."),
            autohide: true,
            reportError: false,
            reportSuccess: false,
            backgroundButtonVisible: false
        });
        dialog.finished.connect(function() {Qt.quit();});
    } else if (GCompris.ApplicationInfo.isMobile) {
        // prevent the user from quitting accidentially by clicking back too often:
        showMessageDialog(parent,
                qsTr("Quit?") +
                '\n' +
                qsTr("Do you really want to quit GCompris?"),
                "YES", function() { Qt.quit(); },
                "NO", function() { aboutToQuit = false; },
                function() { aboutToQuit = false; } );
    } else
        Qt.quit();
}
