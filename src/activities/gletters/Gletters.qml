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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
import QtQuick.Controls 1.1
import GCompris 1.0

import "../../core"
import "gletters.js" as Activity

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/gletters/resource/"
    
    property bool uppercaseOnly: false;  // FIXME: this should go in activity settings
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
    
    pageComponent: Image {
        id: background
        source: activity.dataSetUrl + "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

        signal start
        signal stop

        property string locale: "$LOCALE"
        
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
            property GCAudio audioEffects: activity.audioEffects
            property alias locale: background.locale
        }

        onStart: {
            Activity.start(items, uppercaseOnly, mode);
            if (!ApplicationInfo.isMobile)
                textinput.forceActiveFocus();
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

        DialogActivityConfig {
            id: dialogActivityConfig
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            ComboBox {
                                id: localeBox
                                style: GCComboBoxStyle {}
                                model: langs.languages
                                width: 250 * ApplicationInfo.ratio
                            }
                            GCText {
                                text: qsTr("Select your locale")
                                fontSize: mediumSize
                                wrapMode: Text.WordWrap
                            }
                        }
/* TODO handle this:
                        GCDialogCheckBox {
                            id: uppercaseBox
                            width: 250 * ApplicationInfo.ratio
                            text: qsTr("Uppercase only mode")
                            checked: true
                            onCheckedChanged: {
                                print("uppercase changed")
                            }
                        }
*/
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["locale"]) {
                    background.locale = dataToSave["locale"];
                }
            }
            onSaveData: {
                var oldLocale = background.locale;
                var newLocale = dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                dataToSave = {"locale": newLocale}
                background.locale = newLocale;

                // Restart the activity with new informations
                if(oldLocale !== newLocale) {
                    background.stop();
                    background.start();
                }
            }


            function setDefaultValues() {
                var localeUtf8 = background.locale + ".UTF-8";
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                        dialogActivityConfig.loader.item.localeBox.currentIndex = i;
                        break;
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
            content: BarEnumContent { value: help | home | level | config }
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
