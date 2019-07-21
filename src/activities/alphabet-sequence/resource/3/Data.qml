
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
    objective: qsTr("Select words(with common initials) in alphabetical order")
    difficulty: 3
    data: [
        {
            data: [
                qsTr("band"),
                qsTr("beautiful"),
                qsTr("balance"),
                qsTr("ball"),
                qsTr("basket"),
                qsTr("base"),
            ].sort(),
            showNext: true
        },
        {
            data: [
                qsTr("connection"),
                qsTr("cook"),
                qsTr("condition"),
                qsTr("control"),
                qsTr("conscious"),
                qsTr("complex"),
            ].sort(),
            showNext: true
        },
        {
            data: [
                qsTr("discovery"),
                qsTr("digestion"),
                qsTr("direction"),
                qsTr("discussion"),
                qsTr("disease"),
                qsTr("dirty"),
            ].sort(),
            showNext: true
        },
        {
            data: [
                    qsTr("engine"),
                    qsTr("elastic"),
                    qsTr("egg"),
                    qsTr("effect"),
                    qsTr("enough"),
                    qsTr("end"),
                    qsTr("electric"),
                ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("family"),
                qsTr("face"),
                qsTr("fall"),
                qsTr("fat"),
                qsTr("fact"),
                qsTr("false"),
                qsTr("far")
            ].sort(),
            showNext: false
        },
        {
            data: [
                qsTr("fertile"),
                qsTr("feeling"),
                qsTr("fiction"),
                qsTr("field"),
                qsTr("fight"),
                qsTr("female"),
            ].sort(),
            showNext: false
        }
    ]
}
