/* GCompris - categorization.js
    *
    * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
    *
    * Authors:
    *   Divyam Madaan <divyam3897@gmail.com>
    *
    *   SPDX-License-Identifier: GPL-3.0-or-later
    */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var categoryModelIndex = 0;
var currentSubLevel = 0;
var items
var lessons
var categories
var images
var numberOfLevel
var index
var imagesData = []
var categoriesData = []
var expertCategories = []
var answerTable = {}
var totalImages
var fileName = ":/gcompris/data/words-webp/animals/camel.webp"

function init(items_) {
    items = items_
    items.menuModel.clear()
    currentSubLevel = 0
}

function start() {
    categoriesData = []
    items.categoryReview.stop()

    var isEmbeddedMode = items.file.exists(fileName) ? true : false

    items.categoriesFallback = !isEmbeddedMode

    var categoriesFilename;
    var categoryDataset = items.categoryReview.categoryDataset
    var categoryLists = items.categories
    for(var i = 0; i < categoryLists.length; i++) {
        categoriesFilename = categoryLists[i][0]
        categoryDataset.source = categoriesFilename
        if(isEmbeddedMode || categoryDataset.item.isEmbedded) {
            categoriesData.push(categoryDataset.item)
        }
    }
    lessons = getAllLessons(categoriesData)
    categories = getCategoryModel(categoriesData)
    addPropertiesToCategories(categories)
    items.menuModel.append(categories)
    savedPropertiesToCategories(items.dialogActivityConfig.activityData)
    sortByFavorites()
    items.menuScreen.start()
}

// Inserts specific properties to the categories
function addPropertiesToCategories(categories) {
    for (var i = 0; i < categories.length; i++) {
        categories[i]['name'] = categories[i].name
        categories[i]['image'] = categories[i].image
        categories[i]['favorite'] = false
        categories[i]['categoryIndex'] = i
    }
}

// Return all the properties we have to save
function categoriesToSavedProperties() {
    if(!items)
        return;
    var props = {}
    for(var i = 0; i < items.menuModel.count; i++) {
        var category = items.menuModel.get(i)
        props[category.name] = {
            'favorite': category['favorite']
        }
    }
    return props
}

// Update the categories based on a previous saving
function savedPropertiesToCategories(dataToSave) {
    var props = dataToSave["data"]
    for(var i = 0; i < items.menuModel.count; i++) {
        var category = items.menuModel.get(i)
        var categoryname = category.name
        if(props && props[category.name]) {
            category['favorite'] = props[category.name].favorite
        }
        else {
            category['favorite'] = false
        }
    }
}

function sortByFavorites() {
    for(var i = 0; i < items.menuModel.count; i++) {
        if(items.menuModel.get(i)['favorite']) {
            items.menuModel.move(i, 0, 1);
        }
    }
}

function launchMenuScreen() {
    items.categoryReview.stop()
    items.menuScreen.start()
}

function startCategory() {
    items.categoryReview.start()
    items.menuScreen.stop()
    items.currentLevel = 0
    initLevel()
}

function storeCategoriesLevels(index_) {
    index = index_
    items.currentLevel = 0
    numberOfLevel = 0
    initLevel()
}

function initLevel() {
    items.categoryReview.score.currentSubLevel = 0
    items.instructionsVisible = true
    getCategoryLevels(index);
    numberOfLevel = items.details.length;
    items.categoryReview.leftZone.clear();
    items.categoryReview.rightZone.clear();
    items.categoryReview.start();
    items.menuScreen.stop()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.categoryReview.score.currentSubLevel = 0
    initLevel(index);
    getCategoryLevels();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel(index);
    getCategoryLevels();
}

// Checks if all the items are dragged and dropped in the correct or incorrect area.
function allPlaced() {
    items.categoryReview.score.currentSubLevel = 0;
    for(var i = 0 ; i < items.categoryReview.leftZone.count; ++i) {
        for(var answer in answerTable) {
            var droppedZoneItem = items.categoryReview.leftZone.get(i)
            if(answer === droppedZoneItem.name &&
                    ((droppedZoneItem.droppedZone === "right" && answerTable[answer])
                     || (droppedZoneItem.droppedZone === "left" && !answerTable[answer])))
                items.categoryReview.score.currentSubLevel ++
        }
    }
    for(var i = 0 ; i < items.categoryReview.rightZone.count; ++i) {
        for(var answer in answerTable) {
            var droppedZoneItem = items.categoryReview.rightZone.get(i)
            if(answer === droppedZoneItem.name &&
                    ((droppedZoneItem.droppedZone === "right" && answerTable[answer])
                     || (droppedZoneItem.droppedZone === "left" && !answerTable[answer])))
                items.categoryReview.score.currentSubLevel ++
        }
    }
    if(items.categoryReview.score.currentSubLevel === totalImages)
        items.bonus.good("flower")
    else
        items.bonus.bad("flower", items.bonus.checkAnswer)
}

