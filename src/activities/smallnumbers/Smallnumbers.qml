/* GCompris - smallnumbers.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "../gletters"

Gletters {
    id: activity

    mode: "letter"
    dataSetUrl: "qrc:/gcompris/src/activities/smallnumbers/resource/"
    configurationButtonVisible: true
    configurationDialogSelect: false
    QtObject {
            id: items
            property int mode: 1
    }

    DialogActivityConfig {
        id: diceDialogActivityConfig
        currentActivity: activity
        content: Component {
            Item {
                property alias modeBox: modeBox

                property var availableModes: [
                    { "text": qsTr("Numbers"), "value": 1 },
                    { "text": qsTr("Romans"), "value": 2 },
                    { "text": qsTr("Dots"), "value": 3 }
                ]

                Flow {
                    id: flow
                    spacing: 5
                    width: diceDialogActivityConfig.width
                    GCComboBox {
                        id: modeBox
                        model: availableModes
                        background: diceDialogActivityConfig
                        label: qsTr("Select Dice Type")
                    }
                }
            }
        }

        onClose: home()

        onLoadData: {
            if(dataToSave && dataToSave["mode"]) {
                items.mode = dataToSave["mode"];
            }
        }
        onSaveData: {
            var newMode = diceDialogActivityConfig.configItem.availableModes[diceDialogActivityConfig.configItem.modeBox.currentIndex].value;
            if (newMode !== items.mode) {
                items.mode = newMode;
                dataToSave = {"mode": items.mode};
            }
            activity.initLevel();
        }
        function setDefaultValues() {
            for(var i = 0 ; i < diceDialogActivityConfig.configItem.availableModes.length ; i++) {
                if(diceDialogActivityConfig.configItem.availableModes[i].value === items.mode) {
                    diceDialogActivityConfig.configItem.modeBox.currentIndex = i;
                    break;
                }
            }
        }
    }

    function getImage(key) {
        return dataSetUrl + "dice" + key + ".svg"
    }

    function getMode() {
        return items.mode;
    }
}
