/* GCompris - server.js
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.9 as Quick

var currentLevel = 0
var numberOfLevel = 4
var items

var dataArray = [{"color":"red"},{"color":"blue"},{"color":"yellow"}]

function savePupilNameGroups(pupilIndex) {

}

function setModifyPupilGroupDialogCheckboxes(pupilIndex) {
    groupsNamesArray.forEach((groupName) => {
      console.log(groupName)
    })

    var test = []
    test = items.groupNamesListView.contentItem
    print(test)
}

