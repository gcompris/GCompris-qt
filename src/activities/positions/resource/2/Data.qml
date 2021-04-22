/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0
import "qrc:/gcompris/src/activities/positions/positions.js" as Activity

Data {
    objective: qsTr("All positions (with left and right).")
    difficulty: 2
    property var questionsList: [
        {
            "id": Activity.rightPosition,
            //: it refers to the position on the right side
            "position": qsTr("right"),
            "text": qsTr ("Select the image where the child is at the right of the box.")
        },
        {
            "id": Activity.leftPosition,
            //: it refers to the position on the left side
            "position": qsTr("left"),
            "text": qsTr ("Select the image where the child is at the left of the box.")
        },
        {
            "id": Activity.behindPosition,
            //: it refers to the behind position
            "position": qsTr("behind"),
            "text": qsTr("Select the image where the child is behind the box.")
        },
        {
            "id": Activity.inFrontOfPosition,
            //: it refers to the in front of position
            "position": qsTr("in front of"),
            "text": qsTr("Select the image where the child is in front of the box.")
        },
        {
            "id": Activity.insidePosition,
            //: it refers to the inside position
            "position": qsTr("inside"),
            "text": qsTr("Select the image where the child is inside the box.")
        },
        {
            "id": Activity.abovePosition,
            //: it refers to the above position
            "position": qsTr("above"),
            "text": qsTr("Select the image where the child is above the box.")
        },
        {
            "id": Activity.underPosition,
            //: it refers to the beneath position
            "position": qsTr("under"),
            "text": qsTr("Select the image where the child is under the box.")
        }
    ]
    data: [
        {
            "generateRandomPositions": true,
            "questions": questionsList
        },
        {
            "generateRandomPositions": true,
            "questions": questionsList
        }
    ]
}
