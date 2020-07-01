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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
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
    property bool vert: background.width <= background.height
    property var barAtStart

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
        anchors.fill: parent
        sourceSize.width: parent.width
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
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
            property var categories: activity.datasetLoader.data
        }

        function hideBar() {
            barAtStart = ApplicationSettings.isBarHidden;
            if(categoryReview.width >= categoryReview.height)
                ApplicationSettings.isBarHidden = false;
            else 
                ApplicationSettings.isBarHidden = true;
        }
        
        onStart: {
            Activity.init(items, boardsUrl)
            Activity.start()
            hideBar()
        }

        onStop: {
            ApplicationSettings.isBarHidden = barAtStart;
        }
        
        MenuScreen {
            id: menuScreen

        File {
            id: file
            onError: console.error("File error: " + msg);
        }
        }

        CategoryReview {
            id: categoryReview
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onLoadData: {
                if(activityData && activityData["mode"])
                    items.mode = activityData["mode"]
                if(activityData && activityData["displayUpdateDialogAtStart"] !== undefined)
                    items.displayUpdateDialogAtStart = (activityData["displayUpdateDialogAtStart"] === true) ? true : false
            }

            onSaveData: {
                activityData["displayUpdateDialogAtStart"] = items.displayUpdateDialogAtStart
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onStartActivity: {
                items.mode = activityData["mode"]
                items.menuScreen.iAmReady.visible = (activityData["mode"] === "expert") ? true : false;
                background.stop();
                background.start()
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
            property BarEnumContent withConfig: BarEnumContent { value: help | home | activityConfig}
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
            onActivityConfigClicked: {
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
                onButton2Hit: { items.displayUpdateDialogAtStart = false; items.dialogActivityConfig.saveData()}
            }
            anchors.fill: parent
            focus: true
            active: items.categoriesFallback && items.displayUpdateDialogAtStart;
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
