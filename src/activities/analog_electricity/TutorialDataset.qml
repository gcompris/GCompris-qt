/* GCompris - Dataset.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Gtk+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (DigitalElectricity)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.6

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
            inputComponentList: [battery, bulb, switch1]
        },
        // level 2
        {
            inputComponentList: [battery, bulb, rheostat, switch1, switch2, connection]
        },
        // level 3
        {
            inputComponentList: [battery, bulb, rheostat, resistor, switch1, connection, redLed]
        }
    ]
}
