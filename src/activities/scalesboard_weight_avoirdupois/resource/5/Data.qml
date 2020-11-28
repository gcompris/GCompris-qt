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
    objective: qsTr("Balance up to 100 ounces.")
    difficulty: 4

    function oz(value) {
               /* oz == ounce */
               return qsTr("%1 oz").arg(value)
           }

    data: [
        {
            "masses": [[3, oz(3)], [5, oz(5)], [7, oz(7)], [8, oz(8)], [9, oz(9)], [2, oz(2)], [5, oz(5)]],
            "targets": [[8, oz(8)], [13, oz(13)], [15, oz(15)], [17, oz(17)], [20, oz(20)], [10, oz(10)], [11, oz(11)]],
            "rightDrop": false,
            "message": qsTr('The "oz" symbol at the end of a number means ounce. \n Drop weights on the left side to balance the scales.')
        },
        {
            "masses": [[10, oz(10)], [11, oz(11)], [14, oz(14)], [5, oz(5)], [15, oz(15)], [13, oz(13)], [12, oz(12)]],
            "targets": [[22, oz(22)], [28, oz(28)], [19, oz(19)], [30, oz(30)], [20, oz(20)], [25, oz(25)], [27, oz(27)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[20, oz(20)], [28, oz(28)], [30, oz(30)], [12, oz(12)], [17, oz(17)], [29, oz(29)], [15, oz(15)]],
            "targets": [[35, oz(35)], [48, oz(48)], [40, oz(40)], [50, oz(50)], [37, oz(37)], [49, oz(49)], [43, oz(43)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[50, oz(50)], [28, oz(28)], [15, oz(15)], [10, oz(10)], [17, oz(17)], [29, oz(29)], [28, oz(28)]],
            "targets": [[65, oz(65)], [78, oz(78)], [60, oz(60)], [94, oz(94)], [77, oz(77)], [85, oz(85)], [89, oz(89)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[20, oz(20)], [14, oz(14)], [21, oz(21)], [13, oz(13)], [14, oz(14)], [22, oz(22)], [12, oz(12)]],
            "targets": [[23, oz(23)], [25, oz(25)], [29, oz(29)], [30, oz(30)],[17, oz(17)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[8, oz(8)], [6, oz(6)], [15, oz(15)], [10, oz(10)], [25, oz(25)], [23, oz(23)], [24, oz(24)]],
            "targets": [[42, oz(42)], [41, oz(41)], [39, oz(39)], [40, oz(40)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[50, oz(50)], [7, oz(7)], [18, oz(18)], [22, oz(22)], [24, oz(24)], [20, oz(20)], [13, oz(13)]],
            "targets": [[83, oz(83)], [81, oz(81)], [79, oz(79)], [87, oz(87)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[11, oz(11)], [6, oz(6)], [2, oz(2)], [12, oz(12)], [13, oz(13)], [9, oz(9)], [10, oz(10)]],
            "targets": [[17, oz(17)], [29, oz(29)], [23, oz(23)], [25, oz(25)], [21, oz(21)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[23, oz(23)], [22, oz(22)], [30, oz(30)], [8, oz(8)], [24, oz(24)], [22, oz(22)], [20, oz(20)]],
            "targets": [[44, oz(44)], [38, oz(38)], [50, oz(50)], [31, oz(31)], [47, oz(47)], [43, oz(43)], [30, oz(30)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[10, oz(10)], [11, oz(11)], [14, oz(14)], [5, oz(5)], [15, oz(15)], [13, oz(13)], [12, oz(12)]],
            "targets": [[22, oz(22)], [28, oz(28)], [19, oz(19)], [30, oz(30)], [20, oz(20)], [25, oz(25)], [27, oz(27)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[20, oz(20)], [28, oz(28)], [30, oz(30)], [12, oz(12)], [17, oz(17)], [29, oz(29)], [15, oz(15)]],
            "targets": [[35, oz(35)], [48, oz(48)], [40, oz(40)], [50, oz(50)], [37, oz(37)], [49, oz(49)], [43, oz(43)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[50, oz(50)], [28, oz(28)], [15, oz(15)], [10, oz(10)], [17, oz(17)], [29, oz(29)], [28, oz(28)]],
            "targets": [[65, oz(65)], [78, oz(78)], [60, oz(60)], [94, oz(94)], [77, oz(77)], [85, oz(85)], [89, oz(89)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
         }
    ]
}
