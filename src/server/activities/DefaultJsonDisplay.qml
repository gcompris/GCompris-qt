/* GCompris - DefaultJsonDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"
import "../components"

Column {
    id: defaultJsonDisplay
    property string jsonString: "{}"
    width: parent.width
    height: Style.lineHeight * dataModel.count

    ListModel { id: dataModel }

    onJsonStringChanged: {
        dataModel.clear()
        var dataObj = JSON.parse(jsonString)
        delete dataObj.level
        for (var kkey in dataObj) {
            dataModel.append({ name_: kkey, value_: String(dataObj[kkey]) })
        }
    }

    Repeater {
        model: dataModel
        delegate: InformationLine {
            width: defaultJsonDisplay.width
            label: name_
            info: value_
        }
    }
}
