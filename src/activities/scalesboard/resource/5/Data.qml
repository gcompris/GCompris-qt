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
    objective: qsTr("Balance up to 100.")
    difficulty: 4
    data: [
        {
            "masses": [[3, "3"], [5, "5"], [7, "7"], [8, "8"], [9, "9"], [2, "2"], [5, "5"]],
            "targets": [[8, "8"], [13, "13"], [15, "15"],[17,"17"],[20,"20"],[10,"10"],[11,"11"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[10, "10"], [11, "11"], [14, "14"], [5, "5"], [15, "15"], [13, "13"], [12, "12"]],
            "targets": [[22, "22"], [28, "28"], [19, "19"],[30,"30"],[20,"20"],[25,"25"],[27,"27"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[20, "20"], [28, "28"], [30, "30"], [12, "12"], [17, "17"], [29, "29"], [15, "15"]],
            "targets": [[35, "35"], [48, "48"], [40, "40"], [50, "50"], [37, "37"], [49, "49"], [43, "43"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[50, "50"], [28, "28"], [15, "15"], [10, "10"], [17, "17"], [29, "29"], [28, "28"]],
            "targets": [[65, "65"], [78, "78"], [60, "60"], [94, "94"], [77, "77"], [85, "85"], [89, "89"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[20, "20"], [14, "14"], [21, "21"], [13, "13"], [14, "14"], [22, "22"], [12, "12"]],
            "targets": [[23, "23"], [25,"25"], [29, "29"], [30,"30"],[17,"17"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[8, "8"], [6, "6"], [15, "15"], [10, "10"], [25, "25"], [23, "23"], [24, "24"]],
            "targets": [[42, "42"], [41,"41"], [39, "39"], [40,"40"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[50, "50"], [7, "7"], [18, "18"], [22, "22"], [24, "24"], [20, "20"], [13, "13"]],
            "targets": [[83, "83"], [81,"81"], [79, "79"], [87,"87"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[11, "11"], [6, "6"], [2, "2"], [12, "12"], [13, "13"], [9, "9"], [10, "10"]],
            "targets": [[17, "17"], [29, "29"], [23, "23"],[25,"25"],[21,"21"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[23, "23"], [22, "22"], [30, "30"], [8, "8"], [24, "24"], [22, "22"], [20, "20"]],
            "targets": [[44, "44"], [38, "38"], [50, "50"],[31,"31"],[47,"47"],[43,"43"],[30,"30"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[10, "10"], [11, "11"], [14, "14"], [5, "5"], [15, "15"], [13, "13"], [12, "12"]],
            "targets": [[22, "22"], [28, "28"], [19, "19"],[30,"30"],[20,"20"],[25,"25"],[27,"27"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[20, "20"], [28, "28"], [30, "30"], [12, "12"], [17, "17"], [29, "29"], [15, "15"]],
            "targets": [[35, "35"], [48, "48"], [40, "40"], [50, "50"], [37, "37"], [49, "49"], [43, "43"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[50, "50"], [28, "28"], [15, "15"], [10, "10"], [17, "17"], [29, "29"], [28, "28"]],
            "targets": [[65, "65"], [78, "78"], [60, "60"], [94, "94"], [77, "77"], [85, "85"], [89, "89"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        }
    ]
}
