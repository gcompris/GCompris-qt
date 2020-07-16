/* GCompris - Dataset.qml
 *
 * Copyright (C) 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Gtk+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (DigitalElectricity)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
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
    property var battery: {
        'imageName': 'battery.png',
        'componentSource': 'Battery.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Battery"),
        'type': "v"
    }

    property var bulb: {
        'imageName': 'bulb1.png',
        'componentSource': 'Bulb.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Bulb"),
        'type': "r"
    }

    property var switch1: {
        'imageName': 'switch_icon.png',
        'componentSource': 'Switch1.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Switch"),
        'type': "r"
    }

    property var switch2: {
        'imageName': 'switch2_icon.png',
        'componentSource': 'Switch2.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("3 points switch"),
        'type': "r"
    }

    property var connection: {
        'imageName': 'connection.svg',
        'componentSource': 'Connection.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Simple connector")
    }

    property var rheostat: {
        'imageName': 'resistor_track_icon.png',
        'componentSource': 'Rheostat.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Rheostat"),
        'type': "r"
    }

    property var resistor: {
        'imageName': 'resistor.png',
        'componentSource': 'Resistor.qml',
        'width': 0.2,
        'height': 0.2,
        'toolTipText': qsTr("Resistor"),
        'type': "r"
    }

    property var redLed: {
        'imageName': 'red_led_icon.png',
        'componentSource': 'RedLed.qml',
        'width': 0.2,
        'height': 0.2,
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
