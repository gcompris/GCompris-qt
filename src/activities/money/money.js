/* GCompris - money.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import "qrc:/gcompris/src/core/core.js" as Core
.import GCompris 1.0 as GCompris
.import "moneyConstants.js" as MoneyConstants

var url = "qrc:/gcompris/src/activities/money/resource/"

// We create 3 prices categories to make the game more realistic.
// List of images to use in the game (cheap objects)

var numberOfLevel
var dataset
var items
var centsMode
var backMode
var priceTotal

function start(items_, datasetName) {
    items = items_
    dataset = items.levels
    switch(datasetName) {
        case "WITHOUT_CENTS":
            centsMode = false
            backMode = false
            break
        case "WITH_CENTS":
            centsMode = true
            backMode = false
            break
        case "BACK_WITHOUT_CENTS":
            centsMode = false
            backMode = true
            break
        case "BACK_WITH_CENTS":
            centsMode = true
            backMode = true
            break
    }
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function getCoinCount (pocket) {
    var count = 0
    for(var i = 0; i < pocket.length; i++) {
        if(pocket[i].val <= 2)
            count++
    }
    return count;
}

function initLevel() {
    items.answerModel.clear()
    items.pocketModel.clear()

    var data = dataset[items.currentLevel]
    var pocket = Core.shuffle(data.pocket)
    var coinCount = getCoinCount(pocket)
    items.moneyCount = data.pocket.length

    for(var i = 0; i < pocket.length; i++)
        items.pocketModel.append(pocket[i])

    var locale = GCompris.ApplicationSettings.locale
    if(locale == "system") {
        locale = Qt.locale().name == "C" ? "en_US" : Qt.locale().name
    }
    // fill up the store in a random way
    var storeModel = new Array()
    // the real minimum price should always be at least the number of items
    // in non cents mode, to always have positive prices
    // else it could happen to have a price of 1 and 3 items to sell...
    var realMinPrice = Math.max(data.minPrice, data.numberOfItem)
    priceTotal = Math.floor(realMinPrice + Math.random() *
                            (data.maxPrice - realMinPrice))
    var priceCounter = 0
    for(var i = 0; i < data.numberOfItem; i++) {
        var price
        if(i < data.numberOfItem - 1) {
            var delta = (centsMode ? 0 : 1)
            // Calc a random price for each item based on the previous prices
            price = Math.floor(delta +
                               Math.random() *
                               (2 * (priceTotal - priceCounter) / data.numberOfItem - delta))
        }
        else {
            // Put the remaining missing price on the last item
            price = priceTotal - priceCounter
            // If the price is 0, we recompute it to be between 1 and the remaining values
            // between the actual total price and the max price possible
            if(price == 0) {
                price = delta + Math.floor(Math.random() * (data.maxPrice - priceTotal - delta));
                priceTotal += price;
            }
        }
        var cents = 0
        if(centsMode) {
            if(items.currentLevel === 0)
                cents += 0.10 + Math.floor(Math.random() * 9) / 10
            else
                cents += 0.01 + Math.floor(Math.random() * 99) / 100

            // To be sure that the sums of the cents will never go higher than the
            // maxPrice, we remove them instead of adding them if the item price
            // is above 1
            if(price > 1) {
                cents = cents - 1
            }
            priceTotal += cents
            price += cents
        }

        var priceText = Core.convertNumberToLocaleCurrencyString(Number(price), locale)
        if(!centsMode) {
            // Strip floating part
            priceText = priceText.replace((/[,.]00/), "")
        }

        storeModel.push({img: getRandomObject(price),
                         price: priceText})
        priceCounter += price
    }
    items.store.model = storeModel

    if(!backMode) {
        items.instructions.text =
                qsTr("Click on the coins or on the notes at the bottom of the screen to pay." +
                     " If you want to remove a coin or a note, click on it on the upper screen area.")
    } else {
        var availableCurrency = pocket.slice()
        availableCurrency.sort(function sort(a, b) { return b.val - a.val });
        var amountToBeCovered = data.paid
        var tuxMoney = []
        while(amountToBeCovered > 0) {
            var maxPossible = 0
            for(var i = 0; i < availableCurrency.length; i++) {
                if((availableCurrency[i].val <= amountToBeCovered)) {
                    maxPossible = availableCurrency[i]
                    break;
                }
            }
            tuxMoney.push(maxPossible)
            amountToBeCovered -= maxPossible.val;
        }
        items.tuxMoney.model = tuxMoney

        var tuxTotal = 0
        for(var i=0; i < tuxMoney.length; i++)
            tuxTotal += tuxMoney[i].val

        var priceText = Core.convertNumberToLocaleCurrencyString(Number(tuxTotal), locale)
        if(!centsMode) {
            // Strip floating part
            priceText = priceText.replace((/.00/), "")
        }

        /* The money sign is inserted based on the current locale */
        items.instructions.text = qsTr("Tux just bought some items in your shop.\n" +
                                       "He gives you %1, please give back his change.")
                      .arg(priceText)
    }

    //Keyboard reset
    items.itemIndex = -1
    items.selectedArea = items.pocket

}

// Given a price return a random object
function getRandomObject(price) {
    var objectList
    if(price < 5)
        objectList = MoneyConstants.cheapObjects
    else if(price < 10)
        objectList = MoneyConstants.normalObjects
    else
        objectList = MoneyConstants.expensiveObjects

    return objectList[Math.floor(Math.random() * objectList.length)]
}

function checkAnswer() {
    var paid = 0
    for (var i = 0; i < items.answerModel.count; ++i)
        paid += items.answerModel.get(i).val

    paid = paid.toFixed(2)

    if(!backMode) {
        if(paid === priceTotal.toFixed(2))
            items.bonus.good("flower")
    } else {
        if(paid === (dataset[items.currentLevel].paid - priceTotal).toFixed(2))
            items.bonus.good("flower")
    }
}

function pay(index) {
    items.audioEffects.play(url + "money1.wav")
    // Add it to the anwser
    items.answerModel.append(items.pocketModel.get(index))

    // Remove it from the pocket
    items.pocketModel.remove(index, 1)

    checkAnswer()
}

function unpay(index) {
    items.audioEffects.play(url + "money2.wav")
    // Add it to the pocket
    items.pocketModel.append(items.answerModel.get(index))

    // Remove it from the Answer
    items.answerModel.remove(index, 1)

    checkAnswer()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
