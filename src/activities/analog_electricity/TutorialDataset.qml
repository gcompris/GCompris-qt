/* GCompris - Dataset.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Gtk+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (DigitalElectricity)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property var battery: {
        'imageName': 'battery.svg',
        'componentSource': 'Battery.qml',
        'width': 0.06,
        'height': 0.15,
        'toolTipText': qsTr("Battery"),
        'type': "v"
    }

    property var bulb: {
        'imageName': 'bulb.svg',
        'componentSource': 'Bulb.qml',
        'width': 0.15,
        'height': 0.15,
        'toolTipText': qsTr("Bulb"),
        'type': "r"
    }

    property var switch1: {
        'imageName': 'switch_off.svg',
        'componentSource': 'Switch1.qml',
        'width': 0.15,
        'height': 0.06,
        'toolTipText': qsTr("Switch"),
        'type': "r"
    }

    property var switch2: {
        'imageName': 'switch2_off.svg',
        'componentSource': 'Switch2.qml',
        'width': 0.15,
        'height': 0.09,
        'toolTipText': qsTr("3 points switch"),
        'type': "r"
    }

    property var connection: {
        'imageName': 'connection_icon.svg',
        'componentSource': 'Connection.qml',
        'width': 0.15,
        'height': 0.06,
        'toolTipText': qsTr("Simple connector")
    }

    property var rheostat: {
        'imageName': 'rheostat_icon.svg',
        'componentSource': 'Rheostat.qml',
        'width': 0.09,
        'height': 0.15,
        'toolTipText': qsTr("Rheostat"),
        'type': "r"
    }

    property var resistor: {
        'imageName': 'resistor.svg',
        'componentSource': 'Resistor.qml',
        'width': 0.15,
        'height': 0.06,
        'toolTipText': qsTr("Resistor"),
        'type': "r"
    }

    property var redLed: {
        'imageName': 'red_led_off.svg',
        'componentSource': 'RedLed.qml',
        'width': 0.15,
        'height': 0.09,
        'toolTipText': qsTr("Red LED"),
        'type': "d"
    }

    // List of all components
    property var componentList: [battery, bulb, switch1, switch2, connection, rheostat, resistor, redLed]

    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            inputComponentList: [],
            playAreaComponentList: [bulb, battery],
            determiningComponentsIndex: [0],
            answerKey: ["bulbGlows"],
            wires: [ [0, 1, 1, 0] ], // from component_index, from terminalNumber, to component_index, to terminalNumber
            playAreaComponentPositionX: [0.3, 0.6],
            playAreaComponentPositionY: [0.1, 0.3],
            introMessage: [
                qsTr("A bulb glows when current travels through it. If there is a gap in the path, the current cannot travel and the electrical devices will not work."),
                qsTr("The travelling path is called a circuit. Electrical devices can work only in a closed circuit. Wires can be used to connect devices and create the circuit."),
                qsTr("For a detailed description of battery and bulb, click on those and then click on the info button."),
                qsTr("Turn on the bulb using the provided battery. To connect two terminals, click on a terminal, then on a second terminal.")
            ]
        },
        // level 2
        {
            inputComponentList: [],
            playAreaComponentList: [battery, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: [],
            wires: [],
            playAreaComponentPositionX: [0.3, 0.5],
            playAreaComponentPositionY: [0.3, 0.3],
            introMessage: [
                qsTr("When connecting two terminals which are not supposed to be connected, it creates a short circuit (also called short) in the electrical circuit."),
                qsTr("If both terminals of some batteries are directly connected together or they are shorted, then those batteries create a voltage source loop and they cannot act as a voltage source for the circuit."),
                qsTr("For example, if two terminals of one battery are directly connected together, it creates a voltage source loop.") + ("<br/><br/>") + qsTr("Or, if two batteries are forming a closed circuit together, it creates a voltage source loop."),
                qsTr("Create a voltage source loop with the provided batteries. Then click on the warning box to make it disappear and click on the OK button.")
            ]
        },
        // level 3
        {
            inputComponentList: [],
            playAreaComponentList: [bulb, battery, battery],
            determiningComponentsIndex: [0, 1, 2],
            answerKey: ["bulbBroken", "batteryIn", "batteryIn"],
            wires: [],
            playAreaComponentPositionX: [0.6, 0.3, 0.3],
            playAreaComponentPositionY: [0.3, 0.55, 0.1],
            introMessage: [
                qsTr("Too much current in an electrical circuit can damage the connected devices."),
                qsTr("To repair a broken bulb in this activity, click on it after disconnecting it from the circuit. Don't forget to disable the delete button after removing the connected wires."),
                qsTr("Break the bulb by connecting it with the two batteries.")
            ]
        },
        // level 4
        {
            inputComponentList: [battery],
            playAreaComponentList: [switch1, bulb],
            determiningComponentsIndex: [0, 1],
            answerKey: ["switch1In", "bulbGlows"],
            wires: [],
            playAreaComponentPositionX: [0.7, 0.4],
            playAreaComponentPositionY: [0.3, 0.35],
            introMessage: [
                qsTr("A switch can connect or disconnect the current travelling path or a circuit."),
                qsTr("You can click on the switch to open and close it."),
                qsTr("Create a circuit using the provided components so that the bulb glows only when the switch is on.")
            ]
        },
        // level 5
        {
            inputComponentList: [connection],
            playAreaComponentList: [switch1, bulb, bulb, battery],
            determiningComponentsIndex: [0, 1, 2],
            answerKey: ["switch1In", "bulbGlows", "bulbGlows"],
            wires: [],
            playAreaComponentPositionX: [0.4, 0.7, 0.4, 0.2],
            playAreaComponentPositionY: [0.55, 0.3, 0.05, 0.3],
            introMessage: [
                qsTr("A simple connector can be used to connect several wires in an electrical circuit."),
                qsTr("Create a circuit so that one bulb should be always lit and the other should be lit only when the switch is on.")
            ]
        },
        // level 6
        {
            inputComponentList: [battery, switch1, connection],
            playAreaComponentList: [bulb],
            determiningComponentsIndex: [0],
            answerKey: ["bulbGlows"],
            wires: [],
            playAreaComponentPositionX: [0.4],
            playAreaComponentPositionY: [0.1],
            introMessage: [
                qsTr("Electric current intensity or simply current is a flow of electric charge. One can imagine like a flow of electrons."),
                qsTr("The conventional symbol for current is I. The unit of current is ampere under the International System of Units, which is denoted as A."),
                qsTr("Voltage or electric potential difference is what makes a current in a circuit. It is like a \"push\" or \"pull\" for electric charge."),
                qsTr("The conventional symbol for voltage is V. The unit of measure of voltage is volt under the International System of Units, which is denoted as V."),
                qsTr("Light the bulb and observe the displayed values.")
            ]
        },
        // level 7
        {
            inputComponentList: [connection],
            playAreaComponentList: [bulb, resistor, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: ["bulbGlowsLess", "resistorIn"],
            wires: [],
            playAreaComponentPositionX: [0.3, 0.6, 0.4],
            playAreaComponentPositionY: [0.4, 0.3, 0.05],
            introMessage: [
                qsTr("A resistor restricts the flow of current in an electrical circuit. The restriction of current is called resistance."),
                qsTr("The conventional symbol for resistance is R. The unit of measure of resistance is ohm under the International System of Units, which is denoted as Ω."),
                qsTr("Light the bulb so that the bulb glows with 5V using the provided components.")
            ]
        },
        // level 8
        {
            inputComponentList: [],
            playAreaComponentList: [rheostat, bulb, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: ["rheostatIn", "bulbIn"],
            wires: [],
            playAreaComponentPositionX: [0.3, 0.6, 0.4],
            playAreaComponentPositionY: [0.4, 0.3, 0.05],
            introMessage: [
                qsTr("A rheostat is used to vary resistance in an electrical circuit."),
                qsTr("You can change the rheostat value by dragging its slider."),
                qsTr("Connect the bulb to the appropriate terminals of the rheostat so that the light intensity of the bulb can be changed while dragging the slider.")
            ]
        },
        // level 9
        {
            inputComponentList: [connection],
            playAreaComponentList: [rheostat, bulb, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: ["rheostatConst", "bulbGlowsLess"],
            wires: [],
            playAreaComponentPositionX: [0.3, 0.6, 0.4],
            playAreaComponentPositionY: [0.4, 0.3, 0.05],
            introMessage: [
                qsTr("A rheostat can act as a simple resistor if the terminals of the extremities are connected in a circuit."),
                qsTr("Connect the bulb to the appropriate terminals of the rheostat so that the slider cannot change the light intensity of the bulb.")
            ]
        },
        // level 10
        {
            inputComponentList: [connection],
            playAreaComponentList: [rheostat, bulb, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: ["rheostatIn", "bulbGlows"],
            wires: [],
            playAreaComponentPositionX: [0.3, 0.6, 0.4],
            playAreaComponentPositionY: [0.4, 0.3, 0.05],
            introMessage: [
                qsTr("Connect the bulb to the appropriate terminals of the rheostat and set the slider so that the voltage drop in the bulb should be 10V. Note that the bulb intensity should vary while dragging the slider.")
            ]
        },
        // level 11
        {
            inputComponentList: [connection],
            playAreaComponentList: [redLed, battery],
            determiningComponentsIndex: [0],
            answerKey: ["redLedBroken"],
            wires: [],
            playAreaComponentPositionX: [0.6, 0.3],
            playAreaComponentPositionY: [0.2, 0.25],
            introMessage: [
                qsTr(" A red LED converts electrical energy into red light energy under particular conditions."),
                qsTr("The first condition is current flow in it should be in the direction of the arrow. That means the positive terminal of the battery connected to the terminal at the tail of the arrow shown, and the negative terminal to the head side. This condition is called forward bias."),
                qsTr("Electrical energy more than a certain limit can break an LED. In this activity, you can click on the broken red LED after disconnecting from the circuit to repair it."),
                qsTr("Connect the provided red LED to the battery in forward bias. Don't worry about the broken LED for now.")
            ]
        },
        // level 12
        {
            inputComponentList: [connection],
            playAreaComponentList: [redLed, resistor, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: ["redLedGlows", "resistorIn"],
            wires: [],
            playAreaComponentPositionX: [0.4, 0.4, 0.25],
            playAreaComponentPositionY: [0.05, 0.4, 0.15],
            introMessage: [
                qsTr("The battery is providing too much energy to the LED."),
                qsTr("One can limit the electrical energy by restricting the current flow in a circuit. That means using a resistor."),
                qsTr("Light the red LED using the provided components.")
            ]
        },
        // level 13
        {
            inputComponentList: [connection],
            playAreaComponentList: [bulb, bulb, battery],
            determiningComponentsIndex: [0, 1],
            answerKey: ["bulbGlows", "bulbGlows"],
            wires: [],
            playAreaComponentPositionX: [0.2, 0.6, 0.45],
            playAreaComponentPositionY: [0.15, 0.15, 0.4],
            introMessage: [
                qsTr("Create a circuit so that the voltage drop in both bulbs are equal to the voltage source (battery).")
            ]
        }
    ]
}