// Save properties to lessons
function getCategoryLevels() {
    var randomGood = 0;
    var randomBad = 0;
    items.categoryReview.middleZone.clear()
    /* If easy or medium mode is selected, store the details of levels of category of that respective index in items.details. */
    if(items.mode !== "expert") {
        items.details = lessons[index].map(function(ele) {
            return { "instructions": ele.instructions, "image": ele.image,
                "numberOfGood": ele.maxNumberOfGood, "numberofBad": ele.maxNumberOfBad,
                "categoryImages": ele.levelImages ,"good": ele.good,
                "bad": ele.bad ,"prefix": ele.prefix }
        });
    }
    // If expert mode is selected, select a random level (selectedLevel) from a random category (selectedCategory)
    else if(items.mode === "expert") {
        var selectedCategory = Math.floor(Math.random() * expertCategories.length)
        var selectedLevel = []
        selectedLevel[0] = expertCategories[selectedCategory][Math.floor(Math.random() * expertCategories[selectedCategory].length)]
        items.details = selectedLevel.map(function(ele) {
            return { "instructions": ele.instructions,  "image": ele.image,
                "numberOfGood": ele.maxNumberOfGood, "numberofBad": ele.maxNumberOfBad,
                "categoryImages": ele.levelImages ,"good": ele.good,
                "bad": ele.bad, "prefix": ele.prefix }
        });
    }

    var imagesPrefix = items.details[items.currentLevel].prefix
    // Good set of images
    var goodImages = items.details[items.currentLevel].good
    var numberOfGood = Math.min(goodImages.length,items.details[items.currentLevel].numberOfGood);
    var goodZoneImages = goodImages.map(function(obj) {
        obj = imagesPrefix + obj
        return { "name": obj, "isRight": true }
    });
    goodZoneImages = goodZoneImages.splice(0, numberOfGood);

    // Bad set of images
    var badImages = items.details[items.currentLevel].bad
    var badZoneImages = badImages.map(function(obj) {
        obj = imagesPrefix + obj
        return { "name": obj, "isRight": false }
    });
    var numberOfBad = Math.min(badImages.length,items.details[items.currentLevel].numberofBad);
    badZoneImages = badZoneImages.splice(0, numberOfBad);

    // Concat both set of images(good and bad) in allImages and store in middleZone model
    var allImages = goodZoneImages.concat(badZoneImages);
    Core.shuffle(allImages);
    for(var i = 0; i < allImages.length; i++) {
        answerTable[allImages[i].name] = allImages[i].isRight
        items.categoryReview.middleZone.append({"isRight": allImages[i].isRight,"name": allImages[i].name})
    }
    totalImages = allImages.length
    items.categoryReview.score.numberOfSubLevels = totalImages
}

// get categories details from the complete dataset
function getCategoryModel(dataset) {
    var categories = []
    for (var c = 0; c < dataset.length; c++) {
        categories.push({
                            'name': dataset[c].levels[0].name,
                            'image': dataset[c].levels[0].image,
                            'index': c
                        })
    }
    return categories
}

// get all the content (levels) from the category in dataset
function getAllLessons(dataset) {
    var lessons = []
    for(var c = 0; c < dataset.length; c++) {
        lessons.push(dataset[c].levels[0].content)
        if(dataset[c].allowExpertMode) {
            expertCategories.push(dataset[c].levels[0].content)
        }
    }
    return lessons
}

function setValues() {
    items.categoryReview.leftAreaContainsDrag = false
    items.categoryReview.rightAreaContainsDrag = false
}

function isDragInLeftArea(leftAreaRightBorderPos, elementRightPos) {
    if(elementRightPos <= leftAreaRightBorderPos)
        return true;
    else
        return false;
}
function isDragInRightArea(rightAreaLeftBorderPos, elementLeftPos) {
    if((rightAreaLeftBorderPos <= elementLeftPos))
        return true;
    else
        return false;
}

function dropControl(sourcePosition, destinationPosition, image, index) {
    var destinationZone = destinationPosition === "left" ? items.categoryReview.leftZone : destinationPosition === "right" ? items.categoryReview.rightZone : items.categoryReview.middleZone
    var sourceZone = sourcePosition === "left" ? items.categoryReview.leftZone : sourcePosition === "right" ? items.categoryReview.rightZone : items.categoryReview.middleZone
    destinationZone.append({"name": image, "droppedZone": destinationPosition})
    sourceZone.remove(index)
}
