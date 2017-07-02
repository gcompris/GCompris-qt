/* GCompris - Dataset.qml
 *
 * Copyright (C) RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *   RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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

QtObject {
    property real nodeWidth: background.nodeWidthRatio
    property real nodeHeight: background.nodeHeightRatio

    /*
     * Vertically, the screen is divided into three parts:
     * gen1: stands for Generation 1
     * gen2: stands for Generation 2
     * gen3: stands for Generation 3
     */
    readonly property real gen1: 0.10
    readonly property real gen2: 0.40
    readonly property real gen3: 0.70

    /*
     * Horizontally, the screen is divided into left, center
     * and right
     */
    readonly property real left: 0.2
    readonly property real center: 0.4
    readonly property real right: 0.6

    /*
     * ext: exterior
     * int: interior
     */
    readonly property real leftExt: 0.1
    readonly property real leftInt: 0.3
    readonly property real rightInt: 0.5
    readonly property real rightExt: 0.7

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

    function rightXEdge(xPosition) {
        /*
         * Returns the x coordinate of the
         * right edge of a node
         */
        return xPosition + nodeWidth
    }

    function nodeMidPointY(yPosition) {
        /*
         * Returns the y coordinate of the
         * midpoint of a node
         */
        return yPosition + nodeHeight / 2
    }

    function nodeMidPointX(xLeftPosition, xRightPosition) {
        /*
         * Returns the x coordinate of the
         * midpoint of two nodes
         */
        return ((xLeftPosition + nodeWidth) + xRightPosition) / 2
    }

    property var levelElements: [
        // level 1
        {
            edgeList: [
                [left + nodeWidth, gen1 + nodeHeight / 2, right, gen1 + nodeHeight / 2],
                [((left + nodeWidth) + right) / 2, gen1 + nodeHeight / 2, ((left + nodeWidth) + right) / 2, gen2]
            ],
            nodePositions: [
                [left, gen1],
                [right, gen1],
                [center, gen2]
            ],
            captions: [
                [center - (nodeWidth *  3 / 4), gen2 + nodeHeight / 2],
                [left - nodeWidth / 2, gen1]
            ],
            nodeValue: ["man3.svg", "lady2.svg", "boy1.svg"],
            nodeWeights: [pair1, noPair, pair2],
            currentState: ["activeTo", "deactive", "active"],
            edgeState:["married","others"],
            answer: [qsTr("Father")],
            options: [qsTr("Father"), qsTr("Grandfather"), qsTr("Uncle")]
        },
        // level 2
        {
            edgeList: [
                [left + nodeWidth, gen1 + nodeHeight / 2, right, gen1 + nodeHeight / 2],
                [((left + nodeWidth) + right) / 2, gen1 + nodeHeight / 2, ((left + nodeWidth) + right) / 2, gen2]
            ],
            nodePositions: [
                [left, gen1],
                [right, gen1],
                [center, gen2]
            ],
            captions: [
                [center - (nodeWidth *  3 / 4), gen2 + nodeHeight / 2],
                [right + nodeWidth, gen1]
            ],
            nodeValue: ["man3.svg", "lady2.svg", "boy1.svg"],
            nodeWeights: [noPair, pair1, pair2],
            currentState: ["deactive", "activeTo", "active"],
            edgeState:["married","others"],
            answer: [qsTr("Mother")],
            options: [qsTr("Mother"), qsTr("Grandmother"), qsTr("Aunt")]
        },
        // level 3
        {
            edgeList: [
                [rightXEdge(left), nodeMidPointY(gen1), right, nodeMidPointY(gen1)],
                [nodeMidPointX(left, right), nodeMidPointY(gen1), nodeMidPointX(left, right), gen2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen2 - nodeHeight / 4, right + nodeWidth / 2, gen2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen2 - nodeHeight / 4, left + nodeWidth / 2, gen2],
                [right + nodeWidth / 2, gen2 - nodeHeight / 4, right + nodeWidth / 2, gen2]
            ],
            nodePositions: [
                [left, gen1],
                [right, gen1],
                [left, gen2],
                [right, gen2]
            ],
            captions:[
                [left - (nodeWidth *  3 / 4), gen2 + nodeHeight / 2],
                [right + nodeWidth, gen2]
            ],
            nodeValue: ["man3.svg", "lady2.svg", "boy1.svg", "boy2.svg"],
            nodeWeights: [noPair, noPair, pair1, pair2],
            currentState: ["deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","others","others"],
            answer: [qsTr("Brother")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 4
        {
            edgeList: [
                [rightXEdge(left), nodeMidPointY(gen1), right, nodeMidPointY(gen1)],
                [nodeMidPointX(left, right), nodeMidPointY(gen1), nodeMidPointX(left, right), gen2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen2 - nodeHeight / 4, right + nodeWidth / 2, gen2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen2 - nodeHeight / 4, left + nodeWidth / 2, gen2],
                [center + nodeWidth / 2, gen2 - nodeHeight / 4, center + nodeWidth / 2, gen2],
                [right + nodeWidth / 2, gen2 - nodeHeight / 4, right + nodeWidth / 2, gen2]
            ],
            nodePositions: [
                [left, gen1],
                [right, gen1],
                [left, gen2],
                [center, gen2],
                [right, gen2]
            ],
            captions: [
                [left - (nodeWidth *  3 / 4), gen2 + nodeHeight / 2],
                [center + nodeWidth / 2, (gen2 + nodeHeight)]
            ],
            nodeValue: ["man3.svg", "lady2.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [noPair, noPair, pair1, pair2, pair1],
            currentState: ["deactive", "deactive", "active", "activeTo", "deactive"],
            edgeState:["married", "others", "others", "others", "others", "others"],
            answer: [qsTr("Sister")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 5
        {
            edgeList: [
                [leftExt + nodeWidth, gen1 + nodeHeight / 2, rightInt, gen1 + nodeHeight / 2],
                [((leftExt + nodeWidth) + rightInt) / 2, gen1 + nodeHeight / 2, ((leftExt + nodeWidth) + rightInt) / 2, gen2],
                [leftInt + nodeWidth, gen2 + nodeHeight / 2, right, gen2 + nodeHeight / 2],
                [((leftInt + nodeWidth) + right) / 2, gen2 + nodeHeight / 2, ((leftInt + nodeWidth) + right) / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, left + nodeWidth / 2, gen3],
                [center + nodeWidth / 2, gen3 - nodeWidth / 4, center + nodeWidth / 2, gen3],
                [right + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [leftExt, gen1],
                [rightInt, gen1],
                [leftInt, gen2],
                [right, gen2],
                [left, gen3],
                [center, gen3],
                [right, gen3]
            ],
            captions: [
                [leftExt, gen3 + nodeHeight / 4],
                [leftExt, gen1 + nodeHeight]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "girl1.svg", "boy1.svg", "boy2.svg"],
            nodeWeights: [pair1, noPair, noPair, noPair, pair2, pair2, pair2],
            currentState: ["activeTo", "deactive", "deactive", "deactive", "active", "deactive", "deactive"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandfather")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 6
        {
            edgeList: [
                [leftExt + nodeWidth, gen1 + nodeHeight / 2, rightInt, gen1 + nodeHeight / 2],
                [((leftExt + nodeWidth) + rightInt) / 2, gen1 + nodeHeight / 2, ((leftExt + nodeWidth) + rightInt) / 2, gen2],
                [leftInt + nodeWidth, gen2 + nodeHeight / 2, right, gen2 + nodeHeight / 2],
                [((leftInt + nodeWidth) + right) / 2, gen2 + nodeHeight / 2, ((leftInt + nodeWidth) + right) / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, left + nodeWidth / 2, gen3],
                [center + nodeWidth / 2, gen3 - nodeWidth / 4, center + nodeWidth / 2, gen3],
                [right + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [leftExt, gen1],
                [rightInt, gen1],
                [leftInt, gen2],
                [right, gen2],
                [left, gen3],
                [center, gen3],
                [right, gen3]
            ],
            captions: [
                [right + nodeWidth, gen3 + (nodeHeight * 3 / 4)],
                [rightInt, gen1 + nodeHeight]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [noPair, pair1, noPair, noPair, pair2, pair2, pair2],
            currentState: ["deactive", "activeTo", "deactive", "deactive", "deactive", "deactive", "active", "active"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandmother")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")],
        },
        // level 7
        {
            edgeList: [
                [leftExt + nodeWidth, gen1 + nodeHeight / 2, rightInt, gen1 + nodeHeight / 2],
                [((leftExt + nodeWidth) + rightInt) / 2, gen1 + nodeHeight / 2, ((leftExt + nodeWidth) + rightInt) / 2, gen2],
                [leftInt + nodeWidth, gen2 + nodeHeight / 2, right, gen2 + nodeHeight / 2],
                [((leftInt + nodeWidth) + right) / 2, gen2 + nodeHeight / 2, ((leftInt + nodeWidth) + right) / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, left + nodeWidth / 2, gen3],
                [center + nodeWidth / 2, gen3 - nodeWidth / 4, center + nodeWidth / 2, gen3],
                [right + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [leftExt, gen1],
                [rightInt, gen1],
                [leftInt, gen2],
                [right, gen2],
                [left, gen3],
                [center, gen3],
                [right, gen3]
            ],
            captions: [
                [leftExt + nodeWidth, gen1],
                [right + nodeWidth, gen3]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "boy2.svg","girl1.svg" ],
            nodeWeights: [pair1, pair1, noPair, noPair, noPair, noPair, pair2],
            currentState: ["active", "deactive", "deactive", "deactive", "deactive", "deactive", "activeTo"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Granddaughter")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 8
        {
            edgeList: [
                [leftExt + nodeWidth, gen1 + nodeHeight / 2, rightInt, gen1 + nodeHeight / 2],
                [((leftExt + nodeWidth) + rightInt) / 2, gen1 + nodeHeight / 2, ((leftExt + nodeWidth) + rightInt) / 2, gen2],
                [leftInt + nodeWidth, gen2 + nodeHeight / 2, right, gen2 + nodeHeight / 2],
                [((leftInt + nodeWidth) + right) / 2, gen2 + nodeHeight / 2, ((leftInt + nodeWidth) + right) / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen3 - nodeWidth / 4, left + nodeWidth / 2, gen3],
                [center + nodeWidth / 2, gen3 - nodeWidth / 4, center + nodeWidth / 2, gen3],
                [right + nodeWidth / 2, gen3 - nodeWidth / 4, right + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [leftExt, gen1],
                [rightInt, gen1],
                [leftInt, gen2],
                [right, gen2],
                [left, gen3],
                [center, gen3],
                [right, gen3]
            ],
            captions: [
                [rightInt + nodeWidth, gen1],
                [right + nodeWidth, gen3]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [pair1, pair1, noPair, noPair, pair2, noPair, pair2],
            currentState: ["deactive", "active", "deactive", "deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandson")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 9
        {
            edgeList: [
                [center + nodeWidth / 2, gen1 + nodeHeight, center + nodeWidth / 2, gen2 + nodeHeight / 2],
                [rightXEdge(left), nodeMidPointY(gen2), right, nodeMidPointY(gen2)],
                [left + nodeWidth / 2, gen2 + nodeHeight, left + nodeWidth / 2, gen3],
                [right + nodeWidth / 2, gen2 + nodeHeight, right + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [center, gen1],
                [left, gen2],
                [right, gen2],
                [left, gen3],
                [right, gen3]
            ],
            captions: [
                [(right + nodeWidth * 1.1), gen3 + nodeHeight / 4],
                [left - nodeWidth / 2, gen3 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg","boy2.svg"],
            nodeWeights: [noPair, noPair, noPair, pair2, pair1],
            currentState: ["deactive", "deactive", "deactive", "activeTo","active"],
            edgeState:["others","others","others","others"],
            answer: [qsTr("Cousin")],
            options: [qsTr("Brother"), qsTr("Sister"), qsTr("Cousin")]
        },
        // level 10
        {
            edgeList: [
                [center + nodeWidth / 2, gen1 + nodeHeight, center + nodeWidth / 2, gen2 + nodeHeight / 2],
                [rightXEdge(left), nodeMidPointY(gen2), right, nodeMidPointY(gen2)],
                [left + nodeWidth / 2, gen2 + nodeHeight, left + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [center, gen1],
                [left, gen2],
                [right, gen2],
                [left, gen3]
            ],
            captions: [
                [left - nodeWidth * 3 / 4, gen3 + nodeHeight / 4],
                [right + nodeWidth * 1.1, gen2 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
            nodeWeights: [noPair, noPair, pair1, pair2],
            currentState: ["deactive", "deactive", "activeTo", "active"],
            edgeState:["others","others","others"],
            answer: [qsTr("Uncle")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 11
        {
            edgeList: [
                [center + nodeWidth / 2, gen1 + nodeHeight, center + nodeWidth / 2, gen2 + nodeHeight / 2],
                [rightXEdge(left), nodeMidPointY(gen2), right, nodeMidPointY(gen2)],
                [left + nodeWidth / 2, gen2 + nodeHeight, left + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [center, gen1],
                [left, gen2],
                [right, gen2],
                [left, gen3]
            ],
            captions: [
                [right + nodeWidth * 1.1, gen2 + nodeHeight / 4],
                [left - nodeWidth * 3 / 4, gen3 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
            nodeWeights: [noPair, noPair, pair2, pair1],
            currentState: ["deactive", "deactive", "active", "activeTo"],
            edgeState:["others","others","others"],
            answer: [qsTr("Nephew")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 12
        {
            edgeList: [
                [rightXEdge(left), gen1 + nodeHeight / 2, right, gen1 + nodeHeight / 2],
                [nodeMidPointX(left, right), nodeMidPointY(gen1), nodeMidPointX(left, right), nodeMidPointY(gen2)],
                [rightXEdge(left), nodeMidPointY(gen2), right, nodeMidPointY(gen2)],
                [left + nodeWidth / 2, gen2 + nodeHeight, left + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [left, gen1],
                [right, gen1],
                [left, gen2],
                [right, gen2],
                [left, gen3]
            ],
            captions: [
                [left - nodeWidth * 3 / 4, gen3 + nodeHeight / 4],
                [right + nodeWidth * 1.1, gen2 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babyboy.svg"],
            nodeWeights: [noPair, noPair, noPair, pair1, pair2],
            currentState: ["deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","siblings","others","others","others"],
            answer: [qsTr("Aunt")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 13
        {
            edgeList: [
                [rightXEdge(left), gen1 + nodeHeight / 2, right, gen1 + nodeHeight / 2],
                [nodeMidPointX(left, right), nodeMidPointY(gen1), nodeMidPointX(left, right), nodeMidPointY(gen2)],
                [rightXEdge(left), nodeMidPointY(gen2), right, nodeMidPointY(gen2)],
                [left + nodeWidth / 2, gen2 + nodeHeight, left + nodeWidth / 2, gen3]
            ],
            nodePositions: [
                [left, gen1],
                [right, gen1],
                [left, gen2],
                [right, gen2],
                [left, gen3]
            ],
            captions: [
                [right + nodeWidth * 1.1, gen2 + nodeHeight / 4],
                [left - nodeWidth / 2, gen3 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babygirl.svg"],
            nodeWeights: [noPair, noPair, noPair, pair2, pair1],
            currentState: ["deactive", "deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","siblings","others","others","others"],
            answer: [qsTr("Niece")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 14
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen1), rightExt, nodeMidPointY(gen1)],
                [nodeMidPointX(center, rightExt), nodeMidPointY(gen1), nodeMidPointX(center, rightExt), nodeMidPointY(gen2)],
                [rightXEdge(center), nodeMidPointY(gen2), rightExt, nodeMidPointY(gen2)],
                [rightXEdge(leftExt), nodeMidPointY(gen2), center, nodeMidPointY(gen2)]
            ],
            nodePositions: [
                [center, gen1],
                [rightExt, gen1],
                [center, gen2],
                [rightExt, gen2],
                [leftExt, gen2]
            ],
            captions: [
                [leftExt - nodeWidth / 2, gen2 + nodeHeight * 3 / 4],
                [center - nodeWidth * 3 / 4, gen1 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man3.svg", "man1.svg", "lady2.svg"],
            nodeWeights: [pair1, noPair, noPair, noPair, pair2],
            currentState: ["activeTo", "deactive", "deactive", "deactive", "active"],
            edgeState:["married","others","others","married"],
            answer: [qsTr("Father-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 15
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen1), rightExt, nodeMidPointY(gen1)],
                [nodeMidPointX(center, rightExt), nodeMidPointY(gen1), nodeMidPointX(center, rightExt), nodeMidPointY(gen2)],
                [rightXEdge(center), nodeMidPointY(gen2), rightExt, nodeMidPointY(gen2)],
                [rightXEdge(leftExt), nodeMidPointY(gen2), center, nodeMidPointY(gen2)]
            ],
            nodePositions: [
                [center, gen1],
                [rightExt, gen1],
                [center, gen2],
                [rightExt, gen2],
                [leftExt, gen2]
            ],
            captions: [
                [leftExt - nodeWidth / 2, gen2 + nodeHeight * 3 / 4],
                [rightExt + nodeWidth * 1.1, gen1 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man3.svg", "man1.svg", "lady2.svg"],
            nodeWeights: [noPair, pair1, noPair, noPair, pair2],
            currentState: ["deactive", "activeTo", "deactive", "deactive", "active"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Mother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 16
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen1), rightExt, nodeMidPointY(gen1)],
                [nodeMidPointX(center, rightExt), nodeMidPointY(gen1), nodeMidPointX(center, rightExt), nodeMidPointY(gen2)],
                [rightXEdge(center), nodeMidPointY(gen2), rightExt, nodeMidPointY(gen2)],
                [rightXEdge(leftExt), nodeMidPointY(gen2), center, nodeMidPointY(gen2)]
            ],
            nodePositions: [
                [center, gen1],
                [rightExt, gen1],
                [center, gen2],
                [rightExt, gen2],
                [leftExt, gen2]
            ],
            captions: [
                [leftExt - nodeWidth / 2, gen2 + nodeHeight * 3 / 4],
                [rightExt + nodeWidth * 1.1, gen2 + nodeHeight / 4]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man3.svg", "man1.svg", "lady2.svg"],
            nodeWeights: [noPair, noPair, noPair, pair1, pair2],
            currentState: ["deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Brother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 17
        {
            edgeList: [
                [rightXEdge(leftInt), nodeMidPointY(gen1), rightInt, nodeMidPointY(gen1)],
                [nodeMidPointX(leftInt, rightInt), nodeMidPointY(gen1), nodeMidPointX(leftInt, rightInt), nodeMidPointY(gen2)],
                [rightXEdge(leftInt), nodeMidPointY(gen2), rightInt, nodeMidPointY(gen2)],
                [rightXEdge(leftExt), nodeMidPointY(gen2), leftInt, nodeMidPointY(gen2)],
                [rightXEdge(rightInt), nodeMidPointY(gen2), rightExt, nodeMidPointY(gen2)]
            ],
            nodePositions: [
                [leftInt, gen1],
                [rightInt, gen1],
                [leftInt, gen2],
                [leftExt, gen2],
                [rightInt, gen2],
                [rightExt, gen2]
            ],
            captions: [
                [leftExt - nodeWidth / 2, gen2],
                [rightInt + nodeWidth, gen2]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "lady1.svg", "man1.svg"],
            nodeWeights: [noPair, noPair, noPair, pair1, pair2, noPair],
            currentState: ["dective", "deactive", "deactive", "active", "activeTo", "deactive"],
            edgeState:["married","others","others","married","married"],
            answer: [qsTr("Sister-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 18
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen1), rightExt, nodeMidPointY(gen1)],
                [nodeMidPointX(center, rightExt), nodeMidPointY(gen1), nodeMidPointX(center, rightExt), nodeMidPointY(gen2)],
                [rightXEdge(center), nodeMidPointY(gen2), rightExt, nodeMidPointY(gen2)],
                [rightXEdge(leftExt), nodeMidPointY(gen2), center, nodeMidPointY(gen2)]
            ],
            nodePositions: [
                [center, gen1],
                [rightExt, gen1],
                [center, gen2],
                [leftExt, gen2],
                [rightExt, gen2]
            ],
            captions: [
                [center - (nodeWidth * 3/ 4), gen1 + nodeHeight / 4],
                [leftExt - nodeWidth / 2, gen2 + nodeHeight / 2]
            ],
            nodeValue: ["grandfather.svg", "old-lady.svg", "lady2.svg", "man3.svg", "man1.svg"],
            nodeWeights: [pair1, pair1, noPair, pair2, noPair],
            currentState: ["active", "deactive", "deactive", "activeTo", "deactive", "deactive"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Son-in-law")],
            options: [qsTr("Son-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        }
    ]
}
