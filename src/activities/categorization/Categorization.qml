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
import QtQuick.Controls 1.3
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
    property bool vert: background.width < background.height

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        anchors.fill: parent
        sourceSize.width: parent.width
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
            property string mode: "easy"
            property bool instructionsChecked: (mode === "easy")
            property bool categoryNameChecked: (mode === "easy")
            property bool categoryImageChecked: (mode === "easy")
            property bool scoreChecked: (mode === "easy" || mode === "medium")
            property bool iAmReadyChecked: (mode === "expert")
            property var details
        }

        onStart: { 
            Activity.init(items, boardsUrl)
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

        ExclusiveGroup {
            id: configOptions
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            content: Component {
                Column {
                    spacing: 5
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height
                    property alias easyModeBox: easyModeBox
                    property alias mediumModeBox: mediumModeBox
                    property alias expertModeBox: expertModeBox

                    GCDialogCheckBox {
                        id: easyModeBox
                        width: 250 * ApplicationInfo.ratio
                        text: qsTr("Easy mode")
                        checked: (items.mode == "easy") ? true : false
                        exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(easyModeBox.checked) {
                                items.mode = "easy"
                                menuScreen.iAmReady.visible = false
                            }
                        }
                    }

                    GCDialogCheckBox {
                        id: mediumModeBox
                        width: 250 * ApplicationInfo.ratio
                        text: qsTr("Medium mode")
                        checked: (items.mode == "medium") ? true : false
                        exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(mediumModeBox.checked){
                                items.mode = "medium"
                                menuScreen.iAmReady.visible = false
                            }
                        }
                    }

                    GCDialogCheckBox {
                        id: expertModeBox
                        width: 250 * ApplicationInfo.ratio
                        text: qsTr("Expert mode")
                        checked: (items.mode == "expert") ? true : false
                        exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(expertModeBox.checked) {
                                items.mode = "expert"
                                menuScreen.iAmReady.visible = true
                            }
                        }
                    }
                }
            }
            onLoadData: {
                items.mode = dataToSave["mode"]
            }

            onSaveData: {
                dataToSave["data"] = Activity.categoriesToSavedProperties(dataToSave)
                dataToSave["mode"] = items.mode
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
