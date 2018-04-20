/* GCompris - Traffic.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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

import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "traffic.js" as Activity

ActivityBase {
    id: activity
    
    onStart: focus = true
    onStop: {}
    
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/traffic/resource/traffic_bg.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        property string mode: "IMAGE" // allow to choose between "COLOR" and "IMAGE"
                                  // mode, candidate for a config dialog
        
        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias jamBox: jamBox
            property alias jamGrid: jamGrid
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }
        
        Image {
            id: jamBox
            source: "qrc:/gcompris/src/activities/traffic/resource/traffic_box.svg"

            anchors.centerIn: parent
            sourceSize.width: Math.min(background.width * 0.85,
                                       background.height * 0.85)
            fillMode: Image.PreserveAspectFit
            property double scaleFactor: background.width / background.sourceSize.width

            Grid {
                id: jamGrid
                anchors.centerIn: parent
                width: parent.width - 86 * jamBox.scaleFactor * ApplicationInfo.ratio
                height: parent.height - 86 * jamBox.scaleFactor * ApplicationInfo.ratio
                columns: 6
                rows: 6
                spacing: 0
                // Add an alias to mode so it can be used on Car items
                property alias mode: background.mode
                Repeater {
                    id: gridRepeater
                    model: jamGrid.columns * jamGrid.rows
                    
                    delegate: Rectangle {
                        id: gridDelegate
                        height: jamGrid.height/ jamGrid.rows
                        width: height
                        border.width: 1
                        border.color: "white"
                        color: "#444444"
                    }
                }
            }
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias modeBox: modeBox

                    property var availableModes: [
                    { "text": qsTr("Colors"), "value": "COLOR" },
                    { "text": qsTr("Images"), "value": "IMAGE" }
                    ]

                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: modeBox
                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select your mode")
                        }
                    }
                }
            }
            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["mode"]) {
                    mode = dataToSave["mode"];
                    Activity.mode = dataToSave["mode"];
                }
            }

            onSaveData: {
                mode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value;
                dataToSave = {"mode": mode}
                Activity.mode = mode;
            }

            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === mode) {
                        dialogActivityConfig.configItem.modeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload | config }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
            onConfigClicked: {
                dialogActivityConfig.active = true
                // Set default values
                dialogActivityConfig.setDefaultValues();
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
        
        Score {
            id: score

            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
        }
        
    }
}
