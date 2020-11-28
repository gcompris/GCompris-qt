/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("The spaceship rotates when you use the direction keys.")
    difficulty: 5
    data: [
       {
                "planet": qsTr("Ceres"),
                "gravity": 0.27,
                "maxAccel": 0.054,
                "accelSteps": 2,
                "alt": 75.0,
                "mode": "rotation",
                "fuel" : -1,
                "intro": qsTr("The up and down keys control the thrust of the rear engine."
                           + "<br/>The right and left keys now control the rotation of the ship."
                           + "<br/>To move the ship in horizontal direction you must first rotate and then accelerate.")
       },
       {
                "planet": qsTr("Pluto"),
                "gravity": 0.62,
                "maxAccel": 0.186,
                "accelSteps": 3,
                "alt": 100.0,
                "mode": "rotation",
                "fuel" : -1
       },
       {
                "planet": qsTr("Titan"),
                "gravity": 1.352,
                "maxAccel": 0.406,
                "accelSteps": 3,
                "alt": 100.0,
                "mode": "rotation",
                "fuel" : -1
       },
       {
                "planet": qsTr("Moon"),
                "gravity": 1.622,
                "maxAccel": 0.324,
                "accelSteps": 4,
                "alt": 150.0,
                "mode": "rotation",
                "fuel" : 10
       },
       {
                "planet": qsTr("Mars"),
                "gravity": 3.711,
                "maxAccel": 0.619,
                "accelSteps": 5,
                "alt": 200.0,
                "mode": "rotation",
                "fuel" : 20
       },
       {
                "planet": qsTr("Venus"),
                "gravity": 8.87,
                "maxAccel": 1.331,
                "accelSteps": 6,
                "alt": 300.0,
                "mode": "rotation",
                "fuel" : 70
       },
       {
                "planet": qsTr("Earth"),
                "gravity": 9.807,
                "maxAccel": 1.373,
                "accelSteps": 7,
                "alt": 350.0,
                "mode": "rotation",
                "fuel" : 70
       }
    ]
}
