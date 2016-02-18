/* GCompris - virtualkeyboard_worker.js
 *
 * Copyright (C) 2016 Holger Kaelberer <holger.k@elberer.de>
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

WorkerScript.onMessage = function(msg) {
    var nRows;
    var maxButtons = 0;
    msg.rowListModel.clear();
    msg.rowListModel.sync();
    // validate layout syntax:
    if (!Array.isArray(msg.a) || msg.a.length < 1) {
        msg.error = "VirtualKeyboard: Invalid layout, array of length > 0";
        WorkerScript.sendMessage(msg);
        return;
    }
    nRows = msg.a.length;
    // if we need special keys, put them in a separate row at the bottom:
    if (msg.shiftKey) {
        msg.a.push([ {
            label     : msg.shiftUpSymbol + " Shift",
            shiftLabel: msg.shiftDownSymbol + " Shift",
            specialKeyValue: Qt.Key_Shift } ]);
    }
    var i
    var seenLabels = [];
    for (i = 0; i < msg.a.length; i++) {
        if (!Array.isArray(msg.a[i])) {
            msg.error = "VirtualKeyboard: Invalid layout, expecting array of arrays of keys";
            WorkerScript.sendMessage(msg);
            return;
        }
        if (msg.a[i].length > maxButtons)
            maxButtons = msg.a[i].length;
        for (var j = 0; j < msg.a[i].length; j++) {
            if (undefined === msg.a[i][j].label) {
                msg.error = "VirtualKeyboard: Invalid layout, invalid key object";
                WorkerScript.sendMessage(msg);
                return;
            }
            if (undefined === msg.a[i][j].specialKeyValue)
                msg.a[i][j].specialKeyValue = 0;
            var label = msg.a[i][j].label;
            // if we have a shift key lowercase all labels:
            if (msg.shiftKey && label == label.toLocaleUpperCase())
                label = label.toLocaleLowerCase();
            // drop duplicates (this alters keyboard layout, though!):
            if (seenLabels.indexOf(label) !=-1) {
                msg.a[i].splice(j, 1);
                j--;
                continue;
            }
            msg.a[i][j].label = label;
            seenLabels.push(label);
            if (msg.shiftKey && undefined === msg.a[i][j].shiftLabel)
                msg.a[i][j].shiftLabel = msg.a[i][j].label.toLocaleUpperCase();
        }
    }

    // populate the model:
    for (i = 0; i < msg.a.length; i++) {
        var row = msg.a[i];
        var offset = 0;
        msg.rowListModel.append({
                                    rowNum: i,
                                    offset: offset,
                                    keys: row
                                });
        msg.rowListModel.sync();    // sync once per row, on Android where
                                    // this seems to be executed on the GUI
                                    // thread this leads to an update of
                                    // the Loading overlay
    }
    msg.numRows = i;
    msg.initialized = (msg.numRows > 0);
    msg.error = "";
    WorkerScript.sendMessage(msg);
}
