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

/**
 * @file
 * Contains commonly used javascript methods.
 * @ingroup components
 *
 * FIXME: how to include this file in kgenapidox's output?
 */
.pragma library
.import QtQml 2.2 as Qml
.import GCompris 1.0 as GCompris

/**
 * Shuffle the array @p o and returns it.
 *
 * @param o Array to shuffle.
 * @returns A shuffled array.
 */
function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

/**
 * Return the filename of the audio voices file for the passed letters
 * (or a number) @p c
 *
 * A letter maybe a digraph or more characters (a pair of characters used
 * to write one phoneme). In this case the result have the form U0066U0068.ogg
 *
 * The returned audio file. has the suffix .ogg
 *
 * @param c Letter or number character.
 * @return A filename for the audio file for the passed letter @p c of the
 *         form U0033.ogg
 */
function getSoundFilenamForChar(c)
{
    var results = ''
    for(var i = 0; i < c.length; ++i) {
        var result = "U";
        var codeHex = c.toLowerCase().charCodeAt(i).toString(16).toUpperCase();
        while (codeHex.length < 4) {
            codeHex = "0" + codeHex;
        }
        results += "U" + codeHex
    }
    results += ".$CA";
    return results;
}

/**
 * Create and present a GCDialog with the given parameters
 *
 * Instantiates a GCDialog object dynamically as child of the  passed
 * parent object. After one of the buttons passed in the buttonHandler parameter
 * has been pressed, the dialog will be closed and destroyed automatically.
 *
 * @param parent            QML parent object
 * @param informativeText   Informative text
 * @param button1Text the   Label of the first button
 * @param button1Callback   Callback handler for the first button
 * @param button2Text       Label of the second button
 * @param button2Callback   Callback handler for the second button
 * @param closeCallback     Callback handler for the close button
 * @returns The GCDialog object upon success, null otherwise
 *
 * @sa GCDialog
 */
function showMessageDialog(parent, informativeText,
                           button1Text, button1Callback,
                           button2Text, button2Callback,
                           closeCallback) {
    //console.debug("Core.showMessageDialog: parent=" + parent + " backtrace="); console.trace();
    var qmlStr =
          'import QtQuick 2.6\n'
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

/**
 * Destroy dialog @p dialog
 *
 * @param dialog A dynamically created GCDialog or DownloadDialog
 */
function destroyDialog(dialog) {
    if (dialog) {
        dialog.stop();
        dialog.destroy();
    }
}

var downloadDialogComponent = null;

/**
 * Create and present a DownloadDialog with the given parameters.
 *
 * Instantiates a DownloadDialog object dynamically as child of the  passed
 * parent object. The DownloadDialog.dynamic property will be set, and the
 * dialog will be destroyed dynamically after closing.
 *
 * @param parent     QML parent object
 * @param properties Object with property-value pairs used to parametrize the new
 *                   object. Used directly as properties parameter of
 *                   Component.createObject()
 * @returns          A newly created DownloadDialog object upon success, null
 *                   otherwise.
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
        dialog = downloadDialogComponent.createObject(parent, properties);
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

/**
 * Helper checking for availability of audio voices for the current locale and
 * informing the user in case they're missing.
 *
 * Can be used by acitivities that depend on audio voices to inform the user
 * of missing resources during startup.
 *
 * @param parent Parent QML object.
 */
function checkForVoices(parent)
{
    if (!GCompris.DownloadManager.areVoicesRegistered()) {
        showMessageDialog(parent,
                qsTr("Missing sound files!") + '\n'
                + qsTr("This activity uses language sound files, that are not yet installed on your system.")
                + '\n'
                + qsTr("For downloading the needed sound files go to the preferences dialog."),
                "", null,
                "", null,
                null);
    }
}

var aboutToQuit = false;
/**
 * Central function for quitting GCompris.
 *
 * Should be used everywhere instead of Qt.quit(), warning in case of running
 * downloadloads and showing a confirmation dialog on mobile devices.
 * Call Qt.quit() itself upon confirmation.
 *
 * @param parent QML parent object used for the dynamic dialog.
 */
function quit(parent)
{
    if (aboutToQuit)  // don't execute concurrently
        return;
    aboutToQuit = true;
    GCompris.ApplicationSettings.previousHeight = parent.height;
    GCompris.ApplicationSettings.previousWidth = parent.width;
    GCompris.ApplicationInfo.abandonAudioFocus()

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
                qsTr("Yes"), function() { Qt.quit(); },
                qsTr("No"), function() { aboutToQuit = false; },
                function() { aboutToQuit = false; } );
    } else
        Qt.quit();
}

function isLeftToRightLocale(locale) {
    var localeShort = GCompris.ApplicationInfo.getVoicesLocale(locale)
    return (localeShort != "ar" && localeShort != "he");
}
