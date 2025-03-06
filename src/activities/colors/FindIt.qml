/* GCompris - FindIt.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (refactoring and various improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "findit.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    property var dataset
    property string backgroundImg

    property string mode: ""

    onStart: {
        focus = true;
    }

    pageComponent: Image {
        id: activityBackground
        focus: true
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        source: backgroundImg

        property bool keyboardMode: false
        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property Item activityPage: activity
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias containerModel: containerModel
            property alias initAnim: initAnim
            property alias nextAnim: nextAnim
            property alias fadeOutAnim: fadeOutAnim
            // On startup we want to queue the first sound but not after
            property bool firstQuestion: true
            property bool audioOk: false
            property alias score: score
            property bool objectSelected: true
            // we need to know the number of objects to calculate itemWidth before populating the container
            property int objectCount: 1
            // we need to copy tempModel to containerModel only once and only after all the rest is initialized
            property bool modelCopied: false
        }
        onStart: {
            if((!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) && activity.isMusicalActivity) {
                activityBackground.audioDisabled = true;
            } else {
                Activity.start(items, dataset, mode);
            }
        }
        onStop: Activity.stop()

        Keys.onPressed: (event) => {
            if(event.key === Qt.Key_Space) {
                container.currentItem.select()
            }
        }
        Keys.onReleased: (event) => {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onEnterPressed: container.currentItem.select();
        Keys.onReturnPressed: container.currentItem.select();
        Keys.onRightPressed: container.moveCurrentIndexRight();
        Keys.onLeftPressed: container.moveCurrentIndexLeft();
        Keys.onDownPressed: container.moveCurrentIndexDown();
        Keys.onUpPressed: container.moveCurrentIndexUp();
        Keys.onTabPressed: if(repeatItem.visible) repeatItem.clicked();

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        ListModel {
            id: containerModel
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            color: GCStyle.lightBg
            border.color: GCStyle.darkBg
            textItem.color: GCStyle.darkText
            textItem.fontSize: textItem.largeSize

            function initQuestion() {
                textItem.text = Activity.getCurrentTextQuestion()
                if(Activity.getCurrentAudioQuestion()) {
                    if(items.firstQuestion) {
                        items.audioOk = activity.audioVoices.append(Activity.getCurrentAudioQuestion())
                    } else {
                        activity.audioVoices.clearQueue()
                        items.audioOk = activity.audioVoices.play(Activity.getCurrentAudioQuestion())
                    }
                    items.firstQuestion = false
                }
            }

            // initialization sequence for first question of first level
            SequentialAnimation {
                id: initAnim
                PauseAnimation { duration: 50 }
                ScriptAction { script: if(!items.modelCopied)
                    Activity.tempModelToContainer()
                }
                ScriptAction { script: instructionPanel.initQuestion() }
                NumberAnimation { target: instructionPanel; property: "opacity"; to: 1; duration: 300 }
            }

            // fade-out anim only before bonus start
            NumberAnimation { id: fadeOutAnim; target: instructionPanel; property: "opacity"; to: 0; duration: 300 }

            // fade-out + init sequence after first question of a level
            SequentialAnimation {
                id: nextAnim
                NumberAnimation { target: instructionPanel; property: "opacity"; to: 0; duration: 300 }
                ScriptAction { script: initAnim.restart() }
            }

        }

        Item {
            id: containerArea
            anchors.top: instructionPanel.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.bottom: score.top
            anchors.horizontalCenter: activityBackground.horizontalCenter
            width: activityBackground.width - (score.width + GCStyle.baseMargins * 2) * 2
        }

        GridView {
            id: container
            model: containerModel
            width: containerArea.width
            height: containerArea.height
            anchors.horizontalCenter: containerArea.horizontalCenter
            anchors.verticalCenter: containerArea.verticalCenter
            anchors.horizontalCenterOffset: (width - contentItem.childrenRect.width) * 0.5
            anchors.verticalCenterOffset: (height - contentItem.childrenRect.height) * 0.5
            interactive: false
            cellWidth: itemWidth
            cellHeight: itemWidth
            keyNavigationWraps: true

            property int itemWidth: Core.fitItems(container.width, container.height, items.objectCount)

            delegate: ColorItem {
                audioVoices: activity.audioVoices
                source: model.image
                audioSrc: model.audio ? model.audio : ""
                question: model.text
                width: container.itemWidth * 0.9
            }
            add: Transition {
                NumberAnimation {
                    properties: "x, y"
                    from: 0
                    easing.type: Easing.OutCubic
                    duration: 1000
                }
            }
            highlight: Rectangle {
                width: container.cellWidth
                height: container.cellHeight
                color:  "#AAFFFFFF"
                border.width: GCStyle.thinBorder
                border.color: GCStyle.darkBorder
                visible: activityBackground.keyboardMode
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            height: GCStyle.bigButtonHeight
            z: bar.z + 1
            visible: items.audioOk
            anchors {
                bottom: bar.top
                right: parent.right
                margins: GCStyle.baseMargins
            }
            onClicked: if (!activity.audioVoices.isPlaying() && !items.objectSelected)
                           instructionPanel.initQuestion()
        }

        Score {
            id: score
            anchors.bottom: bar.top
            anchors.right: undefined
            anchors.left: parent.left
            anchors.margins: GCStyle.baseMargins
        }

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Loader {
            id: audioNeededDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("This activity requires sound, so it will play some sounds even if the audio voices or effects are disabled in the main configuration.")
                button1Text: qsTr("Quit")
                button2Text: qsTr("Continue")
                onButton1Hit: activity.home();
                onClose: {
                    activityBackground.audioDisabled = false;
                    Activity.start(items, dataset, mode);
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }

}
