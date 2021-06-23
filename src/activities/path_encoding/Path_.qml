/* GCompris - Path.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core"
import "path.js" as Activity

ActivityBase {
    id: activity
    // mode : encode | decode
    property string mode
    
    // movement : absolute | relative
    property string movement
    
    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        color: "#4DA849"
        anchors.fill: parent
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
            readonly property string resourceUrl: activity.resourceUrl
            readonly property string mode: activity.mode
            readonly property string movement: activity.movement
            property int rows
            property int cols
            property var levels: activity.datasetLoader.data
            property alias mapView : mapView
            property alias tux : tux
            property alias mapListModel : mapListModel
            property alias movesListModel : movesListModel
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        
        ListModel {
            id: mapListModel
        }
        
        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
        }

        MapView {
            id: mapView
            
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: 0.05 * parent.height
                leftMargin: 0.10 * parent.height
            }
            
            width: 0.9 * layoutArea.height
            height: 0.9 * layoutArea.height
            
            rows: items.rows
            cols: items.cols
        }
        
        ListModel {
            id: movesListModel
        }
        
        MoveBar {
            id: moveBar
            
            anchors {
                top: layoutArea.top
                left: mapView.right
                topMargin: 0.05 * parent.height
                leftMargin: 0.05 * parent.height
            }
            
            width: parent.width - mapView.width - 2*mapView.anchors.leftMargin - anchors.leftMargin
            height: 0.9 * layoutArea.height / 2
        }
        
        MoveButtons {
            id: moveButtons
            
            anchors {
                top: moveBar.bottom
                left: mapView.right
                topMargin: 0.05 * parent.height
                leftMargin: 0.05 * parent.height
            }
            
            width: moveBar.width
            height: mapView.height - moveBar.height - anchors.topMargin
        }
        
        Tux {
            id: tux
            width: mapView.cellWidth
            height: mapView.cellHeight
        }
        
        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                // restart activity on saving
                background.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.start()
            }
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
    
    Keys.onLeftPressed: Activity.moveTowards('LEFT')
    Keys.onRightPressed: Activity.moveTowards('RIGHT')
    Keys.onUpPressed: Activity.moveTowards('UP')
    Keys.onDownPressed: Activity.moveTowards('DOWN')
}
