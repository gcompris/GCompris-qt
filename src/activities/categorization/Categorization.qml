/* GCompris - categorization.qml
*
* Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
*
* Authors:
*   Divyam Madaan <divyam3897@gmail.com> 
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
import "categorization.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core
import "."

ActivityBase {
    id: activity
    
    onStart: focus = true
    onStop: {}
    
    property string boardsUrl: "qrc:/gcompris/src/activities/categorization/resource/"
    property string imagesUrl: "qrc:/gcompris/src/activities/categorization/resource/images"
    property bool vert: background.width < background.height
    
    pageComponent: Image {
        id: background
        source: activity.boardsUrl +"imageid-bg.svg"
        anchors.fill: parent
        sourceSize.width:parent.width
        signal start
        signal stop
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        
        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias categoryReview: categoryReview
            property alias menuScreen: menuScreen
            property alias menuModel: menuScreen.menuModel
            property alias dialogActivityConfig: dialogActivityConfig
            property bool easyMode:true
            property bool mediumMode: false
            property bool expertMode: false
            property bool instructionsChecked: true
            property bool categoryNameChecked: true
            property bool categoryImageChecked: true
            property bool scoreChecked: true
            property var details
        }
        
        onStart: { 
            Activity.init(items,boardsUrl)
            dialogActivityConfig.getInitialConfiguration()
            Activity.start()
        }
        
        onStop: {
            dialogActivityConfig.saveDatainConfiguration() 
        }
        
        MenuScreen {
            id: menuScreen
        }
        
        CategoryReview {
            id: categoryReview
        }
        
        DialogActivityConfig {
            id: dialogActivityConfig
            content:Component{
                Flow {
                    spacing: 5
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height
                    
                    GCDialogCheckBox {
                        id: easyModeBox
                        width: 250 * ApplicationInfo.ratio
                        text: qsTr("Easy mode")
                        checked: items.easyMode
                        onCheckedChanged: {
                            print("Easy Mode: ",checked)
                            if(items.expertMode == true){
                                items.expertMode = false
                                expertModeBox.checked = false
                                items.instructionsChecked = true
                                items.categoryImageChecked = true
                                items.scoreChecked = true
                            }
                            else if(items.mediumMode == true){
                                items.mediumMode = false
                                mediumModeBox.checked = false
                                items.scoreChecked = true
                                items.instructionsChecked = true
                                items.categoryImageChecked = true
                            }
                            items.easyMode = checked
                        }
                    }
                    
                    GCDialogCheckBox {
                        id: mediumModeBox
                        width: 250 * ApplicationInfo.ratio
                        text: qsTr("Medium mode")
                        checked: items.mediumMode
                        onCheckedChanged: {
                            print("Medium Mode: ",checked)
                            if(items.easyMode == true){
                                items.easyMode = false
                                easyModeBox.checked = false
                                items.scoreChecked = true
                                items.instructionsChecked = false
                                items.categoryImageChecked = false
                            }
                            else if(items.expertMode == true){
                                items.expertMode = false
                                expertModeBox.checked = false
                                items.instructionsChecked = false
                                items.categoryImageChecked = false
                                items.scoreChecked = true
                            }
                            items.mediumMode = checked
                        }
                    }
                    
                    GCDialogCheckBox {
                        id: expertModeBox
                        width: 250 * ApplicationInfo.ratio
                        text: qsTr("Expert mode")
                        checked: items.expertMode
                        onCheckedChanged: {
                            print("Score Diabled: ",checked)
                            if(items.easyMode == true){
                                items.easyMode = false
                                easyModeBox.checked = false
                                items.instructionsChecked = false
                                items.categoryImageChecked = false
                                items.scoreChecked = false
                            }
                            else if(items.mediumMode == true){
                                items.mediumMode = false
                                mediumModeBox.checked = false
                                items.scoreChecked = false
                            }
                            items.expertMode = checked
                        }
                    }
                }
            }  
            onLoadData: {
                items.easyMode = dataToSave["easyMode"] === "true" ? true : false
                items.mediumMode = dataToSave["mediumMode"] === "true" ? true : false
                items.expertMode = dataToSave["expertMode"] === "true" ? true : false
                items.scoreChecked = dataToSave["score"] === "true" ? true : false
                items.instructionsChecked = dataToSave["instructions"] === "true" ? true : false
                items.categoryImageChecked = dataToSave["image"] === "true" ? true : false
                
            
            }
            onSaveData: {
                dataToSave["data"] = Activity.categoriesToSavedProperties(dataToSave)
                dataToSave["easyMode"] = ""+items.easyMode
                dataToSave["mediumMode"] = ""+items.mediumMode
                dataToSave["expertMode"] = ""+items.expertMode
                dataToSave["score"] = ""+items.scoreChecked
                dataToSave["instructions"] = ""+items.instructionsChecked
                dataToSave["image"] = ""+items.categoryImageChecked
            }
            onClose: home()
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        Bar {
            id: bar
            content: menuScreen.started ? withConfig : withoutConfig
            property BarEnumContent withConfig: BarEnumContent { value: help | home | config }
            property BarEnumContent withoutConfig: BarEnumContent { value: help | home | level }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: {
                if(items.menuScreen.started)
                    activity.home()
                else if(items.categoryReview.started)
                    Activity.launchMenuScreen()
            }
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
        }
        
        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}

