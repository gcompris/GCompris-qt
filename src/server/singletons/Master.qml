/* GCompris - Master.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma Singleton

import QtQuick
import core 1.0

import "qrc:/gcompris/src/server/server.js" as Server

Item {
    property string activityBaseUrl: "qrc:/gcompris/src/server/activities"
    property var allActivities: ({})        // From ActivityInfoTree.menuTreeFull
    property var availableActivities: []    // Activities with available DataDisplay.qml
    property alias userModel: userModel
    property alias filteredUserModel: filteredUserModel
    property alias groupModel: groupModel
    property alias activityModel: activityModel
    property alias allActivitiesModel: allActivitiesModel
    property alias datasetModel: datasetModel
    property alias filteredDatasetModel: filteredDatasetModel
    property bool trace: false
    property int groupFilterId: -1     // contains selected group id

    signal netLog(string message)

    File { id: file }

    ListModel { id: groupModel }
    ListModel { id: userModel }
    ListModel { id: filteredUserModel }     // For checkBoxes lists (multiselection)
    ListModel { id: activityModel }         // Contains current user or group activities
    ListModel { id: allActivitiesModel }
    ListModel { id: datasetModel }
    ListModel { id: filteredDatasetModel }  // For checkBoxes lists (multiselection)
    ListModel { id: tmpModel }              // Used for temporary requests inside functions

//// Groups functions
    function loadGroups() {
        modelFromRequest(groupModel, "SELECT * FROM _group_users ORDER BY group_name"
                         , { group_checked: false }
                         )
        listModelSort(groupModel, (a, b) => (a.group_name.localeCompare(b.group_name)));
        if (trace) console.warn(groupModel.count, "Groups loaded")
    }

    function createGroup(groupName, groupDescription) {     // string, string
        var groupId = databaseController.addGroup(groupName, groupDescription)
        if ( groupId !== -1) {
            groupModel.append({ "group_id": groupId,
                                "group_name": groupName,
                                "group_description": groupDescription,
                                "group_checked": false
                              })
            reorderElement(groupModel, groupModel.count - 1, "group_name")
            if (trace) console.warn("Group created:", groupName, groupDescription)
        }
        return groupId
    }

    function deleteGroup(index) {       // int
        var group = groupModel.get(index)
        if (databaseController.deleteGroup(group.group_id, group.group_name)) {
            groupModel.remove(index)
            if (trace) console.warn("Group deleted:", group.group_id ," - ", group.group_name)
            return true
        }
        return false
    }

    function updateGroup(idx, newGroupName, groupDescription) {   // int, string, string
        if (databaseController.updateGroup(groupModel.get(idx).group_id, newGroupName, groupDescription) !== -1) {
            groupModel.setProperty(idx, "group_name", newGroupName)
            groupModel.setProperty(idx, "group_description", groupDescription)
            reorderElement(groupModel, idx, "group_name")                  // Reorder if name has changed
            if (trace) console.warn("Group updated:", newGroupName)
            return true
        }
        return false
    }

//// Users functions
    function loadUsers() {
        modelFromRequest(userModel, "SELECT * FROM _user_groups ORDER BY user_name"
                         , { user_checked: false
                             , user_status: NetConst.NOT_CONNECTED
                             , user_received: 0 }
                         )
        listModelSort(userModel, (a, b) => (a.user_name.localeCompare(b.user_name)));
        if (trace) console.warn(userModel.count, "Users loaded")
    }

    function createUser(userName, userPassword, groupsName, groupsIndex) {      // string, string, array[int], array[int]
        var userId = databaseController.addUser(userName, userPassword)
        if (userId !== -1) {
            // if groupsIndex is empty, read indexes from group names (importing from csv)
            if (groupsIndex.length === 0) {
                var quoted = []
                for (var i = 0; i < groupsName.length; i++)
                    quoted.push("'" + groupsName[i].replace("'", "''") + "'")
                modelFromRequest(tmpModel, "SELECT group_id FROM group_ WHERE group_name in (" + quoted.join(",") + ")  ORDER BY group_id")
                for (i = 0; i < tmpModel.count; i++)
                    groupsIndex.push(tmpModel.get(i).group_id)
            }

            for (var gid = 0; gid < groupsIndex.length; gid++)      // Add groups for user in table group_user_
                databaseController.addUserToGroup(userId, parseInt(groupsIndex[gid]))
            userModel.append({   "user_id": userId,
                                 "user_name": userName,
                                 "user_password": userPassword,
                                 "groups_id": groupsIndex.join(","),
                                 "groups_name": groupsName.join(","),
                                 "user_checked": false,
                                 "user_status": NetConst.NOT_CONNECTED
                             })
            reorderElement(userModel, userModel.count - 1, "user_name") // Reorder with new name
            filterUsers(filteredUserModel, true)
            if (trace) console.warn("User created:", userName, groupsName)
        }
        return userId
    }

    function deleteUser(userId) {       // int
        if (databaseController.deleteUser(userId)) {
            var idx = findIndexInModel(userModel, function(item) { return item.user_id === userId })
            userModel.remove(idx)
            if (trace) console.warn("User deleted", userId)
        }
    }

    function updateUser(idx, userId, userName, userPassword, groupsIds, groupsName) {     // int, int, string, string, array[int], array[int]
        if (databaseController.updateUser(userId, userName, userPassword)) {
            databaseController.removeAllGroupsForUser(userId)
            for (var gid = 0; gid < groupsIds.length; gid++)            // Add groups for user in table group_user_
                databaseController.addUserToGroup(userId, parseInt(groupsIds[gid]))
            if (trace) console.warn("User updated:", userName, groupsName.join(","))
            loadUsers()
            filterUsers(filteredUserModel, true)   // reload filteredUserModel from userModel
            return true
        }
        return false
    }

    function addGroupUser(pupilModel, idx, groupIds) {      // model, int, array[int], array[string]
        var userId = pupilModel.get(idx).user_id
        var currentGroups = pupilModel.get(idx).groups_id.split(",").map(Number)    // If no map(), strings can't be compared with groupIds integers
        for (var j = 0; j < groupIds.length; j++ ) {
            if (currentGroups.indexOf(groupIds[j]) === -1)
                databaseController.addUserToGroup(userId, groupIds[j])
        }
        var userIdx = findIndexInModel(userModel, function(item) { return item.user_id === userId })
        modelFromRequest(tmpModel, `SELECT * FROM _user_groups WHERE user_id==${userId}`)   // Safe with integers
        var group = tmpModel.get(0)
        userModel.setProperty(userIdx, "groups_id", group.groups_id)
        userModel.setProperty(userIdx, "groups_name", group.groups_name)
        if (trace) console.warn("Groups for user added:", group.user_name, group.groups_name)
    }

    function removeGroupUser(pupilModel, idx, groupIds) {   // model, int, array[int]
        var userId = pupilModel.get(idx).user_id
        for (var j = 0; j < groupIds.length; j++ )
            databaseController.removeUserGroup(userId, groupIds[j])
        var userIdx = findIndexInModel(userModel, function(item) { return item.user_id === userId })
        modelFromRequest(tmpModel, `SELECT * FROM _user_groups WHERE user_id==${userId}`)   // Safe with integers
        var group = tmpModel.get(0)
        userModel.setProperty(userIdx, "groups_id", group.groups_id)
        userModel.setProperty(userIdx, "groups_name", group.groups_name)
        if (trace) console.warn("Groups for user removed:", pupilModel.get(idx).user_name, groupIds)
    }

    function filterUsers(model, keepSelection) {   // bool - Users filtering should keep selection now
        if (trace) console.warn("Users filtered")
        var selectedIds = []                // array of checked ids to be restored
        if (keepSelection) {
            for (var j = 0; j < model.count; j++) {
                var userSel = model.get(j)
                if (userSel.user_checked)
                    selectedIds.push(userSel.user_id)
            }
        }
        model.clear()
        var empty = (groupFilterId === -1)
        for (var i = 0; i < userModel.count; i++) {
            var user = JSON.parse(JSON.stringify(userModel.get(i)))     // Make a deep copy
            if (keepSelection)
                if (selectedIds.includes(user.user_id))                 // Check if it was already checked
                    user.user_checked = true
            if (empty) {
                model.append(user)
                continue
            }
            var gids = user.groups_id.split(",").map(Number)    // split and convert elements to int
            var show = gids.includes(groupFilterId)             // check if user belongs to selected groups
            if (show) {
                model.append(user)
            }
        }
    }

    function checkPassword(login, password) {   // string, string
//        console.warn("Looking for", login, password)
        var user = findObjectInModel(userModel, function(item) { return item.user_name === login })
        if (user !== null) {
            if (user.user_password === password) {
//                console.warn("Found", login, password)
                return user.user_id
            } else {
                user.user_status = NetConst.BAD_PASSWORD_INPUT
                filterUsers(filteredUserModel, true)
                return -1
            }
        }
        return -1
    }

    function setStatus(userId, newStatus) {
        var idx = findIndexInModel(filteredUserModel, function(item) { return item.user_id === userId })
        if (idx !== -1) {
            filteredUserModel.setProperty(idx, "user_status", newStatus)
        }
        idx = findIndexInModel(userModel, function(item) { return item.user_id === userId })
        if (idx !== -1) {
            userModel.setProperty(idx, "user_status", newStatus)
        }
    }

    //// Others functions
    function modelFromRequest(model, request, add = {}) {     // model, string, obj. Send request to database. Rebuild model with request answer.
        model.clear()
        var jsonModel = JSON.parse(databaseController.selectToJson(request))
        for (var i = 0; i < jsonModel.length; i++) {
            model.append(Object.assign(jsonModel[i], add))
        }
    }

    function findObjectInModel(model, criteria) {    // model, function. Returns first object with matching criteria
      for(var i = 0; i < model.count; ++i)
          if (criteria(model.get(i)))
              return model.get(i)
      return null
    }

    function findIndexInModel(model, criteria) {    // model, function. Returns first index with matching criteria
      for(var i = 0; i < model.count; ++i)
          if (criteria(model.get(i)))
              return i
      return -1
    }

    function copyModel(modelIn, modelOut) {         // model, model
        modelOut.clear()
        for(var i = 0; i < modelIn.count; ++i)
            modelOut.append(modelIn.get(i))
    }

    function getSelectedIndexes(model, checkKey, indexKey) {
        var ids = []
        for(var i = 0; i < model.count; ++i)
            if (model.get(i)[checkKey])
                ids.push(model.get(i)[indexKey])
        return ids.join(",")
    }

    function unCheckModel(model, checkKey) {
        for (var i = 0; i < model.count; i++) {
            model.setProperty(i, checkKey, false)
        }
    }

    // reorderElement doesn't sort, but move an element to the correct position in an allready sorted model
    function reorderElement(model, idx, fieldName) {         // model, int, string
        if (idx > 0) {
            if (model.get(idx - 1)[fieldName].localeCompare(model.get(idx)[fieldName]) > 0) {   // Compare with previous
                model.move(idx, idx - 1, 1)
                reorderElement(model, idx - 1, fieldName)
                return
            }
        }
        if (idx < model.count - 1) {
            if (model.get(idx + 1)[fieldName].localeCompare(model.get(idx)[fieldName]) < 0) {   // Compare with next
                model.move(idx, idx + 1, 1)
                reorderElement(model, idx + 1,fieldName)
                return
            }
        }
    }

    // Source: https://community.esri.com/t5/arcgis-appstudio-blog/sorting-qml-listmodels/ba-p/895823
    // Not a stable sort algorithm
    function listModelSort(listModel, compareFunction) {
        let indexes = [ ...Array(listModel.count).keys() ]
        indexes.sort( (a, b) => compareFunction( listModel.get(a), listModel.get(b) ) )
        let sorted = 0
        while ( sorted < indexes.length && sorted === indexes[sorted] ) sorted++
        if ( sorted === indexes.length ) return
        for ( let i = sorted; i < indexes.length; i++ ) {
            listModel.move( indexes[i], listModel.count - 1, 1 )
            listModel.insert( indexes[i], { } )
        }
        listModel.remove( sorted, indexes.length - sorted )
    }

    // Merge sort algorithm for list models. Stable sort algorithm (previous sort is preserved)
    // https://en.wikipedia.org/wiki/Merge_sort, https://fr.wikipedia.org/wiki/Tri_fusion
    function mergeSortListModel(listModel, compareFunction) {

        function merge(list1, list2) {     // array, array
            if (!list1.length) return list2
            if (!list2.length) return list1
            if (compareFunction(listModel.get(list1[0]), listModel.get(list2[0])) > 0)
                return [list2[0]].concat(merge(list1, list2.slice(1, list2.length)))
            else
                return [list1[0]].concat(merge(list1.slice(1, list1.length), list2))
        }

        function mergeSort(list) {     // array
            if (list.length < 2) return list
            var pos = Math.floor(list.length / 2)
            return merge(mergeSort(list.slice(0, pos)), mergeSort(list.slice(pos, list.length)))
        }

        var indexes = [ ...Array(listModel.count).keys() ]
        var sorted = mergeSort(indexes)
        // Copy sorted elements into listModel
        for (var i = 0; i < sorted.length; i++)
            listModel.append(listModel.get(sorted[i]))
        listModel.remove(0, indexes.length)
    }

    function loadDatabase(fileName) {               // string
        if (databaseController.isDatabaseLoaded())
            databaseController.unloadDatabase();
        databaseController.loadDatabase(fileName)
    }

    function unLoadDatabase() {
        databaseController.unloadDatabase()
        userModel.clear()
        groupModel.clear()
    }

    function fileExists(fileName) {
        if ((fileName === null) || (fileName === ""))
            return false
        return (databaseController) ? databaseController.fileExists(fileName) : false
    }

    function checkTeacher(login, password) {
        return databaseController.checkTeacher(login, password)
    }

    function createTeacher(login, password, crypted) {
        databaseController.createTeacher(login, password, crypted)
    }

//// Activity functions
    function loadAllActivities(model) {
        modelFromRequest(model, `SELECT * FROM activity_`
                         , { activity_checked: false, activity_title: "" }
                         )
        for (var i = 0; i < model.count; i++)
            model.setProperty(i, "activity_title", allActivities[model.get(i).activity_name].title)
        listModelSort(model, (a, b) => (a.activity_title.localeCompare(b.activity_title)))
    }

    function loadUserAllActivities(model, userId) {     // model, int
        modelFromRequest(model, `SELECT * FROM _user_activity_result WHERE user_id=${userId}`
                         , { activity_checked: false, activity_title: "" }
                         )
        for (var i = 0; i < model.count; i++)
            model.setProperty(i, "activity_title", allActivities[model.get(i).activity_name].title)
        listModelSort(model, (a, b) => (a.activity_title.localeCompare(b.activity_title)))
    }

    function loadUserActivities(model, userList, activityList, keepSelection = false) {    // model, array, array, bool
        var clauses = []
        clauses.push(`user_.user_id=result_.user_id`)
        clauses.push(`activity_.activity_id=result_.activity_id`)
        if (userList.length) clauses.push(`result_.user_id in (` +  userList.join(",") + `)`)
        modelFromRequest(model, `SELECT DISTINCT result_.activity_id, activity_name
                         FROM result_, user_, activity_
                        WHERE ` + clauses.join(" AND ")
                         , { activity_checked: false, activity_title: "" }
                         )

        for (var i = 0; i < model.count; i++) {
            var activity = model.get(i)
            activity.activity_title = allActivities[activity.activity_name].title
            if (keepSelection)
                if (activityList.includes(activity.activity_id))                 // Check if it was already checked
                    activity.activity_checked = true
        }
        listModelSort(model, (a, b) => (a.activity_title.localeCompare(b.activity_title)))
    }

    function loadGroupActivities(model, groupId) {
        modelFromRequest(model, `SELECT * FROM _group_activity_result WHERE group_id=${groupId}`
                         , { activity_checked: false, activity_title: "" }
                         )
        for (var i = 0; i < model.count; i++)
            model.setProperty(i, "activity_title", allActivities[model.get(i).activity_name].title)
        listModelSort(model, (a, b) => (a.activity_title.localeCompare(b.activity_title)))
    }

    // Build ids list from model's checked items
    function foldDownToList(foldDown, list, modelId, checked) {
        switch (modelId) {
        case -2:    // All selected
            while (list.length) list.pop()
            for (var i = 0; i < foldDown.foldModel.count; i++)
                list.push(foldDown.foldModel.get(i)[foldDown.indexKey])
            break
        case -1:    // None selected
            while (list.length) list.pop()
            break
        default:    // Id clicked
            if (checked) {
                if (!list.includes(modelId))
                    list.push(modelId)
            } else {
                const idx = list.indexOf(modelId)
                if (idx > -1)
                    list.splice(idx, 1)
            }
            break
        }
    }

    function addActivityDataForUser(userId, activityName, rawData) {    // int, string, string
        // Extract and delete success and duration from json rawData
        var data = JSON.parse(rawData)
        var success = data["success"]
        var duration = data["duration"]
        delete data["success"]
        delete data["duration"]
        rawData = JSON.stringify(data)
        databaseController.addDataToUser(userId, activityName, rawData, success, duration)
        // Update userModel
        var idx = findIndexInModel(userModel, function(item) { return item.user_id === userId })
        netLog(userModel.get(idx).user_name + " -> " + Server.shortActivityName(activityName))
        userModel.setProperty(idx, "user_received", userModel.get(idx).user_received + 1)
        // Update filteredUserModel
        idx = findIndexInModel(filteredUserModel, function(item) { return item.user_id === userId })
        filteredUserModel.setProperty(idx, "user_received", filteredUserModel.get(idx).user_received + 1)
    }

    function getActivityId(activityName) {
        var json = JSON.parse(databaseController.selectToJson(`SELECT activity_id FROM activity_ WHERE activity_name='${activityName}'`))
        if(!json || !json[0]) {
            return -1;
        }
        return json[0]["activity_id"]
    }

    function getActivityName(activityId) {
        var json = JSON.parse(databaseController.selectToJson(`SELECT activity_name FROM activity_ WHERE activity_id='${activityId}'`))
        return json[0]["activity_name"]
    }

//// Datasets functions
    function loadDatasets() {
        modelFromRequest(datasetModel, "SELECT * FROM _dataset_activity"
                         , { dataset_checked: false }
                         )
        if (trace) console.warn(groupModel.count, "Datasets loaded")
    }

    function filterDatasets(activityId, keepSelection) {   // bool - dataset filtering should keep selection now
        if (trace) console.warn("Datasets filtered")
        var selectedIds = []                // array of checked ids to be restored
        if (keepSelection) {
            for (var j = 0; j < datasetModel.count; j++) {
                var userSel = datasetModel.get(j)
                if (userSel.user_checked)
                    selectedIds.push(userSel.user_id)
            }
        }
        filteredDatasetModel.clear()
        var empty = (activityId === -1)
        for (var i = 0; i < datasetModel.count; i++) {
            var dataset = JSON.parse(JSON.stringify(datasetModel.get(i)))     // Make a deep copy
            if (keepSelection)
                if (selectedIds.includes(dataset.dataset_id))                 // Check if it was already checked
                    dataset.dataset_checked = true
            if (empty) {
                filteredDatasetModel.append(dataset)
                continue
            }
            var datasetActivityId = dataset.activity_id
            var show = datasetActivityId == activityId             // check if user belongs to selected groups
            if (show) {
                filteredDatasetModel.append(dataset)
            }
        }
    }

    function createDataset(datasetName, activityId, objective, difficulty, content) {     // string, string, int, string
        var datasetId = databaseController.addDataset(datasetName, activityId, objective, difficulty, content)
        if (datasetId !== -1) {
            datasetModel.append({ "dataset_id": datasetId,
                                "activity_id": activityId,
                                "activity_name": getActivityName(activityId),
                                "dataset_name": datasetName,
                                "dataset_objective": objective,
                                "dataset_difficulty": difficulty,
                                "dataset_content": content,
                                "dataset_checked": false
                              })
            if (trace) console.warn("Dataset created:", datasetName, objective)
        }
        return datasetId
    }

    function deleteDataset(datasetId) {       // int
        var dataset
        var index = -1;
        // find the index in the model
        for (var j = 0; j < datasetModel.count; j++) {
            var dataSel = datasetModel.get(j)
            if (dataSel.dataset_id == datasetId) {
                dataset = dataSel
                index = j
                break;
            }
        }

        if (databaseController.deleteDataset(dataset.dataset_id)) {
            datasetModel.remove(index)
            if (trace) console.warn("Dataset deleted:", dataset.dataset_id ," - ", dataset.dataset_name)
            return true
        }
        return false
    }

    function getDatasetModelId(datasetId) {       // int
        // find the index in the model
        for (var j = 0; j < datasetModel.count; j++) {
            var dataSel = datasetModel.get(j)
            if (dataSel.dataset_id == datasetId) {
                return j
            }
        }
    }
    function getDataset(datasetId) {       // int
        // find the index in the model
        for (var j = 0; j < datasetModel.count; j++) {
            var dataSel = datasetModel.get(j)
            if (dataSel.dataset_id == datasetId) {
                return dataSel
            }
        }
    }

    function updateDataset(datasetId, datasetName, objective, difficulty, content) {   // int, string, string, int, string
        var datasetModelId = getDatasetModelId(datasetId)
        if (databaseController.updateDataset(datasetId, datasetName, objective, difficulty, content) !== -1) {
            datasetModel.setProperty(datasetModelId, "dataset_name", datasetName)
            datasetModel.setProperty(datasetModelId, "dataset_objective", objective)
            datasetModel.setProperty(datasetModelId, "dataset_difficulty", difficulty)
            datasetModel.setProperty(datasetModelId, "dataset_content", content)
            if (trace) console.warn("Dataset updated:", datasetName)
            return true
        }
        return false
    }

    function storeActivitiesWithDatasetInDatabase() {
        var activities = ActivityInfoTree.menuTreeFull
        for (var key in Object.keys(activities)) {  // Convert numeric keys to short activity name keys
            if(activities[key]['acceptDataset']) {
                var activityName = activities[key]['name'].slice(0,activities[key]['name'].lastIndexOf('/'))
                var activityId = getActivityId(activityName)
                if(activityId == -1) {
                    databaseController.addActivity(activityName)
                }
            }
        }
    }

    function initialize() {
        if (trace) console.warn("Initialize Master component")
        loadGroups()
        loadUsers()
        filterUsers(filteredUserModel, false)
        storeActivitiesWithDatasetInDatabase()
        loadAllActivities(activityModel)
        loadAllActivities(allActivitiesModel)
        loadDatasets()
    }

    Component.onCompleted: {
        var activities = ActivityInfoTree.menuTreeFull
        if (trace) console.warn("Starting Master component")
        for (var key in Object.keys(activities)) {  // Convert numeric keys to short activity name keys
            var newKey = activities[key]['name'].slice(0,activities[key]['name'].lastIndexOf('/'))
            allActivities[newKey] = activities[key]
            if (file.exists(`${activityBaseUrl}/${newKey}/DataDisplay.qml`))
                availableActivities.push(newKey)
        }
        // Sort by translated activity title
        availableActivities.sort((a, b) => (allActivities[a].title.localeCompare(allActivities[b].title)))
    }
}
