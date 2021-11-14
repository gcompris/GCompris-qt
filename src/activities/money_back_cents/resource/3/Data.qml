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
    objective: qsTr("Amount up to 1000 units.")
    difficulty: 3
    property var moneyItems: MoneyConstants.moneyItems
    data: [
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 49,
        "paid": 50,
        "pocket": [
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
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
        "numberOfItem": 2,
        "minPrice": 10,
        "maxPrice": 99,
        "paid": 100,
        "pocket": [
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
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
        "numberOfItem": 3,
        "minPrice": 10,
        "maxPrice": 199,
        "paid": 200,
        "pocket": [
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
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
        "numberOfItem": 1,
        "minPrice": 10,
        "maxPrice": 299,
        "paid": 300,
        "pocket": [
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
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
        "numberOfItem": 2,
        "minPrice": 10,
        "maxPrice": 399,
        "paid": 400,
        "pocket": [
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
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
        "numberOfItem": 3,
        "minPrice": 10,
        "maxPrice": 499,
        "paid": 500,
        "pocket": [
            moneyItems.MONEY_PAPER_500E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
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
        "numberOfItem": 2,
        "minPrice": 10,
        "maxPrice": 599,
        "paid": 600,
        "pocket": [
            moneyItems.MONEY_PAPER_500E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
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
        "numberOfItem": 3,
        "minPrice": 10,
        "maxPrice": 699,
        "paid": 700,
        "pocket": [
            moneyItems.MONEY_PAPER_500E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
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
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 10,
        "maxPrice": 999,
        "paid": 1000,
        "pocket": [
            moneyItems.MONEY_PAPER_500E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_200E,
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_1C
        ]
    }
    ]
}
