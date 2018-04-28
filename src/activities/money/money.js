/* GCompris - money.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import "qrc:/gcompris/src/core/core.js" as Core
.import GCompris 1.0 as GCompris

var url = "qrc:/gcompris/src/activities/money/resource/"

// We create 3 prices categories to make the game more realistic.
// List of images to use in the game (cheap objects)
var cheapObjects = [
            "apple.svg",
            "orange.svg",
            "banane.svg",
            "pamplemousse.svg",
            "carot.svg",
            "cerise.svg",
            "cake.svg"
        ]

var normalObjects = [
            "umbrella.svg",
            "pencil.svg",
            "bottle.svg",
            "light.svg",
            "eggpot.svg"
        ]

var expensiveObjects = [
            "lamp.svg",
            "football.svg",
            "bicycle.svg"
        ]

var moneyItems = {
    MONEY_EURO_COIN_1C:   { img: "c1c.svg",  val: 0.01 },
    MONEY_EURO_COIN_2C:   { img: "c2c.svg",  val: 0.02 },
    MONEY_EURO_COIN_5C:   { img: "c5c.svg",  val: 0.05 },
    MONEY_EURO_COIN_10C:  { img: "c10c.svg", val: 0.1  },
    MONEY_EURO_COIN_20C:  { img: "c20c.svg", val: 0.20 },
    MONEY_EURO_COIN_50C:  { img: "c50c.svg", val: 0.5  },
    MONEY_EURO_COIN_1E:   { img: "c1e.svg",  val: 1.0  },
    MONEY_EURO_COIN_2E:   { img: "c2e.svg",  val: 2.0  },
    MONEY_EURO_PAPER_5E:  { img: "n5e.svg",  val: 5.0  },
    MONEY_EURO_PAPER_10E: { img: "n10e.svg", val: 10.0 },
    MONEY_EURO_PAPER_20E: { img: "n20e.svg", val: 20.0 },
    MONEY_EURO_PAPER_50E: { img: "n50e.svg", val: 50.0 },
}

var fullDataset = {
    WITHOUT_CENTS: [
        {
            numberOfItem: 1,
            minPrice: 3,
            maxPrice: 10,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 1,
            minPrice: 10,
            maxPrice: 20,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 2,
            minPrice: 20,
            maxPrice: 30,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 2,
            minPrice: 30,
            maxPrice: 40,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 3,
            minPrice: 40,
            maxPrice: 50,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 3,
            minPrice: 50,
            maxPrice: 60,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 60,
            maxPrice: 70,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 70,
            maxPrice: 80,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 50,
            maxPrice: 100,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E
            ]
        }
    ],

    WITH_CENTS: [
        {
            numberOfItem: 1,
            minPrice: 1,
            maxPrice: 3,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C,
          ]
        },
        {
            numberOfItem: 1,
            minPrice: 1,
            maxPrice: 3,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        },
        {
            numberOfItem: 2,
            minPrice: 1,
            maxPrice: 3,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C,
            ]
        },
        {
            numberOfItem: 3,
            minPrice: 1,
            maxPrice: 3,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 0,
            maxPrice: 4,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C,
            ]
        }
    ],

    BACK_WITHOUT_CENTS: [
        {
            numberOfItem: 1,
            minPrice: 3,
            maxPrice: 9,
            paid: 10,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
            ]
        },
        {
            numberOfItem: 1,
            minPrice: 1,
            maxPrice: 19,
            paid: 20,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 2,
            minPrice: 2,
            maxPrice: 29,
            paid: 30,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 2,
            minPrice: 2,
            maxPrice: 39,
            paid: 40,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 3,
            minPrice: 3,
            maxPrice: 49,
            paid: 50,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 3,
            minPrice: 3,
            maxPrice: 60,
            paid: 100,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 4,
            maxPrice: 70,
            paid: 100,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 4,
            maxPrice: 80,
            paid: 100,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 4,
            maxPrice: 99,
            paid: 100,
            pocket: [
                moneyItems.MONEY_EURO_PAPER_10E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_PAPER_50E,
                moneyItems.MONEY_EURO_PAPER_20E,
                moneyItems.MONEY_EURO_PAPER_5E,
                moneyItems.MONEY_EURO_PAPER_5E
            ]
        }
    ],

    BACK_WITH_CENTS: [
        {
            numberOfItem: 1,
            minPrice: 1,
            maxPrice: 3,
            paid: 5,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        },
        {
            numberOfItem: 1,
            minPrice: 1,
            maxPrice: 3,
            paid: 5,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        },
        {
            numberOfItem: 2,
            minPrice: 1,
            maxPrice: 3,
            paid: 5,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        },
        {
            numberOfItem: 3,
            minPrice: 1,
            maxPrice: 3,
            paid: 5,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        },
        {
            numberOfItem: 4,
            minPrice: 0,
            maxPrice: 4,
            paid: 5,
            pocket: [
                moneyItems.MONEY_EURO_COIN_2E,
                moneyItems.MONEY_EURO_COIN_1E,
                moneyItems.MONEY_EURO_COIN_5C,
                moneyItems.MONEY_EURO_COIN_2C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_50C,
                moneyItems.MONEY_EURO_COIN_20C,
                moneyItems.MONEY_EURO_COIN_10C,
                moneyItems.MONEY_EURO_COIN_1C,
                moneyItems.MONEY_EURO_COIN_1C
            ]
        }
    ]
}

var currentLevel
var numberOfLevel
var dataset
var items
var centsMode
var backMode
var priceTotal

function start(items_, datasetName) {
    items = items_

    switch(datasetName) {
    case "WITHOUT_CENTS":
        dataset = fullDataset.WITHOUT_CENTS
        centsMode = false
        backMode = false
        break
    case "WITH_CENTS":
        dataset = fullDataset.WITH_CENTS
        centsMode = true
        backMode = false
        break
    case "BACK_WITHOUT_CENTS":
        dataset = fullDataset.BACK_WITHOUT_CENTS
        centsMode = false
        backMode = true
        break
    case "BACK_WITH_CENTS":
        dataset = fullDataset.BACK_WITH_CENTS
        centsMode = true
        backMode = true
        break
    }

    currentLevel = 0
    numberOfLevel = dataset.length
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.answerModel.clear()
    items.pocketModel.clear()

    var data = dataset[currentLevel]
    var pocket = Core.shuffle(data.pocket)
    for (var i in pocket)
        items.pocketModel.append(pocket[i])

    // fill up the store in a random way
    var storeModel = new Array()
    priceTotal = Math.floor(data.minPrice + Math.random() *
                            (data.maxPrice - data.minPrice))
    var priceCounter = 0
    for(var i = 0; i < data.numberOfItem; i++) {
        var price
        if(i < data.numberOfItem - 1)
            // Calc a random price for each item based on the previous prices
            price = Math.floor((centsMode ? 0 : 1) +
                               Math.random() *
                               ((priceTotal - priceCounter) / data.numberOfItem))
        else
            // Put the remaining missing price on the last item
            price = priceTotal - priceCounter

        var cents = 0
        if(centsMode) {
            if(currentLevel === 0)
                cents += 0.10 + Math.floor(Math.random() * 9) / 10
            else
                cents += 0.01 + Math.floor(Math.random() * 9) / 100

            priceTotal += cents
            price += cents
        }

        var locale = GCompris.ApplicationSettings.locale
        if(locale == "system") {
            locale = Qt.locale().name == "C" ? "en_US" : Qt.locale().name
        }
        var priceText = Number(price).toLocaleCurrencyString(Qt.locale(locale))
        if(!centsMode) {
            // Strip floating part
            priceText = priceText.replace((/.00/), "")
        }

        storeModel.push({img: getRandomObject(price),
                         price: priceText})
        priceCounter += price
    }
    items.store.model = storeModel

    if(!backMode) {
        items.instructions.text =
                qsTr("Click on the coins or paper money at the bottom of the screen to pay." +
                     " If you want to remove a coin or note, click on it on the upper screen area.")
    } else {
        var tuxMoney
        switch(data.paid) {
        case 5:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_5E]
            break
        case 10:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_10E]
            break
        case 20:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_20E]
            break
        case 30:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_20E, moneyItems.MONEY_EURO_PAPER_10E]
            break
        case 40:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_20E, moneyItems.MONEY_EURO_PAPER_20E]
            break
        case 50:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_50E]
            break
        case 100:
            tuxMoney = [moneyItems.MONEY_EURO_PAPER_50E, moneyItems.MONEY_EURO_PAPER_50E]
            break
        }
        items.tuxMoney.model = tuxMoney

        var tuxTotal = 0
        for(var i=0; i < tuxMoney.length; i++)
            tuxTotal += tuxMoney[i].val

        var locale = GCompris.ApplicationSettings.locale
        if(locale == "system") {
            locale = Qt.locale().name == "C" ? "en_US" : Qt.locale().name
        }
        var priceText = Number(tuxTotal).toLocaleCurrencyString(Qt.locale(locale))
        if(!centsMode) {
            // Strip floating part
            priceText = priceText.replace((/.00/), "")
        }

        /* The money sign is inserted based on the current locale */
        items.instructions.text = qsTr("Tux just bought some items in your shop.\n" +
                                       "He gives you %1, please give back his change.")
                      .arg(priceText)

    }
}

// Given a price return a random object
function getRandomObject(price) {
    var list
    if(price < 5)
        list = cheapObjects
    else if(price < 10)
        list = normalObjects
    else
        list = expensiveObjects

    return list[Math.floor(Math.random() * list.length)]
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
        if(paid === (dataset[currentLevel].paid - priceTotal).toFixed(2))
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
    if(numberOfLevel <= ++currentLevel ) {
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
