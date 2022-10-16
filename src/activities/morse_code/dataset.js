/* GCompris - dataset.js
 *
 * Copyright (C) 2016 Souradeep Barua <sourad97@gmail.com>
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
                    values: ["_constant_",["A", "R", "N", "E", "H", "S", "I"]],
                    question: qsTr("Send Tux  %1  in morse."),
                    instruction: qsTr(" Use ' . ' and ' - ' (dot and hyphen/minus) on your keyboard to type Tux's message\n A = .-  N = -.  R = .-.  E = .  \nI = .. \tS = ... \tH = ...."),
                    toAlpha: false
                },
                {
                    values: ["_constant_",[".-", "-.", ".-.", ".", "..", "...", "...."]],
                    question: qsTr("Convert Tux's message %1 in alphabet."),
                    instruction:qsTr(" Can you decode Tux's message,\nthis time without the list?\nClick the List button on the right to see all letters in Morse"),
                    toAlpha: true
                },
                {
                    values: ["_random_",["O","T","M","W","G","K"]],
                    question: qsTr("Send Tux %1 in morse."),
                    instruction: qsTr(" Use ' . ' and ' - ' (dot and hyphen/minus) on your keyboard to type Tux's message\n T = - \tM = --	 O = --- \nW = .--\tG = --. \tK = -.-"),
                    toAlpha: false
                },
                {
                    values: ["_random_",["-","--","---",".--","--.","-.-"]],
                    question: qsTr("Convert Tux's message %1 in alphabet."),
                    instruction:qsTr(" Can you decode Tux's message,\nthis time without the list?\nClick the List button on the right to see all letters in Morse"),
                    toAlpha: true
                },
                {
                    values: ["_random_",["C","P","B","V","D","U"]],
                    question: qsTr("Send Tux %1 in morse."),
                    instruction: qsTr(" Use ' . ' and ' - ' (dot and hyphen/minus) on your keyboard to type Tux's message\n B = -... \tV = ...-	 C = -.-. \nP = .--.\tD = -.. \tU = ..-"),
                    toAlpha: false
                },
                {
                    values: ["_random_",["-...","...-","-.-.","-..","..-",".--."]],
                    question: qsTr("Convert Tux's message %1 in alphabet."),
                    instruction:qsTr(" Can you decode Tux's message,\nthis time without the list?\nClick the List button on the right to see all letters in Morse"),
                    toAlpha: true
                },
                {
                    values: ["_random_",["J","F","L","Q","X","Y","Z"]],
                    question: qsTr("Send Tux %1 in morse."),
                    instruction: qsTr(" Use ' . ' and ' - ' (dot and hyphen/minus) on your keyboard to type Tux's message\nJ = .--- F = ..-. L = .-.. Q = --.- \nX = -..-  Y = -.--  Z = --.."),
                    toAlpha: false
                },
                {
                    values: ["_random_",[".---","..-.",".-..","--.-","-..-","-.--","--.."]],
                    question: qsTr("Convert Tux's message %1 in alpha."),
                    instruction:qsTr(" Can you decode Tux's message,\nthis time without the list?\nClick the List button on the right to see all letters in Morse"),
                    toAlpha: true
                },
                {
                    values: ["_constant_",["1","2","3","4","5"]],
                    question: qsTr("Send Tux %1 in morse."),
                    instruction:qsTr(" Morse for digits always contain 5 dots or dashes. \n1 = .----\t2 = ..---\t3 = ...--\n4 = ....-\t5 = ....."),
                    toAlpha: false
                },
                {
                    values: ["_random_",[".----","..---","...--","....-","....."]],
                    question: qsTr("Convert Tux's message %1 in digit."),
                    instruction:qsTr(" Can you decode Tux's message,\nthis time without the list?\nClick the List button on the right to see all digits in Morse"),
                    toAlpha: true
                },
                {
                    values: ["_constant_",["6","7","8","9"]],
                    question: qsTr("Send Tux %1 in morse."),
                    instruction:qsTr(" 6 = -....\t7 = --...\t8 = ---..\n  9 = ----.\t0 = -----"),
                    toAlpha: false
                },
                {
                    values: ["_constant_",["-....","--...","---..","----.","-----"]],
                    question: qsTr("Convert Tux's message %1 in morse."),
                    instruction:qsTr(" Can you decode Tux's message,\nthis time without the list?\nClick the List button on the right to see all digits in Morse"),
                    toAlpha: true
                },
          ];
}
