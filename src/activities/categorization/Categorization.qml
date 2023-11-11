/* GCompris - categorization.qml
*
* SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
*
* Authors:
*   Divyam Madaan <divyam3897@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "categorization.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool vert: background.width <= background.height

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
            property int currentLevel: activity.currentLevel
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
            property bool okEnabled: true
        }

        onStart: {
            Activity.init(items)
            Activity.start()
        }

        MenuScreen {
            id: menuScreen

            File {
                id: file
                onError: console.error("File error: " + msg);
            }
        }

        Rectangle {
            id: categoryArea
            color: "#00ffffff"
            anchors.top: background.top
            anchors.bottom: bar.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.bottomMargin: bar.height * 0.2
            CategoryReview {
                id: categoryReview
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onLoadData: {
                if(activityData && activityData["mode"])
                    items.mode = activityData["mode"]
                if(activityData && activityData["displayUpdateDialogAtStart"] !== undefined)
                    items.displayUpdateDialogAtStart = (activityData["displayUpdateDialogAtStart"] === "true") ? true : false
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
            level: items.currentLevel + 1
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
            onStop: items.okEnabled = true
        }

        Loader {
            id: categoriesFallbackDialog
            sourceComponent: GCDialog {
                parent: activity.main
                isDestructible: false
                message: qsTr("You don't have all the images for this activity. " +
                              "Click on 'Update the image set' to download the full word image set. " +
                              "Click on the cross or on 'Never show this dialog again' to play with the demo version.")
                button1Text: qsTr("Update the image set")
                button2Text: qsTr("Never show this dialog again")
                onClose: items.categoriesFallback = false
                onButton1Hit: DownloadManager.downloadResource(GCompris.WORDSET)
                onButton2Hit: { items.displayUpdateDialogAtStart = false; items.dialogActivityConfig.saveData()}
            }
            anchors.fill: parent
            focus: true
            active: items.categoriesFallback && items.displayUpdateDialogAtStart && ApplicationInfo.isDownloadAllowed;
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
