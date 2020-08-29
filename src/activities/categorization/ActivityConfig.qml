/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
            text: qsTr("Put together all the elements from a category (with score)")
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
            text: qsTr("Put together all the elements from a category (without score)")
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
            text: qsTr("Discover a category, grouping elements together")
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
