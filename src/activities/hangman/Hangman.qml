/* GCompris - hangman.qml
 *
 * Copyright (C) 2015 Rajdeep Kaur <rajdeep51994@gmail.com>
 *
 * Authors:
 *   <BRUNO COUDOIN> (GTK+ version)
 *   RAJDEEP KAUR<rajdeep51994@gmail.com> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "hangman.js" as Activity

ActivityBase {
    id: activity
    property string dataSetUrl: "qrc:/gcompris/src/activities/hangman/resource/"
    
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
        source:activity.dataSetUrl+"background.svg"
	fillMode: Image.PreserveAspectCrop
	sourceSize.width: parent.width
        anchors.fill: parent
        signal start
        signal stop

        // system locale by default
        property string locale: "system"
        
        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
	    activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property Item ourActivity: activity
            property GCAudio audioVoices: activity.audioVoices
            property alias bar: bar
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias keyboard:keyboard
            property alias heli:heli
            property alias man1:man1
            property alias man2:man2
            property alias man3:man3
            property alias hidden:hidden
            property string text:text
            property alias locale: background.locale
            property alias textinput: textinput
        }

        onStart: { Activity.start(items);
		    Activity.focusTextInput();
	         }	 
        onStop: { Activity.stop() }

        GCText {
	    id:hidden
            anchors.centerIn: parent
            fontSize: largeSize
            color:"#FF9933"
	    font.family: "Helvetica"
            font.pointSize:55
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.verticalCenter:parent.verticalCenter
        }
        
        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            enabled: !ApplicationInfo.isMobile
            focus: true
            visible:false
            Keys.onPressed: {
	        if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }      
	    }
            

        }
        
        Image{
	      id:heli
	      sourceSize.height: 90 * ApplicationInfo.ratio
	      source:activity.dataSetUrl+"plane.svg";
	      Behavior on x {
              PropertyAnimation {
                          id: xAnim
                          easing.type: Easing.OutQuad
                          duration:  10000
                         
                }
             }
             Behavior on y {
                            PropertyAnimation {easing.type: Easing.OutQuad; duration:  5000}
             }
             
             transform: Rotation {
                                  id: helicoRotation;
                                  origin.x: heli.width / 2;
                                  origin.y: heli.height / 2;
                                  axis { x: 0; y: 0; z: 1 }
                                  Behavior on angle {
                                                  animation: rotAnim
                                  }
             }

             states: [
                     State {
                             name: "horizontal"
                             PropertyChanges {
                             target: helicoRotation
                             angle: 0
                       }
                   },
                   State {
                             name: "advancing"
                             PropertyChanges {
                             target: helicoRotation
                             angle: 45
                         }
                   }
               ]

               RotationAnimation {
                id: rotAnim
                direction: heli.state == "horizontal" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running && heli.state == "advancing")
                                      heli.state = "horizontal"
               }
             
             
             Image{  id:man1
		     width:heli.width/7
		     height:heli.height/4
		     x:heli.width/3
		     source:activity.dataSetUrl+"aadmi.svg";
		     anchors.top:heli.bottom
		     anchors.left:heli.left
		    		     
              }
	      Image{ id:man2
		     width:heli.width/7
		     height:heli.height/4
		     source:activity.dataSetUrl+"aadmi.svg";
		     anchors.top:heli.bottom
		     anchors.left:man1.right
		     
	      }
	      Image{ id:man3
		     width:heli.width/7
		     height:heli.height/4
		     source:activity.dataSetUrl+"aadmi.svg";
		     anchors.top:heli.bottom
		     anchors.left:man2.right
		   
	      }
	      
	      MouseArea {
                       id: mousearea
                       anchors.fill:parent
                       
              }
              
         
	}
	
	DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
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
                            GCComboBox {
                                id: localeBox
                                model: langs.languages
                                background: dialogActivityConfig
                                width: 250 * ApplicationInfo.ratio
                                label: qsTr("Select your locale")
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
                if(newLocale.indexOf('.') != -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave = {"locale": newLocale}

                background.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    background.stop();
                    background.start();
                }
         }

	 
      }
       DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
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
        
         VirtualKeyboard {
            id: keyboard
            
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            
            onKeypress: Activity.processKeyPress(text);
            
	    onError: console.log("VirtualKeyboard error: " + msg);
        }
        
         Wordlist {
            id: wordlist
            defaultFilename: activity.dataSetUrl + "default-en.json"
            filename: ""
           
            onError: console.log("Hangman: Wordlist error: " + msg);
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
