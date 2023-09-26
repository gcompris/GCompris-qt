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
import QtGraphicalEffects 1.0
import GCompris 1.0

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
        id: background
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
            property alias background: background
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
                background.audioDisabled = true;
            } else {
                Activity.start(items, dataset, mode);
            }
        }
        onStop: Activity.stop()

        Keys.onPressed: {
            if(event.key === Qt.Key_Space) {
                container.currentItem.select()
            }
        }
        Keys.onReleased: {
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

        ListModel {
            id: containerModel
        }

        Rectangle {
            id: questionItem
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            width: questionText.contentWidth + 20 * ApplicationInfo.ratio
            height: Math.max(10 * ApplicationInfo.ratio, questionText.contentHeight + 5 * ApplicationInfo.ratio)
            radius: 5 * ApplicationInfo.ratio
            color: "#E2E2E2"
            border.color: "#373737"
            border.width: 2 * ApplicationInfo.ratio
            opacity: 0.01

            function initQuestion() {
                questionText.text = Activity.getCurrentTextQuestion()
                if(Activity.getCurrentAudioQuestion()) {
                    if(items.firstQuestion)
                        items.audioOk = activity.audioVoices.append(Activity.getCurrentAudioQuestion())
                    else {
                        activity.audioVoices.clearQueue()
                        items.audioOk = activity.audioVoices.play(Activity.getCurrentAudioQuestion())
                    }
                    items.firstQuestion = false
                }
            }

            // initialization sequence for first question of first level
            SequentialAnimation {
                id: initAnim
                ScriptAction { script: questionItem.initQuestion() }
                PauseAnimation { duration: 50 }
                ScriptAction { script: if(!items.modelCopied)
                                            Activity.tempModelToContainer()
                }
                NumberAnimation { target: questionItem; property: "opacity"; to: 1; duration: 300 }
            }

            // fade-out anim only before bonus start
            NumberAnimation { id: fadeOutAnim; target: questionItem; property: "opacity"; to: 0.01; duration: 300 }

            // fade-out + init sequence after first question of a level
            SequentialAnimation {
                id: nextAnim
                NumberAnimation { target: questionItem; property: "opacity"; to: 0.01; duration: 300 }
                ScriptAction { script: initAnim.restart() }
            }

            GCText {
                id: questionText
                anchors.centerIn: parent
                fontSize: largeSize
                width: background.width * 0.9
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.weight: Font.DemiBold
                color: "#373737"
            }
        }

        GridView {
            id: container
            model: containerModel
            anchors.top: questionItem.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: score.top
            anchors.horizontalCenter: background.horizontalCenter
            width: background.width - score.width * 2
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
                sourceSize.height: container.itemWidth * 0.9
                sourceSize.width: container.itemWidth * 0.9
            }
            add: Transition {
                PathAnimation {
                    path: Path {
                        PathCurve { x: background.width / 3}
                        PathCurve { y: background.height / 3}
                        PathCurve {}
                    }
                    easing.type: Easing.InOutQuad
                    duration: 2000
                }
            }
            highlight: Rectangle {
                width: container.cellWidth
                height: container.cellHeight
                color:  "#AAFFFFFF"
                border.width: 3
                border.color: "black"
                visible: background.keyboardMode
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
            sourceSize.height: visible ? 80 * ApplicationInfo.ratio : 1
            z: bar.z + 1
            visible: items.audioOk
            anchors {
                bottom: bar.top
                right: parent.right
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: if (!activity.audioVoices.isPlaying())
                           questionItem.initQuestion()
        }

        Score {
            id: score
            anchors.bottom: bar.top
            anchors.right: bar.right
            anchors.left: parent.left
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 0
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
                    background.audioDisabled = false;
                    Activity.start(items, dataset, mode);
                }
            }
            anchors.fill: parent
            focus: true
            active: background.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }

}
