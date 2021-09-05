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
var groupsNamesArray = []

var debugString = "Aurélien2 Richelieu;2004;CP-CE1-CE2-Judo-Théâtre\nNadia Comtois;2003;CP-CE1-CE2-Judo-Théâtre-Maison\nRaphaël Thibault;2003;CP-CE1-CE2\nAnastasie Firmin;2001;CP-CE1-CE2\nArianne Vincent;2001;CE2-Judo-Théâtre\nMarlène Porcher;2001;CP-CE1-CE2-Théâtre\nGervais Plourde;2001;CP-CE2-Judo-Théâtre\nMadeline François;2002;CP-CE1-CE2-Théâtre\nSolange Géroux;2003;CP-CE2-Judo-Théâtre-volley\nAxel Deniau;2002;CP-CE2-Judo-Théâtre"

groupsNamesArray = ["CP","CE1","CE2","Judo","Théâtre"]

groupsNamesArray.push("Chant")

var pupilsNamesArray = [["Mailys Urbain","2004","CP-CE1-CE2-Judo-Théâtre"],
                       ["Lucienne Lucie","2003","CP-CE1-CE2-Judo-Théâtre"],
                       ["France Juste","2003","CP-CE1-CE2"],
                       ["Sasha Lilou","2001","CP-CE1-CE2"],
                       ["Karine Mathilde","2001","CE2-Judo-Théâtre"],
                       ["Diodore Jean-Charles","2001","CP-CE1-CE2-Théâtre"],
                       ["Jordan Yannic","2001","CP-CE2-Judo-Théâtre"],
                       ["Éloi Vespasien","2002","CP-CE1-CE2-Théâtre-maison"],
                       ["Hubert Clovis","2003","CP-CE2-Judo-Théâtre"],
                       ["Corneille Christiane","2002","CP-CE2-Judo-Théâtre"]]


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

