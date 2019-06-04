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
import QtQuick 2.6
import GCompris 1.0
import "../../../../core"
import "../../../money/moneyConstants.js" as Constants

Dataset {
    objective: qsTr("Learn how to calculate change when amount paid is upto 25 units")
    property var moneyItems: Constants.moneyItems
    data: [
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 3,
        "paid": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 5,
        "paid": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 8,
        "paid": 10,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 10,
        "paid": 15,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 12,
        "paid": 15,
        "pocket": [
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 15,
        "paid": 20,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 18,
        "paid": 20,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 20,
        "paid": 25,
        "pocket": [
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E
        ]
    },
    {
        "numberOfItem": 1,
        "minPrice": 1,
        "maxPrice": 22,
        "paid": 25,
        "pocket": [
            moneyItems.MONEY_PAPER_10E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_1E,
            moneyItems.MONEY_COIN_2E,
            moneyItems.MONEY_PAPER_50E,
            moneyItems.MONEY_PAPER_20E,
            moneyItems.MONEY_PAPER_5E,
            moneyItems.MONEY_PAPER_5E
        ]
    }
    ]
}
