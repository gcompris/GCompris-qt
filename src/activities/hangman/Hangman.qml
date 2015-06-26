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
    
    
    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
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
            property alias hidden:hidden
            property string text:text
            property alias locale: background.locale
            property alias textinput: textinput
            property alias ping:ping
            property alias flower:flower
            property alias animateX: animateX
            property alias ping_animation:ping_animation
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
	      height:parent.height/6
	      width:parent.width/4
	      source:activity.dataSetUrl+"plane.svg";
	      x:0
	      transform: Rotation { origin.x: 40; origin.y: 50; origin.z:20 ;axis { x: 0; y: 1; z: 0 } }
	         
        }
        
        SequentialAnimation{
				  id:animateX
				  running:true
				  loops:Animation.Infinite
				  NumberAnimation{
				     target:heli
				     property:"x"
				     from:0; to:1000
				     duration:10000
				     easing.type: Easing.OutQuad
				  }
				  NumberAnimation{
				    target:heli
				    property:"rotation"
				    from:0; to:180
				    duration:1000
				    easing.type:Easing.OutQuad
				  }
				  NumberAnimation{
				    target:heli
				    property:"x"
				    from:1000; to:0
				    duration:10000
				    easing.type:Easing.OutQuad
				 }
				 NumberAnimation{
				      target:heli
				      property:"rotation"
				      from:180; to:360
				      duration:1000
				      easing.type:Easing.OutQuad
				 }
	}  
	
	Image{
		          id:ping
		          visible:true
		          width:parent.width/10
		          height:parent.height/5
		          x:background.width/6
		          y:6*background.height/10
		          source:activity.dataSetUrl+"pingu.svg";
			  Behavior on x {
                          PropertyAnimation {
                          id: xAnima
                          easing.type: Easing.InQuad
                          duration:  10000
                          
                }
             }
	 }
	Image{
			  
	                  id:flower
			  visible:false
			  width:ping.width/4
			  height:ping.height/6
			  source:activity.dataSetUrl+"flower.svg";
			  anchors.left:ping.left
			  y:6.5*background.height/10
			  
			  
	}
	SequentialAnimation{  id:ping_animation
			      PropertyAnimation{
				    target:flower
			            property:"visible" ;to:true
			      }
			      PropertyAnimation{
				    target:ping
				    property:"x" ;from:background.width/6; to :background.width/11
				    duration:1000
				    easing.type: Easing.InQuad
			      }
			      PropertyAnimation{
				    target:flower
			            property:"visible" ;to:"false"
			      }
			      PropertyAnimation{
				    target:ping
				    property:"x" ;from:background.width/11; to :background.width/6
				    duration:1000
				    easing.type: Easing.InQuad
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
         
         function setDefaultValues() {
                var localeUtf8 = background.locale;
                if(background.locale != "system") {
                    localeUtf8 += ".UTF-8";
                }

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
