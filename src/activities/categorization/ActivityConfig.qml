/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import "../../core"
import "categorization.js" as Activity
import QtQuick.Controls 1.5
import GCompris 1.0

Item {
    id: activityConfiguration
    property Item background
    property string mode: "easy"
    width: if(background) background.width
    height: column.childrenRect.height

    Column {
        id: column
        spacing: 5
        width: parent.width
        height: parent.height
        property alias easyModeBox: easyModeBox
        property alias mediumModeBox: mediumModeBox
        property alias expertModeBox: expertModeBox

        ExclusiveGroup {
            id: configOptions
        }

        GCDialogCheckBox {
            id: easyModeBox
            width: column.width - 50
            text: qsTr("Put together all the items from a category (with score)")
            checked: (mode === "easy") ? true : false
            exclusiveGroup: configOptions
            onCheckedChanged: {
                if(easyModeBox.checked) {
                    mode = "easy"
                }
            }
        }

        GCDialogCheckBox {
            id: mediumModeBox
            width: easyModeBox.width
            text: qsTr("Put together all the items from a category (without score)")
            checked: (mode === "medium") ? true : false
            exclusiveGroup: configOptions
            onCheckedChanged: {
                if(mediumModeBox.checked) {
                    mode = "medium"
                }
            }
        }

        GCDialogCheckBox {
            id: expertModeBox
            width: easyModeBox.width
            text: qsTr("Discover a category, grouping items together")
            checked: (mode === "expert") ? true : false
            exclusiveGroup: configOptions
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
