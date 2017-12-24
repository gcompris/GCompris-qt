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

import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0

import "../../core"
import "categorization.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string boardsUrl: ":/gcompris/src/activities/categorization/resource/board/"
    property bool vert: background.width < background.height
    property var barAtStart

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
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
            property bool instructionsVisible: true
            property bool categoryImageChecked: (mode === "easy" || mode === "medium")
            property bool scoreChecked: (mode === "easy" || mode === "expert")
            property bool iAmReadyChecked: (mode === "expert")
            property bool displayUpdateDialogAtStart: true
            property var details
            property bool categoriesFallback
            property alias file: file
            property var categories: directory.getFiles(boardsUrl)
        }

        function hideBar() {
            barAtStart = ApplicationSettings.isBarHidden;
            if(categoryReview.width > categoryReview.height)
                ApplicationSettings.isBarHidden = false;
            else 
                ApplicationSettings.isBarHidden = true;
        }
        
        onStart: {
            Activity.init(items, boardsUrl)
            dialogActivityConfig.getInitialConfiguration()
            Activity.start()
            hideBar()
        }

        onStop: {
            dialogActivityConfig.saveDatainConfiguration()
            ApplicationSettings.isBarHidden = barAtStart;
        }
        
        MenuScreen {
            id: menuScreen

        File {
            id: file
            onError: console.error("File error: " + msg);
        }
        }

        Directory {
            id: directory
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
                    id: column
                    spacing: 5
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height
                    property alias easyModeBox: easyModeBox
                    property alias mediumModeBox: mediumModeBox
                    property alias expertModeBox: expertModeBox

                    GCDialogCheckBox {
                        id: easyModeBox
                        width: column.width - 50
                        text: qsTr("Instructions and score visible")
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
                        width: easyModeBox.width
                        text: qsTr("Instructions visible and score invisible")
                        checked: (items.mode == "medium") ? true : false
                        exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(mediumModeBox.checked) {
                                items.mode = "medium"
                                menuScreen.iAmReady.visible = false
                            }
                        }
                    }

                    GCDialogCheckBox {
                        id: expertModeBox
                        width: easyModeBox.width
                        text: qsTr("Instructions invisible and score visible")
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
                if(dataToSave && dataToSave["mode"])
                    items.mode = dataToSave["mode"]
                if(dataToSave && dataToSave["displayUpdateDialogAtStart"])
                    items.displayUpdateDialogAtStart = (dataToSave["displayUpdateDialogAtStart"] == "true") ? true : false
            }

            onSaveData: {
                dataToSave["data"] = Activity.categoriesToSavedProperties(dataToSave)
                dataToSave["mode"] = items.mode
                dataToSave["displayUpdateDialogAtStart"] = items.displayUpdateDialogAtStart ? "true" : "false"
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
            property BarEnumContent withoutConfig: BarEnumContent { value: home | level }
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

        Loader {
            id: categoriesFallbackDialog
            sourceComponent: GCDialog {
                parent: activity.main
                message: qsTr("You don't have all the images for this activity. " +
                              "Press Update to get the complete dataset. " +
                              "Press the Cross to play with demo version or 'Never show this dialog later' if you want to never see again this dialog.")
                button1Text: qsTr("Update the image set")
                button2Text: qsTr("Never show this dialog later")
                onClose: items.categoriesFallback = false
                onButton1Hit: DownloadManager.downloadResource('data2/words/words.rcc')
                onButton2Hit: { items.displayUpdateDialogAtStart = false; dialogActivityConfig.saveDatainConfiguration() }
            }
            anchors.fill: parent
            focus: true
            active: items.categoriesFallback && items.displayUpdateDialogAtStart
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
