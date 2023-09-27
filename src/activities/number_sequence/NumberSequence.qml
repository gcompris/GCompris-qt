/* GCompris - NumberSequence.qml
*
* SPDX-FileCopyrightText: 2014 Emmanuel Charruau <echarruau@gmail.com>
*
* Authors:
*   Olivier Ponchaut <opvg@mailoo.org> (GTK+ version)
*   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "."
import "number_sequence.js" as Activity
import "number_sequence_dataset.js" as Dataset


ActivityBase {
    id: activity
    property string mode: "number_sequence"
    property var dataset: Dataset
    property real pointImageOpacity: 1.0
    property string url: "qrc:/gcompris/src/activities/number_sequence/resource/"
    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
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
            property GCSfx audioEffects: activity.audioEffects
            property GCAudio audioVoices: activity.audioVoices
            property alias pointImageRepeater: pointImageRepeater
            property alias segmentsRepeater: segmentsRepeater
            property alias imageBack: imageBack
            property alias imageBack2: imageBack2
            property int pointIndexToClick
            property int mode: 1 // default is automatic
            property bool highlightEnabled: true // make the point to click bigger. Always true in drawletters, drawnumbers and clickanddraw
        }

        onStart: { Activity.start(items,mode,dataset,url) }
        onStop: { Activity.stop() }

        Image {
            id: imageBack
            anchors.top: parent.top
            anchors.horizontalCenter: background.horizontalCenter
            width: Math.min((background.height - bar.height * 1.5), background.width)
            height: imageBack.width
            sourceSize.width: imageBack.width
            sourceSize.height: imageBack.height
        }

        Image {
            id: imageBack2
            anchors.centerIn: imageBack
            width: imageBack.width
            height: imageBack.height
            sourceSize.width: imageBack2.width
            sourceSize.height: imageBack2.height
        }

        Repeater {
            id: segmentsRepeater

            Rectangle {
                id: line
                opacity: 0
                color: "#373737"
                transformOrigin: Item.TopLeft
                x: imageBack.x + modelData[0] * imageBack.width / 520
                y: modelData[1] * imageBack.height / 520
                property double x2: imageBack.x + modelData[2] * imageBack.width / 520
                property double y2: modelData[3] * imageBack.height / 520
                width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                height: 3 * ApplicationInfo.ratio
                rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)

            }
        }

        Item {
            id: playArea
            anchors.fill: parent

            Repeater {
                id: pointImageRepeater

                Image {
                    id: pointImage
                    source: Activity.url + (highlight ?
                            (pointImageOpacity ? "bluepoint.svg" : "bluepointHighlight.svg") :
                            markedAsPointInternal ? "blackpoint.svg" : "greenpoint.svg")

                    sourceSize.height: (items.highlightEnabled && items.pointIndexToClick == index) ?
                                        imageBack2.width * 0.08 : imageBack2.width * 0.04 //to change the size of dots

                    x: imageBack.x + modelData[0] * imageBack.width / 520 - sourceSize.height/2
                    y: modelData[1] * imageBack.height / 520 - sourceSize.height/2
                    z: items.pointIndexToClick == index ? 1000 : index

                    // only hide last point for clickanddraw and number_sequence
                    // as the last point is also the first point
                    visible: (mode=="clickanddraw" || mode=="number_sequence") &&
                              index == pointImageRepeater.count - 1 &&
                              items.pointIndexToClick == 0 ? false : true

                    function drawSegment() {
                        Activity.drawSegment(index)
                    }
                    property bool highlight: false
                    // draw a point instead of hiding the clicked node if it is
                    // the first point of the current line to draw
                    // (helpful to know where the line starts)
                    property bool markedAsPointInternal: markedAsPoint && items.pointIndexToClick == index+1
                    property bool markedAsPoint: false

                    scale: markedAsPointInternal ? 0.2 : 1
                    opacity: index >= items.pointIndexToClick || markedAsPointInternal ? 1 : 0

                    property int xAreaStart: x
                    property int xAreaEnd: x + width
                    property int yAreaStart: y
                    property int yAreaEnd: y + height

                    GCText {
                        id: pointNumberText
                        opacity: pointImageOpacity
                        text: index + 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: 11
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                    }
                }
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent
            minimumTouchPoints: 1
            maximumTouchPoints: 1
            z: 100

            function checkPoints(touchPoints) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    for(var p = 0; p < pointImageRepeater.count; p++) {
                        var part = pointImageRepeater.itemAt(p)
                        // Could not make it work with the item.contains() api
                        if(touch.x > part.xAreaStart && touch.x < part.xAreaEnd &&
                        touch.y > part.yAreaStart && touch.y < part.yAreaEnd) {
                            part.drawSegment()
                        }
                    }
                }
            }

            onPressed: {
                checkPoints(touchPoints)
            }
            onTouchUpdated: {
                checkPoints(touchPoints)
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: home()

            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
                // This option exists only for number_sequence
                if(activityData && activityData["highlight"]) {
                    items.highlightEnabled = activityData["highlight"] === "true"
                }
            }
            onStartActivity: {
                background.stop()
                Activity.initLevel()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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
            onWin: if(items.mode == 1) Activity.nextLevel();
        }
    }
}
