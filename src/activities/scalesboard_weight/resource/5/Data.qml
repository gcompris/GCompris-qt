/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Balance up to 100 grams.")
    difficulty: 4

    function g(value) {
           /* g == gram */
           return qsTr("%1 g").arg(value)
       }
        data: [
            {
                "masses": [[3, g(3)], [5, g(5)], [7, g(7)], [8, g(8)], [9, g(9)], [2, g(2)], [5, g(5)]],
                "targets": [[8, g(8)], [13, g(13)], [15, g(15)],[17, g(17)],[20, g(20)],[10, g(10)],[11, g(11)]],
                "rightDrop": false,
                "message": qsTr('The "g" symbol at the end of a number means gram. \n Drop weights on the left side to balance the scales.')
            },
            {
                "masses": [[10, g(10)], [11, g(11)], [14, g(14)], [5, g(5)], [15, g(15)], [13, g(13)], [12, g(12)]],
                "targets": [[22, g(22)], [28, g(28)], [19, g(19)],[30, g(30)],[20, g(20)],[25, g(25)],[27, g(27)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[20, g(20)], [28, g(28)], [30, g(30)], [12, g(12)], [17, g(17)], [29, g(29)], [15, g(15)]],
                "targets": [[35, g(35)], [48, g(48)], [40, g(40)], [50, g(50)], [37, g(37)], [49, g(49)], [43, g(43)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[50, g(50)], [28, g(28)], [15, g(15)], [10, g(10)], [17, g(17)], [29, g(29)], [28, g(28)]],
                "targets": [[65, g(65)], [78, g(78)], [60, g(60)], [94, g(94)], [77, g(77)], [85, g(85)], [89, g(89)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[20, g(20)], [14, g(14)], [21, g(21)], [13, g(13)], [14, g(14)], [22, g(22)], [12, g(12)]],
                "targets": [[23, g(23)], [25, g(25)], [29, g(29)], [30, g(30)],[17, g(17)]],
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),
                "rightDrop": true
            },
            {
                "masses": [[8, g(8)], [6, g(6)], [15, g(15)], [10, g(10)], [25, g(25)], [23, g(23)], [24, g(24)]],
                "targets": [[42, g(42)], [41, g(41)], [39, g(39)], [40, g(40)]],
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),
                "rightDrop": true
            },
            {

                "masses": [[50, g(50)], [7, g(7)], [18, g(18)], [22, g(22)], [24, g(24)], [20, g(20)], [13, g(13)]],
                "targets": [[83, g(83)], [81, g(81)], [79, g(79)], [87, g(87)]],
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),
                "rightDrop": true
            },
            {
                "masses": [[11, g(11)], [6, g(6)], [2, g(2)], [12, g(12)], [13, g(13)], [9, g(9)], [10, g(10)]],
                "targets": [[17, g(17)], [29, g(29)], [23, g(23)],[25, g(25)],[21, g(21)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[23, g(23)], [22, g(22)], [30, g(30)], [8, g(8)], [24, g(24)], [22, g(22)], [20, g(20)]],
                "targets": [[44, g(44)], [38, g(38)], [50, g(50)],[31, g(31)],[47, g(47)],[43, g(43)],[30, g(30)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[10, g(10)], [11, g(11)], [14, g(14)], [5, g(5)], [15, g(15)], [13, g(13)], [12, g(12)]],
                "targets": [[22, g(22)], [28, g(28)], [19, g(19)],[30, g(30)],[20, g(20)],[25, g(25)],[27, g(27)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[20, g(20)], [28, g(28)], [30, g(30)], [12, g(12)], [17, g(17)], [29, g(29)], [15, g(15)]],
                "targets": [[35, g(35)], [48, g(48)], [40, g(40)], [50, g(50)], [37, g(37)], [49, g(49)], [43, g(43)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[50, g(50)], [28, g(28)], [15, g(15)], [10, g(10)], [17, g(17)], [29, g(29)], [28, g(28)]],
                "targets": [[65, g(65)], [78, g(78)], [60, g(60)], [94, g(94)], [77, g(77)], [85, g(85)], [89, g(89)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            }
        ]
}
