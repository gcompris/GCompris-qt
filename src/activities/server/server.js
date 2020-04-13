/* GCompris - server.js
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
.pragma library
.import QtQuick 2.6 as Quick

var currentLevel = 0
var numberOfLevel = 4
var items

var dataArray = [{"color":"red"},{"color":"blue"},{"color":"yellow"}]
var groupsNamesArray = []

var debugString = "Aurélien2 Richelieu;2004;CP-CE1-CE2-Judo-Théâtre\nNadia Comtois;2003;CP-CE1-CE2-Judo-Théâtre-Maison\nRaphaël Thibault;2003;CP-CE1-CE2\nAnastasie Firmin;2001;CP-CE1-CE2\nArianne Vincent;2001;CE2-Judo-Théâtre\nMarlène Porcher;2001;CP-CE1-CE2-Théâtre\nGervais Plourde;2001;CP-CE2-Judo-Théâtre\nMadeline François;2002;CP-CE1-CE2-Théâtre\nSolange Géroux;2003;CP-CE2-Judo-Théâtre-volley\nAxel Deniau;2002;CP-CE2-Judo-Théâtre"

groupsNamesArray = ["CP","CE1","CE2","Judo","Théâtre"]

groupsNamesArray.push("Chant")

var pupilsNamesArray = []


//        [["Aurélien Richelieu","2004",["CP","CE1","CE2","Judo","Théâtre"]],
//                   ["Nadia Comtois","2003",["CP","CE1","CE2","Judo","Théâtre"]],
//                   ["Raphaël Thibault","2003",["CP","CE1","CE2"]],
//                   ["Anastasie Firmin","2001",["CP","CE1","CE2"]],
//                   ["Arianne Vincent","2001",["CE2","Judo","Théâtre"]],
//                   ["Marlène Porcher","2001",["CP","CE1","CE2","Théâtre"]],
//                   ["Gervais Plourde","2001",["CP","CE2","Judo","Théâtre"]],
//                   ["Madeline François","2002",["CP","CE1","CE2","Théâtre","maison"]],
//                   ["Solange Géroux","2003",["CP","CE2","Judo","Théâtre"]],
//                   ["Axel Deniau","2002",["CP","CE2","Judo","Théâtre"]]]



function addPupilsNamesFromList(pupilsDetailsStr) {

    var addedPupilsNamesArray = []
    var pupilDetailsLineArray = pupilsDetailsStr.split("\n")
    var lineIndex = 0
    for (const pupilDetailsLine of pupilDetailsLineArray) {
        //console.log(pupilDetails)

        lineIndex++
        var pupilDetails = pupilDetailsLine.split(";")

        var groupsNames = []
        var reformatedPupilDetailsArray = []


        var groupsArray = pupilDetails[2].split("-")

        //check if all the groups exist

        for (const group of groupsArray) {
            if (groupsNamesArray.indexOf(group) === -1) {
                console.log("Failed to add unexisting group. Line " +  lineIndex + " " + group)
            }

        }


        reformatedPupilDetailsArray.push(pupilDetails[0].toString())
        reformatedPupilDetailsArray.push(pupilDetails[1].toString())
        reformatedPupilDetailsArray.push(pupilDetails[2].toString())

        addedPupilsNamesArray.push(reformatedPupilDetailsArray)


        console.log(JSON.stringify(reformatedPupilDetailsArray))

    }


    if (pupilsNamesArray.length === 0) {
        console.log("dummy")
        pupilsNamesArray = addedPupilsNamesArray
    } else {
        pupilsNamesArray = pupilsNamesArray.concat(addedPupilsNamesArray)
    }


    console.log("-----------------------------------------------------------")

    console.log(JSON.stringify(pupilsNamesArray))

        console.log("-----------------------------------------------------------")

        console.log(JSON.stringify(pupilsNamesArray[0]))


}


function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1




}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

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

