/* GCompris - number_sequence.js
*
* SPDX-FileCopyrightText: 2014 Emmanuel Charruau
*
* Authors:
*   Olivier Ponchaut <opvg@mailoo.org> (GTK+ version)
*   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var items
var mode
var dataset
var numberOfLevel
var pointPositions = []
var pointPositions2 = []
var linePropertiesArray = []
var url

function start(_items, _mode,_dataset,_url) {
    items = _items
    mode = _mode
    dataset = _dataset.get()
    url = _url
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.pointIndexToClick = 0
    reset()
    loadCoordinates()
    loadBackgroundImage()
    if(mode == "drawletters" || mode == "drawnumbers") {
        //function to play letter sound at start
        playLetterSound(dataset[items.currentLevel].sound)
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

//function to play the sound of character at start & end
function playLetterSound(sound) {
    // first we clear the queue in case other voices are there, then we append the new number
    // if we play directly, we don't have the bonus sound (or it is truncated)
    items.audioVoices.clearQueue()
    items.audioVoices.append(sound)
}

function reset() {
    for(var i = 0; i < items.pointImageRepeater.count; i++)
        items.pointImageRepeater.itemAt(i).highlight = false;

    for(var i = 0; i < items.segmentsRepeater.count; i++)
        items.segmentsRepeater.itemAt(i).opacity = 0
}

function drawSegment(pointIndex) {
    if (pointIndex == items.pointIndexToClick) {
        var currentPoint = items.pointImageRepeater.itemAt(pointIndex)
        // if we need to draw only a point instead of a line
        if(mode == "drawletters" || mode == "drawnumbers") {
            currentPoint.highlight = false
            if(pointIndex == 0 || (pointPositions2 && pointPositions2[pointIndex] != pointPositions2[pointIndex-1])) {
                currentPoint.markedAsPoint = true
            }
        }

        if (mode == "clickanddraw" || mode == "drawletters" || mode == "drawnumbers") {
            if (pointIndex < items.pointImageRepeater.count-1) {
                items.pointImageRepeater.itemAt(pointIndex+1).highlight = true
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/audioclick.wav')
            }
        }

        // Draw the line from pointIndex - 1 to pointIndex
        if(pointIndex == 0 || (pointPositions2 && pointPositions2[pointIndex] != pointPositions2[pointIndex-1])) {
            //do nothing
        }
        else {
            items.segmentsRepeater.itemAt(pointIndex-1).opacity = 1
        }

        if (pointIndex == items.pointImageRepeater.count-1) {
            for (var i = 1; i < dataset[items.currentLevel].coordinates.length; i++) {
                items.segmentsRepeater.itemAt(i-1).opacity = 0
            }
            items.imageBack2.source = url + dataset[items.currentLevel].imageName2
            won()
        }
        items.pointIndexToClick++
    }
}

function loadCoordinates() {
    // prepare points data
    pointPositions = dataset[items.currentLevel].coordinates
    pointPositions2 = dataset[items.currentLevel].coordinates2
    items.pointImageRepeater.model = pointPositions
    if (mode == "clickanddraw" || mode == "drawletters" || mode == "drawnumbers")
        items.pointImageRepeater.itemAt(0).highlight = true
    // prepare segments data
    linePropertiesArray = []
    for (var i = 0; i < (pointPositions.length)-1; i++) {
        var lineProperties = []                    // properties are x1,y1,x2,y,angle rotation
        lineProperties[0] = pointPositions[i][0]   // x
        lineProperties[1] = pointPositions[i][1]   // y
        lineProperties[2] = pointPositions[i+1][0] // x2
        lineProperties[3] = pointPositions[i+1][1] // y2
        linePropertiesArray[i] = lineProperties
    }
    items.segmentsRepeater.model = linePropertiesArray
}

function loadBackgroundImage() {
    items.imageBack.source = url + dataset[items.currentLevel].imageName1
    items.imageBack2.source = url + dataset[items.currentLevel].imageName1
}

function won() {
    items.bonus.good("flower")
}
