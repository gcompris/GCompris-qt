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
    objective: qsTr("Learn how to pay up to 10 units")
    property var moneyItems: MoneyConstants.moneyItems
    difficulty: 1
    data: [
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 4,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    },  
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 5,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 6,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 7,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 8,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 9,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E
        ]
    }
    ]
}
