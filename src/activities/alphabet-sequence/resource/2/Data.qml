
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

Dataset {
    objective: qsTr("Select words in alphabetical order")
    difficulty: 2
    data: [
        {
            data: [
                qsTr("fruit"),
                qsTr("road"),
                qsTr("meat"),
                qsTr("speech"),
                qsTr("gold"),
                qsTr("trip"),
                qsTr("dance")
            ].sort(),
            showNext: true
        },
        {
            data: [
                qsTr("witch"),
                qsTr("ghost"),
                qsTr("trip"),
                qsTr("house"),
                qsTr("live"),
                qsTr("like"),
                qsTr("road"),
            ].sort(),
            showNext: true
        },
        {
            data: [
                qsTr("old"),
                qsTr("crown"),
                qsTr("tear"),
                qsTr("bench"),
                qsTr("computer"),
                qsTr("key"),
            ].sort(),
            showNext: true
        },
        {
            data: [
                qsTr("brake"),
                qsTr("dream"),
                qsTr("prince"),
                qsTr("talk"),
                qsTr("fly"),
                qsTr("history"),
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("watch"),
                qsTr("shampoo"),
                qsTr("sun"),
                qsTr("apple"),
                qsTr("table"),
                qsTr("socks"),
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("needle"),
                qsTr("couch"),
                qsTr("peanuts"),
                qsTr("stock"),
                qsTr("shoes"),
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("needle"),
                qsTr("couch"),
                qsTr("peanuts"),
                qsTr("stock"),
                qsTr("shoes"),
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("hanger"),
                qsTr("toothbrush"),
                qsTr("plastic"),
                qsTr("machine"),
                qsTr("shampoo"),
                qsTr("towel"),
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("bread"),
                qsTr("waist"),
                qsTr("law"),
                qsTr("firm"),
                qsTr("fibre"),
                qsTr("move"),
                qsTr("bright"),
                qsTr("green"),
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("rush"),
                qsTr("trade"),
                qsTr("line"),
                qsTr("boy"),
                qsTr("girl"),
                qsTr("key"),
            ].sort(),
            showNext: false
        },
    ]
}