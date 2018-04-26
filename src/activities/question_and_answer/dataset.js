/* GCompris - dataset.js
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   "Amit Sagtani" <asagtani06@gmail.com>
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

function get() {
    return [
                {
                    category: "Multiplication",
                    category_image_src: "qrc:/gcompris/src/activities/algebra_by/algebra_by.svg",
                    operator:"*",
                    questions: [
                        ["2 * 1", "2 * 2", "2 * 3", "2 * 4", "2 * 5", "2 * 6", "2 * 7", "2 * 8", "2 * 9"],
                        ["3 * 1", "3 * 2", "3 * 3", "3 * 4", "3 * 5", "3 * 6", "3 * 7", "3 * 8", "3 * 9"],
                        ["4 * 1", "4 * 2", "4 * 3", "4 * 4", "4 * 5", "4 * 6", "4 * 7", "4 * 8", "4 * 9"],
                        ["5 * 1", "5 * 2", "5 * 3", "5 * 4", "5 * 5", "5 * 6", "5 * 7", "5 * 8", "5 * 9"],
                        ["6 * 1", "6 * 2", "6 * 3", "6 * 4", "6 * 5", "6 * 6", "6 * 7", "6 * 8", "6 * 9"],
                        ["7 * 1", "7 * 2", "7 * 3", "7 * 4", "7 * 5", "7 * 6", "7 * 7", "7 * 8", "7 * 9"],
                        ["8 * 1", "8 * 2", "8 * 3", "8 * 4", "8 * 5", "8 * 6", "8 * 7", "8 * 8", "8 * 9"],
                        ["9 * 1", "9 * 2", "9 * 3", "9 * 4", "9 * 5", "9 * 6", "9 * 7", "9 * 8", "9 * 9"]
                    ],
                    answers: [
                        ["2", "4", "6", "8", "10", "12", "14", "16", "18", "20"],
                        ["3", "6", "9", "12", "15", "18", "21", "24", "27", "30"],
                        ["4", "8", "12", "16", "20", "24", "28", "32", "36", "40"],
                        ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50"],
                        ["6", "12", "18", "24", "30", "36", "42", "48", "54", "60"],
                        ["7", "14", "21", "28", "35", "42", "49", "56", "63", "70"],
                        ["8", "16", "24", "32", "40", "48", "56", "64", "72", "80"],
                        ["9", "18", "27", "36", "45", "54", "63", "72", "81", "90"]
                    ]
                },

                {
                    category: "Addition",
                    category_image_src: "qrc:/gcompris/src/activities/algebra_plus/algebra_plus.svg",
                    operator:"+",
                    questions: [
                        ["2 + 1", "2 + 2", "2 + 3", "2 + 4", "2 + 5", "2 + 6", "2 + 7", "2 + 8", "2 + 9"],
                        ["3 + 1", "3 + 2", "3 + 3", "3 + 4", "3 + 5", "3 + 6", "3 + 7", "3 + 8", "3 + 9"],
                        ["4 + 1", "4 + 2", "4 + 3", "4 + 4", "4 + 5", "4 + 6", "4 + 7", "4 + 8", "4 + 9"],
                        ["5 + 1", "5 + 2", "5 + 3", "5 + 4", "5 + 5", "5 + 6", "5 + 7", "5 + 8", "5 + 9"],
                        ["6 + 1", "6 + 2", "6 + 3", "6 + 4", "6 + 5", "6 + 6", "6 + 7", "6 + 8", "6 + 9"],
                        ["7 + 1", "7 + 2", "7 + 3", "7 + 4", "7 + 5", "7 + 6", "7 + 7", "7 + 8", "7 + 9"],
                        ["8 + 1", "8 + 2", "8 + 3", "8 + 4", "8 + 5", "8 + 6", "8 + 7", "8 + 8", "8 + 9"],
                        ["9 + 1", "9 + 2", "9 + 3", "9 + 4", "9 + 5", "9 + 6", "9 + 7", "9 + 8", "9 + 9"]
                    ],
                    answers: [
                        ["3", "4", "5", "6", "7", "8", "9", "10", "11"],
                        ["4", "5", "6", "7", "8", "9", "10", "11", "12"],
                        ["5", "6", "7", "8", "9", "10", "11", "12", "13"],
                        ["6", "7", "8", "9", "10", "11", "12", "13", "14"],
                        ["7", "8", "9", "10", "11", "12", "13", "14", "15"],
                        ["8", "9", "10", "11", "12", "13", "14", "15", "16"],
                        ["9", "10", "11", "12", "13", "14", "15", "16", "17"],
                        ["10", "11", "12", "13", "14", "15", "16", "17", "18"]
                    ]
                }
            ]
}
