/* GCompris - editor_worker.js
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

Qt.include("../balancebox_common.js")

WorkerScript.onMessage = function(msg) {
    var maxContactValue = 1;
    msg.lastBallIndex = -1;
    msg.lastGoalIndex = -1;
    msg.lastOrderNum = 0;
    msg.mapModel.clear();
    msg.targetList = [];
    for (var row = 0; row < msg.level.map.length; row++) {
        for (var col = 0; col < msg.level.map[row].length; col++) {
            var contactValue = "";
            var value = parseInt(msg.level.map[row][col]);  // always enforce number
            var orderNum = (value & 0xFF00) >> 8;
            if (orderNum > 0 && msg.level.targets[orderNum - 1] === undefined) {
                console.error("Invalid level: orderNum " + orderNum
                              + " without target value!");
            } else if (orderNum > 0) {
                if (orderNum > msg.lastOrderNum)
                    msg.lastOrderNum = orderNum;
                var target = msg.level.targets[orderNum-1]
                msg.targetList.push(parseInt(target));
                contactValue = Number(target).toString();
                if (target >= maxContactValue)
                    maxContactValue = target + 1;
            }
            msg.mapModel.append({
                "row": row,
                "col": col,
                "value": value,
                "contactValue": (orderNum > 0) ? contactValue : ""
            });
            if (value & GOAL) {
                if (msg.lastGoalIndex > -1) {
                    console.error("Invalid level: multiple goal locations: row/col="
                                  + row + "/" + col);
                    return;
                }
                msg.lastGoalIndex = row * msg.level.map.length + col;
            }
            if (value & START) {
                if (msg.lastBallIndex > -1) {
                    console.error("Invalid level: multiple start locations: row/col="
                                  + row + "/" + col);
                    return;
                }
                msg.lastBallIndex = row * msg.level.map.length + col;
            }
        }
        msg.mapModel.sync();  // sync per row
    }
    msg.maxContactValue = maxContactValue;
    // send result back to the gui-thread
    WorkerScript.sendMessage(msg);
}
