/* GCompris - core.js
 *
 * Copyright (C) 2014
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *   Holger Kaelberer <holger.k@elberer.de>
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/**
 * @file
 * Contains commonly used javascript methods.
 * @ingroup components
 *
 * FIXME: how to include this file in kgenapidox's output?
 */
.pragma library
.import QtQml 2.12 as Qml
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
 * Get the starting level. This is used with --start-level option.
 *
 * @param numberOfLevel the number of levels for this activity.
 * @returns 0 if no --start-level or invalid one (request of a level higher than
 * the level count of the activity), else the level of --start-level option.
 */
function getInitialLevel(numberOfLevel) {
    var level = 0;
    if(GCompris.ActivityInfoTree.startingLevel > 0 && GCompris.ActivityInfoTree.startingLevel < numberOfLevel) {
        level = GCompris.ActivityInfoTree.startingLevel;
    }
    return level;
}

/**
 * Get the next level.
 *
 * @param currentLevel the current level.
 * @param numberOfLevel the number of levels for this activity.
 * @returns If the next level is after the maximum, returns 0 else return currentLevel + 1.
 */
function getNextLevel(currentLevel, numberOfLevel) {
    var level = currentLevel + 1;
    if(numberOfLevel <= level) {
        level = 0;
    }
    return level;
}

/**
 * Get the previous level.
 *
 * @param currentLevel the current level.
 * @param numberOfLevel the number of levels for this activity.
 * @returns If the previous level is 0, returns the last level else return currentLevel - 1.
 */
function getPreviousLevel(currentLevel, numberOfLevel) {
    var level = currentLevel - 1;
    if(level < 0) {
        level = numberOfLevel - 1;
    }
    return level;
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
          'import QtQuick 2.12\n'
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
    var messageText = qsTr("Missing sound files!") + '\n'
                + qsTr("This activity uses language sound files, that are not yet installed on your system.")
                + '\n';
    if(GCompris.ApplicationInfo.isDownloadAllowed) {
        messageText += qsTr("For downloading the needed sound files go to the Configuration dialog.");
    }
    if (!GCompris.DownloadManager.areVoicesRegistered(GCompris.ApplicationSettings.locale)) {
        showMessageDialog(parent,
                messageText,
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
    } else if (GCompris.ApplicationSettings.exitConfirmation) {
        // prevent the user from quitting accidentially by clicking back too often:
        showMessageDialog(parent,
                qsTr("Quit?") +
                '\n' +
                qsTr("Do you really want to quit GCompris?"),
                qsTr("Yes"), function() { Qt.quit(); },
                qsTr("No"), function() { aboutToQuit = false; },
                function() { aboutToQuit = false; } );
    } else {
        Qt.quit();
    }
}

function isLeftToRightLocale(locale) {
    var localeShort = GCompris.ApplicationInfo.getVoicesLocale(locale)
    return (localeShort != "ar" && localeShort != "he");
}

function localeNeedSpaces(locale) {
    // Returns false for languages with no spaces between words
    var localeShort = GCompris.ApplicationInfo.getVoicesLocale(locale)
    var noSpacesLanguages = [ "zh_TW", "zh_CN" ]
    return (noSpacesLanguages.indexOf(localeShort) === -1)
}

function resolveLocale(localeToSet) {
    // Resolve the locale used to a real one
    // if Gcompris' locale selected, we want the real locale
    // and if GCompris' locale is system, then resolve again
    var newLocale = localeToSet
    if(newLocale === "system") {
        newLocale = GCompris.ApplicationSettings.locale
        // Remove .UTF-8
        if(newLocale.indexOf('.') != -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'))
        }
        return newLocale
    }
    else {
        return localeToSet
    }
}

function convertNumberToLocaleString(decimalNumber, locale = GCompris.ApplicationInfo.localeShort, format = 'f', precision = 0) {
    // Special case for Arabic, we still want to use Arabic numerals, not Eastern Arabic numerals
    // For now, we consider dot separated numbers for Arabic
    var localeToConvertTo = (locale.startsWith("ar") ? "he" : locale);
    return decimalNumber.toLocaleString(Qt.locale(localeToConvertTo), format, precision);
}

function convertNumberToLocaleCurrencyString(number, locale) {
    // Special case for Arabic, we still want to use Arabic numerals, not Eastern Arabic numerals but we want to keep the Arabic currency
    var localeToConvertTo = (locale.startsWith("ar") ? "he" : locale);
    return number.toLocaleCurrencyString(Qt.locale(localeToConvertTo), Qt.locale(locale).currencySymbol(Qml.Locale.CurrencySymbol));
}

/**
 * Function that returns the best cell size for a grid of a given
 * width and height and a number of items.
 *
 * Formula inspired from https://math.stackexchange.com/questions/466198/algorithm-to-get-the-maximum-size-of-n-squares-that-fit-into-a-rectangle-with-a
 *
 * @param x_: grid width
 * @param y_: grid height
 * @param n_: number of items to place in the grid
 * @param extra_: optional extra number to add to sides calculation
 */
function fitItems(x_, y_, n_, extra_) {
    var sx
    var sy

    if(x_ <= 0 || y_ <= 0 || n_ <= 0)
        return 10; // return default value that will be erased later, to avoid crash on Android

    if(extra_ === undefined)
        extra_ = 0;

    var px = Math.ceil(Math.sqrt(n_ * x_ / y_)) + extra_;
    if (Math.floor(px * y_ / x_) * px < n_) {
        sx = y_ / Math.ceil(px * y_ / x_);
    } else {
        sx = x_ / px;
    }

    var py = Math.ceil(Math.sqrt(n_ * y_ / x_)) + extra_;
    if (Math.floor(py * x_ / y_) * py < n_) {
        sy = x_ / Math.ceil(x_ *  py / y_);
    } else {
        sy = y_ / py;
    }

    return Math.max(sx, sy);
}
