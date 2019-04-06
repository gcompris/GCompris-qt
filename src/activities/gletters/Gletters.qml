/* GCompris - gletters.qml
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "gletters.js" as Activity

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/gletters/resource/"
    /* no need to display the configuration button for smallnumbers */
    property bool configurationButtonVisible: true

    property bool uppercaseOnly: false

    property string activityName: "gletters"

    /* mode of the activity, "letter" (gletters) or "word" (wordsgame):*/
    property string mode: "letter"

    // Override if you want to replace texts by your image
    function getImage(key) {
        return ""
    }

    // Override if you want to replace texts by the domino
    function getDominoValues(key) {
        return []
    }

    onStart: focus = true
    onStop: {}

    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

    pageComponent: Image {
        id: background
        source: activity.dataSetUrl + "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: parent.height

        signal start
        signal stop

        // system locale by default
        property string locale: "system"
        
        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property Item ourActivity: activity
            property GCAudio audioVoices: activity.audioVoices
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias keyboard: keyboard
            property alias wordDropTimer: wordDropTimer
            property GCSfx audioEffects: activity.audioEffects
            property alias locale: background.locale
            property alias textinput: textinput
        }

        onStart: {
            Activity.start(items, uppercaseOnly, mode);
            Activity.focusTextInput()
        }
        onStop: { Activity.stop() }

        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            anchors.centerIn: background
            enabled: !ApplicationInfo.isMobile
            focus: true
            visible: false

            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
        }

        //created to retrieve available menu modes for domino configurations
        Domino {
            id: invisibleDomino
            visible: false
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    property alias dominoModeBox: dominoModeBox
                    property alias uppercaseBox: uppercaseBox
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }
                    property var availableModes: invisibleDomino.menuModes

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width
                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            GCComboBox {
                                id: localeBox
                                visible: (activity.activityName == "gletters")
                                model: langs.languages
                                background: dialogActivityConfig
                                label: qsTr("Select your locale")
                            }
                            GCComboBox {
                                id: dominoModeBox
                                visible: (activity.activityName == "smallnumbers2")
                                model: availableModes
                                background: dialogActivityConfig
                                label: qsTr("Select Domino mode")
                            }
                        }
                        GCDialogCheckBox {
                            id: uppercaseBox
                            visible: (activity.activityName == "gletters")
                            width: dialogActivityConfig.width
                            text: qsTr("Uppercase only mode")
                            checked: activity.uppercaseOnly
                        }
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if (activity.activityName == "gletters") {
                    if(dataToSave && dataToSave["locale"]) {
                        background.locale = dataToSave["locale"];
                        activity.uppercaseOnly = dataToSave["uppercaseMode"] === "true" ? true : false;
                    }
                } else if (activity.activityName == "smallnumbers2") {
                    if(dataToSave && dataToSave["mode"]) {
                        activity.dominoMode = dataToSave["mode"];
                    }
                }
            }
            onSaveData: {
                var configHasChanged = false
                if (activity.activityName == "gletters") {
                    var oldLocale = background.locale;
                    var newLocale = dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                    // Remove .UTF-8
                    if(newLocale.indexOf('.') != -1) {
                        newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                    }

                    var oldUppercaseMode = activity.uppercaseOnly
                    activity.uppercaseOnly = dialogActivityConfig.configItem.uppercaseBox.checked
                    dataToSave = {"locale": newLocale, "uppercaseMode": ""+activity.uppercaseOnly}

                    background.locale = newLocale;
                    if(oldLocale !== newLocale || oldUppercaseMode !== activity.uppercaseOnly) {
                        configHasChanged = true;
                    }
                } else if (activity.activityName == "smallnumbers2") {
                    var newMode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.dominoModeBox.currentIndex].value;
                    if (newMode !== activity.dominoMode) {
                        activity.dominoMode = newMode;
                        dataToSave = {"mode": activity.dominoMode};
                        configHasChanged = true;
                    }
                }
                
                // Restart the activity with new information
                if(configHasChanged) {
                    background.stop();
                    background.start();
                }
            }

            function setDefaultValues() {
                if (activity.activityName == "gletters") {
                    var localeUtf8 = background.locale;
                    if(background.locale != "system") {
                        localeUtf8 += ".UTF-8";
                    }

                    for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                        if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                            dialogActivityConfig.configItem.localeBox.currentIndex = i;
                            break;
                        }
                    }
                } else if (activity.activityName == "smallnumbers2") {
                    for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i++) {
                        if(dialogActivityConfig.configItem.availableModes[i].value === activity.dominoMode) {
                            dialogActivityConfig.configItem.dominoModeBox.currentIndex = i;
                            break;
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: configurationButtonVisible ? (help | home | level | config) : (help | home | level)}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        
        Score {
            id: score
            anchors.top: undefined
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: keyboard.top
        }
        
        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            onKeypress: Activity.processKeyPress(text)
            onError: console.log("VirtualKeyboard error: " + msg);
        }
        
        Wordlist {
            id: wordlist
            defaultFilename: activity.dataSetUrl + "default-en.json"
            // To switch between locales: xx_XX stored in configuration and
            // possibly correct xx if available (ie fr_FR for french but dataset is fr.)
            useDefault: false
            filename: ""

            onError: console.log("Gletters: Wordlist error: " + msg);
        }
        
        Timer {
            id: wordDropTimer
            repeat: false
            onTriggered: Activity.dropWord();
        }

    }

}
