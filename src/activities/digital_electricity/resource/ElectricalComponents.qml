/* GCompris
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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
import QtQuick 2.3

QtObject {
    property variant components : [
        {
            "imgName": "zero.svg",
            "imgWidth": 0.12,
            "imgHeight": 0.2,
            "toolTipText": qsTr("Zero input"),
            "terminalSize": 0.205,
            "inputTerminals": [],
            "outputTerminals": [
                {
                    "posX": 0.91,
                    "posY": 0.5,
                    "value": 0
                }
            ],
            "information": qsTr("Digital electronics is a branch of electronics that handle digital signals " +
                                "(i.e discrete signals instead of continous signals). Therefore all values within " +
                                "a range or band represent the same numeric value. In most cases, the number of " +
                                "these states is two and they are represented by two voltage bands: one near a " +
                                "reference value (typically termed as 'ground' or zero volts), and other value near " +
                                "the supply voltage. These correspond to the 'false' ('0') and 'true' ('1') values " +
                                "of the Boolean domain respectively (named after its inventor, George Boole). " +
                                "In this activity, you can give '0' and '1' as input to other logical devices, " +
                                "and see their output through an output device."),
            "truthTable": []

        },
        {
            "imgName": "one.svg",
            "imgWidth": 0.12,
            "imgHeight": 0.2,
            "toolTipText": qsTr("One input"),
            "terminalSize": 0.218,
            "inputTerminals": [],
            "outputTerminals": [
                {
                    "posX": 0.91,
                    "posY": 0.5,
                    "value": 1
                }
            ],
            "information": qsTr("Digital electronics is a branch of electronics that handle digital signals " +
                                "(i.e discrete signals instead of continous signals). Therefore all values within " +
                                "a range or band represent the same numeric value. In most cases, the number of " +
                                "these states is two and they are represented by two voltage bands: one near a " +
                                "reference value (typically termed as 'ground' or zero volts), and other value near " +
                                "the supply voltage. These correspond to the 'false' ('0') and 'true' ('1') values " +
                                "of the Boolean domain respectively (named after its inventor, George Boole). " +
                                "In this activity, you can give '0' and '1' as input to other logical devices, " +
                                "and see their output through an output device."),
            "truthTable": []
        },
        {
            "imgName": "BCDTo7Segment.svg",
            "imgWidth": 0.3,
            "imgHeight": 0.4,
            "toolTipText": qsTr("BCD To 7 Segment"),
            "terminalSize": 0.097,
            "inputTerminals": [
                {
                    "posX": 0.031,
                    "posY": 0.057
                },
                {
                    "posX": 0.031,
                    "posY": 0.35
                },
                {
                    "posX": 0.031,
                    "posY": 0.649
                },
                {
                    "posX": 0.031,
                    "posY": 0.935
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.969,
                    "posY": 0.048
                },
                {
                    "posX": 0.969,
                    "posY": 0.198
                },
                {
                    "posX": 0.969,
                    "posY": 0.353
                },
                {
                    "posX": 0.968,
                    "posY": 0.509
                },
                {
                    "posX": 0.969,
                    "posY": 0.664
                },
                {
                    "posX": 0.969,
                    "posY": 0.812
                },
                {
                    "posX": 0.969,
                    "posY": 0.952
                }
            ],
            "information": qsTr("BCD to 7 segment converter takes 4 binary inputs in its input terminals and gives " +
                                "7 binary outputs. The 4 binary inputs represents a BCD number (binary-coded decimal). " +
                                "The converter converts this BCD number to corresponding bits, which are used to " +
                                "display the decimal number (represented by the BCD number) on the 7 segment display. " +
                                "The truth table for BCD To 7 Segment converted is:"),
            "truthTable": [['A','B','C','D','a','b','c','d','e','f','g'],
                           ['0','0','0','0','1','1','1','1','1','1','0'],
                           ['0','0','0','1','0','1','1','0','0','0','0'],
                           ['0','0','1','0','1','1','0','1','1','0','1'],
                           ['0','0','1','1','1','1','1','1','0','0','1'],
                           ['0','1','0','0','0','1','1','0','0','1','1'],
                           ['0','1','0','1','1','0','1','1','0','1','1'],
                           ['0','1','1','0','1','0','1','1','1','1','1'],
                           ['0','1','1','1','1','1','1','0','0','0','0'],
                           ['1','0','0','0','1','1','1','1','1','1','1'],
                           ['1','0','0','1','1','1','1','1','0','1','1']]
        },
        {
            "imgName": "sevenSegmentDisplay.svgz",
            "imgWidth": 0.18,
            "imgHeight": 0.4,
            "toolTipText": qsTr("7 Segment Display"),
            "terminalSize": 0.116,
            "inputTerminals": [
                {
                    "posX": 0.06,
                    "posY": 0.058
                },
                {
                    "posX": 0.06,
                    "posY": 0.195
                },
                {
                    "posX": 0.06,
                    "posY": 0.337
                },
                {
                    "posX": 0.06,
                    "posY": 0.484
                },
                {
                    "posX": 0.06,
                    "posY": 0.636
                },
                {
                    "posX": 0.06,
                    "posY": 0.791
                },
                {
                    "posX": 0.06,
                    "posY": 0.942
                }
            ],
            "outputTerminals": [],
            "information": qsTr("7 segment display takes 7 binary inputs in its input terminals. The display " +
                                "consists of 7 segments and each segment gets lighted according to the input. " +
                                "By generating different combination of binary inputs, the display can be used to " +
                                "display various different symbols. The diagram is:"),
            "truthTable": []
        },
        {
            "imgName": "comparator.svg",
            "imgWidth": 0.3,
            "imgHeight": 0.25,
            "toolTipText": qsTr("Comparator"),
            "terminalSize": 0.214,
            "inputTerminals": [
                {
                    "posX": 0.039,
                    "posY": 0.211
                },
                {
                    "posX": 0.039,
                    "posY": 0.784
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.961,
                    "posY": 0.128
                },
                {
                    "posX": 0.961,
                    "posY": 0.481
                },
                {
                    "posX": 0.961,
                    "posY": 0.88
                }
            ],
            "information": qsTr("Comparator takes 2 numbers as input, A and B. It compares them and outputs 3 " +
                                "values. First value is true if A < B, else it is false. Second value is true " +
                                "if A = B, else it is false. Third value is true if A > B, else it is false. " +
                                "In digital electronics, true value is represented as 1, and false value is " +
                                "represented as 0"),
            "truthTable": []
        },
        {
            "imgName": "switchOff.svg",
            "imgWidth": 0.18,
            "imgHeight": 0.15,
            "toolTipText": qsTr("Switch"),
            "terminalSize": 0.552,
            "inputTerminals": [
                {
                    "posX": 0.065,
                    "posY": 0.503
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.935,
                    "posY": 0.497
                }
            ],
            "information": qsTr("Switch is used to maintain easy connection between two terminals. If the switch is " +
                                "turned on, then the two terminals are connected and current can flow through the " +
                                "switch. If the switch is turned off, then the connection between terminal is broken, " +
                                "and current can not flow through it."),
            "truthTable": []
        },
        {
            "imgName": "gateAnd.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("AND gate"),
            "terminalSize": 0.246,
            "inputTerminals": [
                {
                    "posX": 0.045,
                    "posY": 0.219
                },
                {
                    "posX": 0.045,
                    "posY": 0.773
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.955,
                    "posY": 0.5
                }
            ],
            "information": qsTr("AND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                "value. The output is 0 if any of the input is 0, else it is 1. In this activity, " +
                                "a 2 input AND gate is shown. Truth table for 2 input AND gate is:"),
            "truthTable": [['A','B',"A.B"],
                           ['0','0','0'],
                           ['0','1','0'],
                           ['1','0','0'],
                           ['1','1','1']]
        },
        {
            "imgName": "gateNand.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("NAND gate"),
            "terminalSize": 0.273,
            "inputTerminals": [
                {
                    "posX": 0.045,
                    "posY": 0.174
                },
                {
                    "posX": 0.045,
                    "posY": 0.786
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.955,
                    "posY": 0.484
                }
            ],
            "information": qsTr("NAND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                "value. It is the complement of AND gate. In this activity, a 2 input NAND gate is " +
                                "shown. Truth table for 2 input NAND gate is:"),
            "truthTable": [['A','B',"~(A.B)"],
                           ['0','0','1'],
                           ['0','1','1'],
                           ['1','0','1'],
                           ['1','1','0']]
        },
        {
            "imgName": "gateNor.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("NOR gate"),
            "terminalSize": 0.251,
            "inputTerminals": [
                {
                    "posX": 0.045,
                    "posY": 0.205
                },
                {
                    "posX": 0.045,
                    "posY": 0.769
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.955,
                    "posY": 0.491
                }
            ],
            "information": qsTr("NOR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                "value. It is the complement of OR gate. In this activity, a 2 input NOR gate is " +
                                "shown. Truth table for 2 input NOR gate is:"),
            "truthTable": [['A','B',"~(A+B)"],
                           ['0','0','1'],
                           ['0','1','0'],
                           ['1','0','0'],
                           ['1','1','0']]
        },
        {
            "imgName": "gateNot.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("Not gate"),
            "terminalSize": 0.261,
            "inputTerminals": [
                {
                    "posX": 0.046,
                    "posY": 0.503
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.954,
                    "posY": 0.492
                }
            ],
            "information": qsTr("Not gate (also known as inverter) takes a binary input in its input terminal and " +
                                "outputs a single value. The output is the complement of the input value, that is, it " +
                                "is 0 if input is 1, and 1 if input is 0. Truth table for NOT gate is:"),
            "truthTable": [['A',"~A"],
                           ['0','1'],
                           ['1','0']]
        },
        {
            "imgName": "gateOr.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("Or gate"),
            "terminalSize": 0.251,
            "inputTerminals": [
                {
                    "posX": 0.045,
                    "posY": 0.223
                },
                {
                    "posX": 0.045,
                    "posY": 0.786
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.955,
                    "posY": 0.509
                }
            ],
            "information": qsTr("OR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                "value. The output is 1 if any of the input is 1, else it is 0. In this activity, a " +
                                "2 input OR gate is shown. Truth table for 2 input OR gate is:"),
            "truthTable": [['A','B',"A+B"],
                           ['0','0','0'],
                           ['0','1','1'],
                           ['1','0','1'],
                           ['1','1','1']]
        },
        {
            "imgName": "gateXor.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("Xor gate"),
            "terminalSize": 0.229,
            "inputTerminals": [
                {
                    "posX": 0.045,
                    "posY": 0.248
                },
                {
                    "posX": 0.045,
                    "posY": 0.762
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.955,
                    "posY": 0.509
                }
            ],
            "information": qsTr("XOR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                "value. The output is 1 if number of '1' in input is odd, and 0 if number of '1' in " +
                                "input is even. In this activity, a 2 input XOR gate is shown. Truth table for " +
                                "2 input XOR gate is:"),
            "truthTable": [['A','B',"A^B"],
                           ['0','0','0'],
                           ['0','1','1'],
                           ['1','0','1'],
                           ['1','1','0']]
        },
        {
            "imgName": "ledOff.svg",
            "imgWidth": 0.16,
            "imgHeight": 0.2,
            "toolTipText": qsTr("LED"),
            "terminalSize": 0.111,
            "inputTerminals": [
                {
                    "posX": 0.319,
                    "posY": 0.945
                },
                {
                    "posX": 0.776,
                    "posY": 0.698
                }
            ],
            "outputTerminals": [],
            "information": qsTr("LED (Light-emitting diode) is a two-lead semiconductor light source. It emits " +
                                "light when activated. LED has 2 input terminals, the longer terminal is the " +
                                "positive terminal (anode) and smaller terminal is the negative terminal (cathode)" +
                                ". LED is activated when anode has a higher potential than cathode. In digital " +
                                "electronics LED can be used to check the output of the components. Connect " +
                                "the cathode of LED to ground ('0') and anode of LED to the output of the " +
                                "component. If output is 1, the LED will be activated (emit light), and if " +
                                "output is 0, the LED will be deactivated."),
            "truthTable": []
        }
    ]
}
