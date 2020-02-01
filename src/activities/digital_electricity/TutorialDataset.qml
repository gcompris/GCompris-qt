/* GCompris - Dataset.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Gtk+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
    property var zero: {
        'imageName': 'zero.svg',
        'componentSource': 'Zero.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Zero input")
    }
    property var one: {
        'imageName': 'one.svg',
        'componentSource': 'One.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("One input")
    }
    property var digitalLight: {
        'imageName': 'DigitalLightOff.svg',
        'componentSource': 'DigitalLight.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Digital light")
    }
    property var andGate: {
        'imageName': 'gateAnd.svg',
        'componentSource': 'AndGate.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("AND gate")
    }
    property var orGate: {
        'imageName': 'gateOr.svg',
        'componentSource': 'OrGate.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("OR gate")
    }
    property var notGate: {
        'imageName': 'gateNot.svg',
        'componentSource': 'NotGate.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("NOT gate")
    }
    property var xorGate: {
        'imageName': 'gateXor.svg',
        'componentSource': 'XorGate.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("XOR gate")
    }
    property var nandGate: {
        'imageName': 'gateNand.svg',
        'componentSource': 'NandGate.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("NAND gate")
    }
    property var norGate: {
        'imageName': 'gateNor.svg',
        'componentSource': 'NorGate.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("NOR gate")
    }
    property var switchKey: {
        'imageName': 'switchOff.svg',
        'componentSource': 'Switch.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("Switch")
    }
    property var comparator: {
        'imageName': 'comparator.svg',
        'componentSource': 'Comparator.qml',
        'width': 0.3,
        'height': 0.2,
        'toolTipText': qsTr("Comparator")
    }
    property var bcdToSevenSegment: {
        'imageName': 'BCDTo7Segment.svg',
        'componentSource': 'BCDToSevenSegment.qml',
        'width': 0.3,
        'height': 0.4,
        'toolTipText': qsTr("BCD to 7 segment")
    }
    property var sevenSegmentDisplay: {
        'imageName': 'sevenSegmentDisplay.svg',
        'componentSource': 'SevenSegment.qml',
        'width': 0.225,
        'height': 0.4,
        'toolTipText': qsTr("7 segment display")
    }
    property var signalGenerator: {
        'imageName': 'signalGenerator.svg',
        'componentSource': 'SignalGenerator.qml',
        'width': 0.3,
        'height': 0.2,
        'toolTipText': qsTr("Signal generator")
    }
    property var bcdCounter: {
        'imageName': 'bcdCounter.svg',
        'componentSource': 'BcdCounter.qml',
        'width': 0.225,
        'height': 0.4,
        'toolTipText': qsTr("BCD counter")
    }
    // List of all components
    property var componentList: [zero, one, digitalLight, andGate, orGate, 
                                 notGate, xorGate, nandGate, norGate, switchKey,
                                 comparator, bcdToSevenSegment,
                                 sevenSegmentDisplay, signalGenerator, bcdCounter]

    property var problemType: {
        'lightTheBulb': 1,
        'equation1Variable': 2,
        'equation2Variables': 3,
        'equation3Variables': 4,
        'others': 5,
    }
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [digitalLight],
            determiningComponentsIndex: [0],
            wires: [],
            playAreaComponentPositionX: [0.4],
            playAreaComponentPositionY: [0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("The digital light will glow when its terminal is connected with an input of 1."),
                qsTr("Turn the digital light on using the inputs provided.")
            ]
        },
        // level 2
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [andGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ], // from_component_index, from_terminal_no, to_component_index, to_terminal_no
            playAreaComponentPositionX: [0.4, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("The AND gate produces an output of one when both of its input terminals are of value 1."),
                qsTr("Turn the digital light on using an AND gate and the inputs provided.")
            ]
        },
        // level 3
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [orGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.4, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("The OR gate produces an output of 1 when at least one of its input terminals is of value 1."),
                qsTr("Turn the digital light on using an OR gate and the inputs provided.")
            ]
        },
        // level 4
        {
            inputComponentList: [zero],
            playAreaComponentList: [zero, one, orGate, andGate, digitalLight],
            determiningComponentsIndex: [4],
            wires: [ [0, 0, 2, 0], [2, 0, 3, 0], [3, 0, 4, 0]],
            playAreaComponentPositionX: [0.0, 0.0, 0.2, 0.4, 0.6],
            playAreaComponentPositionY: [0.0, 0.4, 0.2, 0.2, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("Note: You can draw multiple wires from the output terminal of a component.")
            ]
        },
        // level 5
        {
            inputComponentList: [zero],
            playAreaComponentList: [notGate, notGate, orGate, orGate, andGate, digitalLight],
            determiningComponentsIndex: [5],
            wires: [ [4, 0, 5, 0], [2, 0, 4, 0], [3, 0, 4, 1]],
            playAreaComponentPositionX: [0.05, 0.05, 0.3, 0.3, 0.35, 0.58],
            playAreaComponentPositionY: [0.1, 0.4, 0.05, 0.45, 0.25, 0.25],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("The NOT gate takes a single binary input and flips the value in the output.")
            ]
        },
        // level 6
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [nandGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.25, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("The NAND gate takes two binary inputs and produces one binary output."),
                qsTr("The output of the NAND gate will be zero if both of its inputs are \"1\". Else, the output will be one."),
                qsTr("For a more detailed description about the gate, select it and click on the info button."),
                qsTr("Light the bulb using the NAND gate provided.")
            ]
        },
        // level 7
        {
            inputComponentList: [zero, one, andGate, orGate, nandGate],
            playAreaComponentList: [switchKey, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2, 3],
            wires: [],
            playAreaComponentPositionX: [0.1, 0.1, 0.1, 0.5],
            playAreaComponentPositionY: [0.0, 0.25, 0.55, 0.25],
            type: [problemType.equation3Variables],
            result: function (A, B, C) {
                return A | (B & C)
            },
            introMessage: [
                qsTr("Light the bulb using the components provided such that the bulb will glow under the following two circumstances:\n" +
                     "1. The first switch is turned ON, or\n" +
                     "2. Both of the second and the third switches are turned on.")
            ]
        },
        // level 8
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [xorGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.25, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("The XOR Gate takes two binary inputs and produces one binary output."),
                qsTr("The output of the XOR gate will be one if the number of \"1\" in the input is odd. Else, the output will be zero."),
                qsTr("Light the bulb using the XOR gate provided.")
            ]
        },
        // level 9
        {
            inputComponentList: [zero, one, xorGate],
            playAreaComponentList: [switchKey, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2, 3],
            wires: [],
            playAreaComponentPositionX: [0.1, 0.1, 0.1, 0.5],
            playAreaComponentPositionY: [0.0, 0.25, 0.55, 0.25],
            type: [problemType.equation3Variables],
            result: function (A, B, C) {
                return A ^ B ^ C
            },
            introMessage: [
                qsTr("Light the bulb using the three switches such that the bulb glows when odd number of the switches are turned on.")
            ]
        },
        // level 10
        {
            inputComponentList: [one, notGate],
            playAreaComponentList: [norGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.25, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("A NOR gate takes 2 binary input and outputs 1 if both of them are 0, otherwise produces an output of 0."),
                qsTr("For a more detailed description about the gate, select it and click on the info button."),
                qsTr("Light the bulb using the NOR gate provided.")
            ]
        },
        // level 11
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.0, 0.3, 0.6],
            playAreaComponentPositionY: [0.25, 0.25, 0.25],
            type: [problemType.equation1Variable],
            introMessage: [
                qsTr("Use the gates such that the bulb will glow only when the switch is turned off and remain off when the switch is turned on.")
            ]
        },
        // level 12
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.25, 0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A & B
            },
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows only when both of the switches are turned on.")
            ]
        },
        // level 13
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.25, 0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A | B
            },
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows when either of the switches are turned on.")
            ]
        },
        // level 14
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.25, 0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return !(A | B)
            },
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows only when both of the switches are turned off.")
            ]
        },
        // level 15
        {
            inputComponentList: [norGate],
            playAreaComponentList: [one, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.0, 0.3, 0.6],
            playAreaComponentPositionY: [0.25, 0.25, 0.25],
            type: [problemType.equation1Variable],
            introMessage: [
                qsTr("Use the gates such that the bulb will glow only when the switch is turned off and remain off when the switch is turned on.")
            ]
        },
        // level 16
        {
            inputComponentList: [norGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.25, 0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A & B
            },
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows only when both of the switches are turned on.")
            ]
        },
        // level 17
        {
            inputComponentList: [norGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.25, 0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A | B
            },
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows when either of the switches are turned on.")
            ]
        },
        // level 18
        {
            inputComponentList: [norGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.25, 0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return !(A & B)
            },
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb will glow when at least one of the switches are turned off.")
            ]
        },
        // level 19
        {
            inputComponentList: [one, andGate, notGate, norGate, xorGate, nandGate, orGate],
            playAreaComponentList: [switchKey, switchKey, comparator, digitalLight],
            determiningComponentsIndex: [0, 1, 3],
            wires: [  ],
            playAreaComponentPositionX: [0.02, 0.02, 0.2, 0.6],
            playAreaComponentPositionY: [0.05, 0.5, 0.25, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A <= B
            },
            introMessage: [
                qsTr("A comparator takes two numbers (A and B) as input and produces 3 values as output. First value is 1 if A < B, second value is 1 for A = B and third value is 1 for A > B."),
                qsTr("Create a circuit using the components provided such that the bulb will glow when the value of the current flowing through the first switch is less than or equal to that of the second switch.")
            ]
        },
        // level 20
        {
            inputComponentList: [one, switchKey, nandGate, norGate, andGate, orGate, notGate],
            playAreaComponentList: [bcdToSevenSegment, sevenSegmentDisplay],
            determiningComponentsIndex: [0, 1],
            wires: [ [0, 0, 1, 0], [0, 1, 1, 1], [0, 2, 1, 2], [0, 3, 1, 3], [0, 4, 1, 4], [0, 5, 1, 5], [0, 6, 1, 6] ],
            playAreaComponentPositionX: [0.2, 0.6],
            playAreaComponentPositionY: [0.1, 0.1],
            type: [problemType.others],
            introMessage: [
                qsTr("The component in the middle is a BCD to seven segment converter."),
                qsTr("It takes 4 bits as input represented in the binary coded decimal (BCD) format and converts the BCD number into a seven segment code."),
                qsTr("The output of the converter is connected to the seven segment display, to view the value of the input provided."),
                qsTr("Display the number \"6\" in the seven segment display.")
            ]
        },
        // level 21
        {
            inputComponentList: [one, switchKey, nandGate, norGate, andGate, orGate, notGate],
            playAreaComponentList: [signalGenerator, bcdCounter, bcdToSevenSegment, sevenSegmentDisplay],
            determiningComponentsIndex: [1, 2],
            wires: [ [2, 0, 3, 0], [2, 1, 3, 1], [2, 2, 3, 2], [2, 3, 3, 3], [2, 4, 3, 4], [2, 5, 3, 5], [2, 6, 3, 6] ],
            playAreaComponentPositionX: [0.0, 0.0, 0.27, 0.6],
            playAreaComponentPositionY: [0.0, 0.3, 0.1, 0.1],
            type: [problemType.others],
            introMessage: [
                qsTr("The signal generator on the left is used to generate alternating signals between 0 and 1 in a given time period taken as input. The time period by default is 1 second, but it can be changed between 0.25 and 2s."),
                qsTr("The BCD counter placed under it is a special type of counter which can count from 0 to 9 and back to 0 on application of a clock signal."),
                qsTr("Connect the components to make sure that the count of 0 to 9 is visible in the seven segment display provided.")
            ]
        },
        // level 22
        {
            inputComponentList: [zero, notGate, orGate, andGate],
            playAreaComponentList: [one, one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [2, 3, 4],
            wires: [ ],
            playAreaComponentPositionX: [0.0, 0.0, 0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.0, 0.5, 0.15, 0.4, 0.27],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A ^ B
            },
            introMessage: [
                qsTr("Light the bulb using both the switches such that the bulb will glow only when either the first switch is on and the second switch is off or the first switch is off and the second switch is on.")
            ]
        }
    ]
}
