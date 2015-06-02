/* GCompris - computer-part.js
 *
 * Copyright (C) 2015 <atomsagar@gmail.com>
 *
 * Authors:
 *
 *   "Sagar Chand Agarwal" <atomsagar@gmail.com> (Qt Quick port)
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


var baseUrl = "qrc:/gcompris/src/activities/computer-part/resource/images/"

var dataset = [
            {
                "text" : qsTr("A monitor or a display is an electronic visual display for computers. The monitor comprises the display device, circuitry and an enclosure."),
                "name" : "Monitor",
                "img" : baseUrl + "monitor.svg"
            },
            {
                "text" : qsTr(" central processing unit (CPU) is the electronic circuitry within a computer that carries out the instructions of a computer program by performing the basic arithmetic, logical, control and input/output (I/O) operations specified by the instructions. "),
                "name" : "Central Processing Unit",
                "img" : baseUrl + "cpu.svg"
            },
            {
                "text" : qsTr(" the keyboard is used as a text entry interface to type text and numbers into a word processor, text editor or other programs.A keyboard is also used to give commands to the operating system of a computer"),
                "name" : "Keyboard",
                "img" : baseUrl + "keyboard.svg"
            },
            {
                "text" : qsTr("In computing, a mouse is a pointing device that detects two-dimensional motion relative to a surface. This motion is typically translated into the motion of a pointer on a display, which allows for fine control of a graphical user interface."),
                "name" : "Mouse",
                "img" : baseUrl + "mouse.svg"
            }
        ]
