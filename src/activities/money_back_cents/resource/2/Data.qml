/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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
import GCompris 1.0
import "../../../money/moneyConstants.js" as MoneyConstants

Data {
    objective: qsTr("Learn how to calculate change including cents when amount paid is up to 100 units.")
    difficulty: 2
    property var moneyItems: MoneyConstants.moneyItems
    data: [
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 9,
        "paid": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 2,
        "minPrice": 1,
        "maxPrice": 9,
        "paid": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 1,
        "maxPrice": 9,
        "paid": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 19,
        "paid": 20,
        "pocket": [
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 2,
        "minPrice": 1,
        "maxPrice": 19,
        "paid": 20,
        "pocket": [
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 1,
        "maxPrice": 19,
        "paid": 20,
        "pocket": [
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 49,
        "paid": 50,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 2,
        "minPrice": 2,
        "maxPrice": 49,
        "paid": 50,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 4,
        "maxPrice": 49,
        "paid": 50,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 99,
        "paid": 100,
        "pocket": [
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 2,
        "minPrice": 1,
        "maxPrice": 99,
        "paid": 100,
        "pocket": [
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    },
    {
        "numberOfItem": 4,
        "minPrice": 1,
        "maxPrice": 99,
        "paid": 100,
        "pocket": [
            moneyItems.MONEY_PAPER_100E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2C,
            moneyItems.MONEY_COIN_5C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_50C,
            moneyItems.MONEY_COIN_20C,
            moneyItems.MONEY_COIN_10C,
            moneyItems.MONEY_COIN_1C,
            moneyItems.MONEY_COIN_1C
        ]
    }
    ]
}
