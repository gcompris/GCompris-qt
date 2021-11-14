/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0
import "../../../money/moneyConstants.js" as MoneyConstants


Data {
    objective: qsTr("Amount up to 10 units.")
    difficulty: 1
    property var moneyItems: MoneyConstants.moneyItems
    data: [
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 4,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C,
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 5,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 2,
        "minPrice": 1,
        "maxPrice": 6,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C,
        ]
    },
    {
        "numberOfItem": 3,
        "minPrice": 1,
        "maxPrice": 7,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 1,
        "maxPrice": 8,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C,
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 1,
        "maxPrice": 9,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C,
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 1,
        "maxPrice": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C,
        ]
    }
    ]
}
