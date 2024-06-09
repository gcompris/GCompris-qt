/* GCompris - DefaultJsonDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12

import "../singletons"
import "../components"

Column {
    id: defaultJsonDisplay
    property string jsonString: "{}"
    property int labelWidth: 130        // used by InformationLine
    height: Style.displayLineHeight * dataModel.count

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
            height: Style.displayLineHeight
            label: name_
            info: value_
        }
    }
}
