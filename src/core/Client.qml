/* GCompris - Client.qml
 *
 * Copyright (C) 2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

Item {
    id: client
    property var startDate: null

    signal dataSent()

    function startTiming() {        // Call this function at the end of initLevel()
        startDate = new Date(Date.now())
    }

    function sendToServer(ok) {     // Call this function after checkResult()
        if(getDataCallback) {
            var data = getDataCallback()
            data["success"] = ok
            if (startDate) {
                var endDate = new Date()
                data["duration"] = Math.floor((endDate - startDate) / 1000)
            }
            data["level"] = items.currentLevel + 1
            clientNetworkMessages.sendActivityData(ActivityInfoTree.currentActivity.name, data)
            dataSent()
        }
    }

    // Overload this function in each activity
    property var getDataCallback: null
}
