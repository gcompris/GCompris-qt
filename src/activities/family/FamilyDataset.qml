/* GCompris - FamilyDataset.qml
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *
 *   Rajdeep Kaur <rajdeep.kaur@kde.org>
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {

    /*
     * pairs are used to determine the correct
     * pair for a given relation in the family_find_relative
     * activity
     * A correct pair is formed by selecting a node of type
     * "pair1" and "pair2" only
     */
    readonly property int pair1: -1
    readonly property int pair2: 1
    readonly property int noPair: 0

    // left and right are used for captions position
    readonly property int left: 0
    readonly property int right: 1

    // others and married are used for edgeState
    readonly property int others: 0
    readonly property int married: 1

/*
 * Notes:
 *
 * Items in a level are layout on a 8 * 5 grid.
 * There must be an empty area between each person,
 * so it can contain maximum 3 persons/generations vertically, and 4 persons horizontally.
 * Take care to keep and empty column on left/right sides if a label needs to be display on these extremities.
 *
 * edgeList contains the lines to draw (with grid coordinates for their start/end points).
 * nodePositions contains the grid coordinates for each person node.
 * captions contains the position for "Me" and "?" labels (left or right).
 *  "Me" will be displayed next to "active" node, and "?" next to "activeTo".
 * nodeValue contains the image names for each node.
 * nodeWeights contains the values used to define pairs (in mode "find_relative").
 * currentState contains the state to set on each node (in mode "family").
 *  There needs to be exactly one "active" and one "activeTo".
 * edgeState contains the values to tell if an edge links two married persons.
 *  There needs to be the same number of items as in edgeList.
 * answer contains the answer to give (in mode "family").
 * options contains the list of possible answers (in mode "family").

 * Level format:
 * {  edgeList: [
 *                [startX, startY, endX, endY],
 *                [startX, startY, endX, endY]
 *    ],
 *    nodePositions: [
 *            [x, y],
 *            [x, y],
 *            [x, y]
 *    ],
 *    captions: [left, right],
 *    nodeValue: [foo1.svg, foo2.svg, foo3.svg],
 *    nodeWeights: [pair1, noPair, pair2],
 *    currentstate: ["activeTo", "deactivate", "active"],
 *    edgeState:[married,others],
 *    answer: [qsTr"goodAnswer"],
 *    options: [qsTr"goodAnswer", qsTr"badAnswer1", qsTr"badAnswer2"]
 * },
 */

    property var levelElements: [
        // level 1
        {
            edgeList: [
                [3, 2, 5, 2],
                [4, 2, 4, 4]
            ],
            nodePositions: [
                [3, 2],
                [5, 2],
                [4, 4]
            ],
            captions: [left, left],
            nodeValue: ["man1.svg", "woman2.svg", "boy1.svg"],
            nodeWeights: [pair1, noPair, pair2],
            currentState: ["activeTo", "deactivate", "active"],
            edgeState:[married,others],
            answer: [qsTr("Father")],
            options: [qsTr("Father"), qsTr("Grandfather"), qsTr("Uncle")]
        },
        // level 2
        {
            edgeList: [
                [3, 2, 5, 2],
                [4, 2, 4, 4]
            ],
            nodePositions: [
                [3, 2],
                [5, 2],
                [4, 4]
            ],
            captions: [left, right],
            nodeValue: ["man1.svg", "woman2.svg", "boy1.svg"],
            nodeWeights: [noPair, pair1, pair2],
            currentState: ["deactivate", "activeTo", "active"],
            edgeState:[married,others],
            answer: [qsTr("Mother")],
            options: [qsTr("Mother"), qsTr("Grandmother"), qsTr("Aunt")]
        },
        // level 3
        {
            edgeList: [
                [3, 2, 5, 2],
                [4, 2, 4, 3],
                [3, 3, 5, 3],
                [3, 3, 3, 4],
                [5, 3, 5, 4]
            ],
            nodePositions: [
                [3, 2],
                [5, 2],
                [3, 4],
                [5, 4]
            ],
            captions: [left, right],
            nodeValue: ["man1.svg", "woman2.svg", "boy1.svg", "boy2.svg"],
            nodeWeights: [noPair, noPair, pair1, pair2],
            currentState: ["deactivate", "deactivate", "active", "activeTo"],
            edgeState:[married,others,others,others,others],
            answer: [qsTr("Brother")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 4
        {
            edgeList: [
                [4, 2, 6, 2],
                [5, 2, 5, 3],
                [3, 3, 7, 3],
                [3, 3, 3, 4],
                [5, 3, 5, 4],
                [7, 3, 7, 4]
            ],
            nodePositions: [
                [4, 2],
                [6, 2],
                [3, 4],
                [5, 4],
                [7, 4]
            ],
            captions: [left, right],
            nodeValue: ["man1.svg", "woman2.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [noPair, noPair, pair1, pair2, pair1],
            currentState: ["deactivate", "deactivate", "active", "activeTo", "deactivate"],
            edgeState:[married, others, others, others, others, others],
            answer: [qsTr("Sister")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 5
        {
            edgeList: [
                [3, 1, 5, 1],
                [4, 1, 4, 3],
                [4, 3, 6, 3],
                [5, 3, 5, 4],
                [3, 4, 7, 4],
                [3, 4, 3, 5],
                [5, 4, 5, 5],
                [7, 4, 7, 5]
            ],
            nodePositions: [
                [3, 1],
                [5, 1],
                [4, 3],
                [6, 3],
                [3, 5],
                [5, 5],
                [7, 5]
            ],
            captions: [left, left],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man2.svg", "woman1.svg", "girl1.svg", "boy1.svg", "boy2.svg"],
            nodeWeights: [pair1, noPair, noPair, noPair, pair2, pair2, pair2],
            currentState: ["activeTo", "deactivate", "deactivate", "deactivate", "active", "deactivate", "deactivate"],
            edgeState:[married,others,married,others,others,others,others,others ],
            answer: [qsTr("Grandfather")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 6
        {
            edgeList: [
                [3, 1, 5, 1],
                [4, 1, 4, 3],
                [4, 3, 6, 3],
                [5, 3, 5, 4],
                [3, 4, 7, 4],
                [3, 4, 3, 5],
                [5, 4, 5, 5],
                [7, 4, 7, 5]
            ],
            nodePositions: [
                [3, 1],
                [5, 1],
                [4, 3],
                [6, 3],
                [3, 5],
                [5, 5],
                [7, 5]
            ],
            captions: [right, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man2.svg", "woman1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [noPair, pair1, noPair, noPair, pair2, pair2, pair2],
            currentState: ["deactivate", "activeTo", "deactivate", "deactivate", "deactivate", "deactivate", "active"],
            edgeState:[married,others,married,others,others,others,others,others ],
            answer: [qsTr("Grandmother")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")],
        },
        // level 7
        {
            edgeList: [
                [3, 1, 5, 1],
                [4, 1, 4, 3],
                [4, 3, 6, 3],
                [5, 3, 5, 4],
                [3, 4, 7, 4],
                [3, 4, 3, 5],
                [5, 4, 5, 5],
                [7, 4, 7, 5]
            ],
            nodePositions: [
                [3, 1],
                [5, 1],
                [4, 3],
                [6, 3],
                [3, 5],
                [5, 5],
                [7, 5]
            ],
            captions: [left, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man2.svg", "woman1.svg", "boy1.svg", "boy2.svg","girl1.svg" ],
            nodeWeights: [pair1, pair1, noPair, noPair, noPair, noPair, pair2],
            currentState: ["active", "deactivate", "deactivate", "deactivate", "deactivate", "deactivate", "activeTo"],
            edgeState:[married,others,married,others,others,others,others,others ],
            answer: [qsTr("Granddaughter")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 8
        {
            edgeList: [
                [3, 1, 5, 1],
                [4, 1, 4, 3],
                [4, 3, 6, 3],
                [5, 3, 5, 4],
                [3, 4, 7, 4],
                [3, 4, 3, 5],
                [5, 4, 5, 5],
                [7, 4, 7, 5]
            ],
            nodePositions: [
                [3, 1],
                [5, 1],
                [4, 3],
                [6, 3],
                [3, 5],
                [5, 5],
                [7, 5]
            ],
            captions: [right, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man2.svg", "woman1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [pair1, pair1, noPair, noPair, pair2, noPair, pair2],
            currentState: ["deactivate", "active", "deactivate", "deactivate", "deactivate", "deactivate", "activeTo"],
            edgeState:[married,others,married,others,others,others,others,others ],
            answer: [qsTr("Grandson")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 9
        {
            edgeList: [
                [4, 1, 4, 2],
                [3, 2, 5, 2],
                [3, 2, 3, 3],
                [5, 2, 5, 3],
                [3, 3, 3, 5],
                [5, 3, 5, 5]
            ],
            nodePositions: [
                [4, 1],
                [3, 3],
                [5, 3],
                [3, 5],
                [5, 5]
            ],
            captions: [right, left],
            nodeValue: ["oldMan1.svg", "man3.svg", "man2.svg", "boy1.svg","boy2.svg"],
            nodeWeights: [noPair, noPair, noPair, pair2, pair1],
            currentState: ["deactivate", "deactivate", "deactivate", "activeTo","active"],
            edgeState:[others,others,others,others,others,others],
            answer: [qsTr("Cousin")],
            options: [qsTr("Brother"), qsTr("Sister"), qsTr("Cousin")]
        },
        // level 10
        {
            edgeList: [
                [4, 1, 4, 2],
                [3, 2, 5, 2],
                [3, 2, 3, 3],
                [5, 2, 5, 3],
                [3, 3, 3, 5]
            ],
            nodePositions: [
                [4, 1],
                [3, 3],
                [5, 3],
                [3, 5]
            ],
            captions: [left, right],
            nodeValue: ["oldMan1.svg", "man3.svg", "man2.svg", "boy1.svg"],
            nodeWeights: [noPair, noPair, pair1, pair2],
            currentState: ["deactivate", "deactivate", "activeTo", "active"],
            edgeState:[others,others,others,others,others],
            answer: [qsTr("Uncle")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 11
        {
            edgeList: [
                [4, 1, 4, 2],
                [3, 2, 5, 2],
                [3, 2, 3, 3],
                [5, 2, 5, 3],
                [3, 3, 3, 5]
            ],
            nodePositions: [
                [4, 1],
                [3, 3],
                [5, 3],
                [3, 5]
            ],
            captions: [right, left],
            nodeValue: ["oldMan1.svg", "man3.svg", "man2.svg", "boy1.svg"],
            nodeWeights: [noPair, noPair, pair2, pair1],
            currentState: ["deactivate", "deactivate", "active", "activeTo"],
            edgeState:[others,others,others,others,others],
            answer: [qsTr("Nephew")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 12
        {
            edgeList: [
                [3, 1, 5, 1],
                [4, 1, 4, 2],
                [3, 2, 5, 2],
                [3, 2, 3, 3],
                [5, 2, 5, 3],
                [3, 3, 3, 5]
            ],
            nodePositions: [
                [3, 1],
                [5, 1],
                [3, 3],
                [5, 3],
                [3, 5]
            ],
            captions: [left, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man3.svg", "woman1.svg", "babyBoy.svg"],
            nodeWeights: [noPair, noPair, noPair, pair1, pair2],
            currentState: ["deactivate", "deactivate", "deactivate", "activeTo", "active"],
            edgeState:[married,others,others,others,others,others],
            answer: [qsTr("Aunt")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 13
        {
            edgeList: [
                [3, 1, 5, 1],
                [4, 1, 4, 2],
                [3, 2, 5, 2],
                [3, 2, 3, 3],
                [5, 2, 5, 3],
                [3, 3, 3, 5]
            ],
            nodePositions: [
                [3, 1],
                [5, 1],
                [3, 3],
                [5, 3],
                [3, 5]
            ],
            captions: [right, left],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man3.svg", "woman1.svg", "babyGirl.svg"],
            nodeWeights: [noPair, noPair, noPair, pair2, pair1],
            currentState: ["deactivate", "deactivate", "deactivate", "active", "activeTo"],
            edgeState:[married,others,others,others,others,others],
            answer: [qsTr("Niece")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 14
        {
            edgeList: [
                [5, 1, 7, 1],
                [6, 1, 6, 2],
                [5, 2, 7, 2],
                [5, 2, 5, 3],
                [7, 2, 7, 3],
                [3, 3, 5, 3]
            ],
            nodePositions: [
                [5, 1],
                [7, 1],
                [5, 3],
                [7, 3],
                [3, 3]
            ],
            captions: [left, left],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man3.svg", "man1.svg", "woman2.svg"],
            nodeWeights: [pair1, noPair, noPair, noPair, pair2],
            currentState: ["activeTo", "deactivate", "deactivate", "deactivate", "active"],
            edgeState:[married,others,others,others,others,married],
            answer: [qsTr("Father-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 15
        {
            edgeList: [
                [5, 1, 7, 1],
                [6, 1, 6, 2],
                [5, 2, 7, 2],
                [5, 2, 5, 3],
                [7, 2, 7, 3],
                [3, 3, 5, 3]
            ],
            nodePositions: [
                [5, 1],
                [7, 1],
                [5, 3],
                [7, 3],
                [3, 3]
            ],
            captions: [left, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man3.svg", "man1.svg", "woman2.svg"],
            nodeWeights: [noPair, pair1, noPair, noPair, pair2],
            currentState: ["deactivate", "activeTo", "deactivate", "deactivate", "active"],
            edgeState:[married,others,others,others,others,married],
            answer: [qsTr("Mother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 16
        {
            edgeList: [
                [5, 1, 7, 1],
                [6, 1, 6, 2],
                [5, 2, 7, 2],
                [5, 2, 5, 3],
                [7, 2, 7, 3],
                [3, 3, 5, 3]
            ],
            nodePositions: [
                [5, 1],
                [7, 1],
                [5, 3],
                [7, 3],
                [3, 3]
            ],
            captions: [left, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man3.svg", "man1.svg", "woman2.svg"],
            nodeWeights: [noPair, noPair, noPair, pair1, pair2],
            currentState: ["deactivate", "deactivate", "deactivate", "activeTo", "active"],
            edgeState:[married,others,others,others,others,married],
            answer: [qsTr("Brother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 17
        {
            edgeList: [
                [4, 1, 6, 1],
                [5, 1, 5, 2],
                [4, 2, 6, 2],
                [4, 2, 4, 3],
                [6, 2, 6, 3],
                [2, 3, 4, 3],
                [6, 3, 8, 3]
            ],
            nodePositions: [
                [4, 1],
                [6, 1],
                [4, 3],
                [2, 3],
                [6, 3],
                [8, 3]
            ],
            captions: [left, right],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "man3.svg", "woman2.svg", "woman1.svg", "man1.svg"],
            nodeWeights: [noPair, noPair, noPair, pair1, pair2, noPair],
            currentState: ["dective", "deactivate", "deactivate", "active", "activeTo", "deactivate"],
            edgeState:[married,others,others,others,others,married,married],
            answer: [qsTr("Sister-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 18
        {
            edgeList: [
                [5, 1, 7, 1],
                [6, 1, 6, 2],
                [5, 2, 7, 2],
                [5, 2, 5, 3],
                [7, 2, 7, 3],
                [3, 3, 5, 3]
            ],
            nodePositions: [
                [5, 1],
                [7, 1],
                [5, 3],
                [3, 3],
                [7, 3]
            ],
            captions: [left, left],
            nodeValue: ["oldMan1.svg", "oldWoman1.svg", "woman2.svg", "man3.svg", "man1.svg"],
            nodeWeights: [pair1, pair1, noPair, pair2, noPair],
            currentState: ["active", "deactivate", "deactivate", "activeTo", "deactivate"],
            edgeState:[married,others,others,others,others,married],
            answer: [qsTr("Son-in-law")],
            options: [qsTr("Son-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        }
    ]
}
