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
    objective: qsTr("Balance up to 50.")
    difficulty: 3
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
            "masses": [[10, "10"], [7, "7"], [6, "6"], [11, "11"], [13, "13"], [11, "11"], [3, "3"]],
            "targets": [[12, "12"], [15,"15"], [19, "19"], [20,"20"],[17,"17"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[14, "14"], [17, "17"], [5, "5"], [15, "15"], [22, "22"], [10, "10"], [20, "20"]],
            "targets": [[23, "23"], [25,"25"], [29, "29"], [30,"30"],[17,"17"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[21, "21"], [4, "4"], [15, "15"], [22, "22"], [24, "24"], [23, "23"], [24, "24"]],
            "targets": [[42, "42"], [48,"48"], [39, "39"], [47,"47"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[1, "1"], [7, "7"], [2, "2"], [5, "5"], [7, "7"], [1, "1"], [2, "2"]],
            "targets": [[14, "14"], [19, "19"], [11, "11"],[15,"15"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
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
        }
    ]
}
