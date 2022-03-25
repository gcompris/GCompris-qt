/* GCompris - Dataset.qml
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Gtk+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

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
        'others': 5
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
                qsTr("The digital light glows when its terminal is connected with an input of 1."),
                qsTr("Turn on the digital light using the provided inputs.") + " " +
                qsTr("To connect two terminals, click on a first terminal, then on a second terminal.")
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
                qsTr("The AND gate produces an output of 1 when both of its input terminals are of value 1."),
                qsTr("Turn on the digital light using an AND gate and the provided inputs.")
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
                qsTr("Turn on the digital light using an OR gate and the provided inputs.")
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
                qsTr("You can draw multiple wires from the output terminal of a component."),
                qsTr("Turn on the digital light using the provided components.")
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
                qsTr("The NOT gate takes a single binary input and flips the value in the output."),
                qsTr("Turn on the digital light using the provided inputs.")
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
                qsTr("The output of the NAND gate is zero if both of its inputs are 1. Else, the output is one."),
                qsTr("For a more detailed description about the NAND gate, select it and click on the info button."),
                qsTr("Light the bulb using the provided NAND gate.")
            ]
        },
        // level 7
        {
            inputComponentList: [andGate, orGate],
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
                qsTr("Create a circuit using the provided components so that the bulb glows only when both of the switches are turned on.")
            ]
        },
        // level 8
        {
            inputComponentList: [andGate, orGate],
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
                qsTr("Create a circuit using the provided components so that the bulb glows when either of the switch is turned on.")
            ]
        },
        // level 9
        {
            inputComponentList: [zero, one, andGate, orGate],
            playAreaComponentList: [switchKey, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2, 3],
            wires: [],
            playAreaComponentPositionX: [0.1, 0.1, 0.1, 0.5],
            playAreaComponentPositionY: [0.0, 0.25, 0.55, 0.25],
            type: [problemType.equation3Variables],
            result: function (A, B, C) {
                return A & B & C
            },
            introMessage: [
                qsTr("Light the bulb using the three switches so that the bulb glows only if all the three switches are turned on.")
            ]
        },
        // level 10
        {
            inputComponentList: [zero, one, andGate, orGate],
            playAreaComponentList: [switchKey, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2, 3],
            wires: [],
            playAreaComponentPositionX: [0.1, 0.1, 0.1, 0.5],
            playAreaComponentPositionY: [0.0, 0.25, 0.55, 0.25],
            type: [problemType.equation3Variables],
            result: function (A, B, C) {
                return A | B | C
            },
            introMessage: [
                qsTr("Light the bulb using the three switches so that the bulb glows if any of the switches are turned on.")
            ]
        },
        // level 11
        {
            inputComponentList: [zero, andGate, orGate, notGate],
            playAreaComponentList: [switchKey, digitalLight],
            determiningComponentsIndex: [0, 1],
            wires: [],
            playAreaComponentPositionX: [0.3, 0.6],
            playAreaComponentPositionY: [0.25, 0.25],
            type: [problemType.others],
            introMessage: [
                qsTr("Use the gates so that the bulb glows only when the switch is on.")
            ]
        },
        // level 12
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
                qsTr("The output of the XOR gate is one if the number of 1 in the input is odd. Else, the output is zero."),
                qsTr("Light the bulb using the provided XOR gate.")
            ]
        },
        // level 13
        {
            inputComponentList: [zero, one, xorGate],
            playAreaComponentList: [switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2],
            wires: [],
            playAreaComponentPositionX: [0.2, 0.2, 0.6],
            playAreaComponentPositionY: [0.2, 0.35, 0.25],
            type: [problemType.equation2Variables],
            result: function (A, B) {
                return A ^ B
            },
            introMessage: [
                qsTr("Light the bulb using the two switches so that the bulb glows when one of the switch is on and the other is off.")
            ]
        },
        // level 14
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
                qsTr("Light the bulb using the three switches so that the bulb glows when odd number of the switches are turned on.")
            ]
        },
        // level 15
        {
            inputComponentList: [one, notGate],
            playAreaComponentList: [norGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.25, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            type: [problemType.lightTheBulb],
            introMessage: [
                qsTr("A NOR gate takes 2 binary inputs and outputs 1 if both of them are 0, otherwise produces an output of 0."),
                qsTr("For a more detailed description about the NOR gate, select it and click on the info button."),
                qsTr("Light the bulb using the provided NOR gate.")
            ]
        },
        // level 16
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.0, 0.3, 0.6],
            playAreaComponentPositionY: [0.25, 0.25, 0.25],
            type: [problemType.equation1Variable],
            introMessage: [
                qsTr("Use the gates so that the bulb glows only when the switch is turned off and doesn't glow when the switch is turned on.")
            ]
        },
        // level 17
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
                qsTr("Create a circuit using the provided components so that the bulb glows only when both of the switches are turned on.")
            ]
        },
        // level 18
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
                qsTr("Create a circuit using the provided components so that the bulb glows when either of the switch is turned on.")
            ]
        },
        // level 19
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
                qsTr("Create a circuit using the provided components so that the bulb glows only when both of the switches are turned off.")
            ]
        },
        // level 20
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
                qsTr("Light the bulb using the provided components so that the bulb glows if the first switch is turned ON, or if both the second and the third switches are turned on.")
            ]
        },
        // level 21
        {
            inputComponentList: [norGate],
            playAreaComponentList: [one, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.0, 0.3, 0.6],
            playAreaComponentPositionY: [0.25, 0.25, 0.25],
            type: [problemType.equation1Variable],
            introMessage: [
                qsTr("Use the gates so that the bulb glows when the switch is turned off and doesn't glow when the switch is turned on.")
            ]
        },
        // level 22
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
                qsTr("Create a circuit using the provided components so that the bulb glows only when both of the switches are turned on.")
            ]
        },
        // level 23
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
                qsTr("Create a circuit using the provided components so that the bulb glows when either of the switches are turned on.")
            ]
        },
        // level 24
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
                qsTr("Create a circuit using the provided components so that the bulb glows when at least one of the switches is turned off.")
            ]
        },
        // level 25
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
                qsTr("A comparator takes two numbers (A and B) as input and produces 3 values as output. The first value is 1 if A < B, the second value is 1 if A = B and the third value is 1 if A > B."),
                qsTr("Create a circuit using the provided components so that the bulb glows when the output of the first switch is less than or equal to the output of the second switch.")
            ]
        },
        // level 26
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
                qsTr("Display the number 6 in the seven segment display.")
            ]
        },
        // level 27
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
                qsTr("Connect the components to make sure that the count of 0 to 9 is visible in the provided seven segment display.")
            ]
        },
        // level 28
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
                qsTr("Light the bulb using both the switches so that the bulb glows only when either the first switch is on and the second switch is off, or when the first switch is off and the second switch is on.")
            ]
        }
    ]
}
