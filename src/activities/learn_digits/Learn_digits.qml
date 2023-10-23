/* GCompris - learn_digits.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "learn_digits.js" as Activity

ActivityBase {
    id: activity
    property bool operationMode: false

    onStart: focus = true
    onStop: {}

    Keys.onPressed: {
        Activity.processKey(event);
    }

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        signal scoreStop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item activityPage: activity
            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias circlesLine: circlesLine
            property alias fileId: fileId
            property alias locale: background.locale
            property alias iAmReady: iAmReady
            property int currentSubLevel: 0
            property int nbSubLevel
            property int answer: 0
            property int question: 0
            property string questionText: ""
            property int circlesModel: 3
            property int selectedCircle: -1
            property bool inputLocked: false
            readonly property var levels: activity.datasetLoader.data
            property int mode: 1 // default is arabic numerals
            property bool voicesEnabled: true
            property string imageSource: "qrc:/gcompris/src/core/resource/empty.svg"
        }
        property string locale: ApplicationSettings.locale
        property bool isHorizontal: layoutArea.width >= layoutArea.height

        onStart: {
            Activity.start(items, operationMode);
            if(activity.operationMode)
                itemsVisible();
            else
                itemsHidden();
        }
        onStop: { Activity.stop() }

        function itemsVisible() {
            iAmReady.visible = false;
            if(DownloadManager.areVoicesRegistered(ApplicationSettings.locale) && !operationMode && items.voicesEnabled) {
                repeatItem.visible = true;
            }
            if(items.mode === 1) {
                questionText.visible = true;
            } else {
                questionImage.visible = true;
            }
            scoreArea.visible = true;
            circlesBackground.visible = true;
            circlesArea.visible = true;
            Activity.initQuestion();
            items.inputLocked = false;
        }

        function itemsHidden() {
            iAmReady.visible = true;
            repeatItem.visible = false;
            questionText.visible = false;
            questionImage.visible = false;
            scoreArea.visible = false;
            circlesBackground.visible = false;
            circlesArea.visible = false;
        }

        ReadyButton {
            id: iAmReady
            onClicked: background.itemsVisible();
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Item {
            id: questionArea
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
        }

        Item {
            id: repeatArea
            width: textArea.width
            height: textArea.height
        }

        BarButton {
            id: repeatItem
            visible: false
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg"
            sourceSize.width: repeatArea.height > repeatArea.width ?
                                    repeatArea.width * 0.6 : repeatArea.height * 0.6
            anchors.centerIn: repeatArea
            onClicked: {
                if(!items.inputLocked && !audioVoices.isPlaying()) {
                    Activity.playLetter(items.question.toString());
                }
            }
        }

        Item {
            id: textArea
            anchors.centerIn: questionArea
        }
        GCText {
            id: questionText
            visible: false
            width: textArea.width
            height: textArea.height
            anchors.centerIn: textArea
            horizontalAlignment : Text.AlignHCenter
            verticalAlignment : Text.AlignVCenter
            text: items.questionText
            minimumPointSize: 12
            fontSize: 1024
            fontSizeMode: Text.Fit
            font.bold: true
            color: "#d2611d"
            style: Text.Outline
            styleColor: "white"
        }
        Image {
            id: questionImage
            visible: false
            anchors.centerIn: textArea
            height: Math.min(textArea.height, textArea.width)
            width: height
            sourceSize.width: height
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            source: items.imageSource
        }
        Item {
            id: scoreArea
            width: textArea.width
            height: textArea.height
            visible: false
            property int scoreItemsSize: 10
            Score {
                id: score
                width: scoreArea.scoreItemsSize
                numberOfSubLevels: items.nbSubLevel
                currentSubLevel: items.currentSubLevel
                onStop: {
                    if(!bonus.isPlaying) {
                        Activity.initQuestion();
                        items.inputLocked = false;
                    }
                }
            }
            BarButton {
                id: okButton
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                height: scoreArea.scoreItemsSize
                width: scoreArea.scoreItemsSize
                sourceSize.height: height
                sourceSize.width: height
                enabled: !items.inputLocked
                onClicked: {
                    if(!items.inputLocked)
                        Activity.checkAnswer();
                }
            }
            states: [
                State {
                    id: scoreHorizontal
                    when: scoreArea.width >= scoreArea.height
                    PropertyChanges {
                        target: scoreArea
                        scoreItemsSize: scoreArea.width * 0.4
                    }
                    AnchorChanges {
                        target: score
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: undefined
                        anchors.right: parent.right
                        anchors.bottom: undefined
                    }
                    AnchorChanges {
                        target: okButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: undefined
                        anchors.left: parent.left
                        anchors.top: undefined
                    }
                },
                State {
                    id: scoreVertical
                    when: scoreArea.width < scoreArea.height
                    PropertyChanges {
                        target: scoreArea
                        scoreItemsSize: scoreArea.height * 0.5
                    }
                    AnchorChanges {
                        target: score
                        anchors.verticalCenter: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.right: undefined
                        anchors.bottom: parent.bottom
                    }
                    AnchorChanges {
                        target: okButton
                        anchors.verticalCenter: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.left: undefined
                        anchors.top: parent.top
                    }
                }
            ]
        }

        Rectangle {
            id: circlesBackground
            visible: false
            color: "#D0FFFFFF"
            anchors.bottom: layoutArea.bottom
            anchors.right: layoutArea.right
            anchors.margins: 10 * ApplicationInfo.ratio
            radius: anchors.margins
        }
        Item {
            id: circlesArea
            visible: false
            property int itemWidth: 10 //temp values overriden with states
            width: 10
            height: 10
            anchors.centerIn: circlesBackground
            Rectangle {
                id: circlesSelector
                width: circlesArea.itemWidth
                height: circlesArea.itemWidth
                radius: 10 * ApplicationInfo.ratio
                color: "#803ACAFF"
                visible: items.selectedCircle > -1
                anchors.centerIn: circlesLine.itemAt(items.selectedCircle)
            }
            Repeater {
                id: circlesLine
                model: items.circlesModel
                delegate: circlesComponent
            }
            Component {
                id: circlesComponent
                Item {
                    function resetCircle() {
                        isFilled = false;
                        circleColor = "#00ffffff";
                    }
                    function clickCircle() {
                        if(!isFilled) {
                            ++items.answer;
                            circleColor = "#ffd2611d";
                        } else {
                            --items.answer;
                            circleColor = "#00ffffff";
                        }
                        isFilled = !isFilled
                    }
                    width: circlesArea.itemWidth
                    height: width
                    x: isHorizontal ? width * index : 0
                    y: isHorizontal ? 0 : width * index
                    property bool isFilled: false
                    property string circleColor: "#00ffffff"
                    Rectangle {
                        id: circle
                        anchors.centerIn: parent
                        border.color: "#373737"
                        border.width: 5 * ApplicationInfo.ratio
                        color: circleColor
                        width: parent.width * 0.9
                        height: width
                        radius: width * 0.5
                    }
                    MouseArea {
                        id: circleInput
                        anchors.fill: parent
                        enabled: !items.inputLocked
                        onClicked: parent.clickCircle();
                    }
                }
            }
        }

        states: [
            State {
                id: horizontalLayout
                when: isHorizontal
                AnchorChanges {
                    target: questionArea
                    anchors.bottom: layoutArea.verticalCenter
                    anchors.right: layoutArea.right
                }
                AnchorChanges {
                    target: circlesBackground
                    anchors.top: layoutArea.verticalCenter
                    anchors.left: layoutArea.left
                }
                PropertyChanges {
                    target: textArea
                    width: questionArea.width * 0.3
                    height: questionArea.height * 0.8
                }
                AnchorChanges {
                    target: repeatArea
                    anchors.right: textArea.left
                    anchors.bottom: undefined
                    anchors.verticalCenter: textArea.verticalCenter
                    anchors.horizontalCenter: undefined
                }
                AnchorChanges {
                    target: scoreArea
                    anchors.left: textArea.right
                    anchors.top: undefined
                    anchors.verticalCenter: textArea.verticalCenter
                    anchors.horizontalCenter: undefined
                }
                PropertyChanges {
                    target: circlesArea
                    itemWidth: Math.min(circlesBackground.width / (items.circlesModel + 1),
                                        circlesBackground.height * 0.9)
                    width: itemWidth * items.circlesModel
                    height: itemWidth
                }
            },
            State {
                id: verticaleLayout
                when: !isHorizontal
                AnchorChanges {
                    target: questionArea
                    anchors.bottom: layoutArea.bottom
                    anchors.right: layoutArea.horizontalCenter
                }
                AnchorChanges {
                    target: circlesBackground
                    anchors.top: layoutArea.top
                    anchors.left: layoutArea.horizontalCenter
                }
                PropertyChanges {
                    target: textArea
                    width: questionArea.width * 0.8
                    height: questionArea.height * 0.3
                }
                AnchorChanges {
                    target: repeatArea
                    anchors.right: undefined
                    anchors.bottom: textArea.top
                    anchors.verticalCenter: undefined
                    anchors.horizontalCenter: textArea.horizontalCenter
                }
                AnchorChanges {
                    target: scoreArea
                    anchors.left: undefined
                    anchors.top: textArea.bottom
                    anchors.verticalCenter: undefined
                    anchors.horizontalCenter: textArea.horizontalCenter
                }
                PropertyChanges {
                    target: circlesArea
                    itemWidth: Math.min(circlesBackground.height / (items.circlesModel + 1),
                                        circlesBackground.width * 0.9)
                    width: itemWidth
                    height: itemWidth * items.circlesModel
                }
            }
        ]

        File {
            id: fileId
        }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
                if(activityData && activityData["voicesEnabled"]) {
                    items.voicesEnabled = activityData["voicesEnabled"] === "true" ? true : false;
                }
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onStartActivity: {
                background.stop();
                background.start();
            }

            onClose: home()
        }


        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig}
            onHelpClicked: {
                displayDialog(dialogHelp);
            }
            onPreviousLevelClicked: {
                if(!items.inputLocked)
                    Activity.previousLevel();
            }
            onNextLevelClicked: {
                if(!items.inputLocked)
                    Activity.nextLevel();
            }
            onHomeClicked: activity.home();
            onActivityConfigClicked: displayDialog(dialogActivityConfig);
        }

        Bonus {
            id: bonus
            onStop: items.inputLocked = false;
            Component.onCompleted: win.connect(Activity.nextLevel);
        }
    }

}
