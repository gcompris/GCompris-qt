/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "categorization.js" as Activity
import QtQuick.Controls 2.12
import GCompris 1.0

Item {
    id: activityConfiguration
    property Item background
    property string mode: "easy"
    width: flick.width
    height: column.childrenRect.height

    Column {
        id: column
        spacing: 5
        width: parent.width
        height: parent.height
        property alias easyModeBox: easyModeBox
        property alias mediumModeBox: mediumModeBox
        property alias expertModeBox: expertModeBox

        ButtonGroup {
            id: childGroup
        }

        GCDialogCheckBox {
            id: easyModeBox
            text: qsTr("Put together all the items from a category (with score)")
            checked: (mode === "easy") ? true : false
            ButtonGroup.group: childGroup
            onCheckedChanged: {
                if(easyModeBox.checked) {
                    mode = "easy"
                }
            }
        }

        GCDialogCheckBox {
            id: mediumModeBox
            text: qsTr("Put together all the items from a category (without score)")
            checked: (mode === "medium") ? true : false
            ButtonGroup.group: childGroup
            onCheckedChanged: {
                if(mediumModeBox.checked) {
                    mode = "medium"
                }
            }
        }

        GCDialogCheckBox {
            id: expertModeBox
            text: qsTr("Discover a category, grouping items together")
            checked: (mode === "expert") ? true : false
            ButtonGroup.group: childGroup
            onCheckedChanged: {
                if(expertModeBox.checked) {
                    mode = "expert"
                }
            }
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if( dataToSave["data"] === undefined) {
            dataToSave["data"] = Activity.categoriesToSavedProperties(dataToSave)
          if(dataToSave["mode"] === undefined)
            dataToSave["mode"] = mode
        }
        mode = dataToSave["mode"]
    }

    function saveValues() {
        dataToSave["data"] = Activity.categoriesToSavedProperties(dataToSave)
        dataToSave["mode"] = mode;
    }
}
