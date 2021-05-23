/* GCompris - FindIt.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges (pascal.georges1@free.fr)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
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
            property alias bar: bar
            property alias bonus: bonus
            property alias containerModel: containerModel
            property alias questionItem: questionItem
            // On startup we want to queue the first sound but not after
            property bool firstQuestion: true
            property bool audioOk: false
            property alias score: score
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

        GridView {
            id: container
            model: containerModel
            anchors.top: questionItem.bottom
            anchors.topMargin: score.height * 0.2
            anchors.bottom: score.top
            anchors.horizontalCenter: background.horizontalCenter
            width: background.width - score.width * 2
            interactive: false
            cellWidth: itemWidth
            cellHeight: itemWidth
            keyNavigationWraps: true

            property int itemWidth: Core.fitItems(container.width, container.height, container.count)

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
                width: container.cellWidth - container.spacing
                height: container.cellHeight - container.spacing
                color:  "#AAFFFFFF"
                border.width: 3
                border.color: "black"
                visible: background.keyboardMode
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        GCText {
            id: questionItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            fontSize: largeSize
            width: parent.width * 0.9
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "black"
            color: "white"

            function initQuestion() {
                text = Activity.getCurrentTextQuestion()
                if(Activity.getCurrentAudioQuestion()) {
                    if(items.firstQuestion)
                        items.audioOk = activity.audioVoices.append(Activity.getCurrentAudioQuestion())
                    else
                        items.audioOk = activity.audioVoices.play(Activity.getCurrentAudioQuestion())
                    items.firstQuestion = false
                }
                opacity = 1.0
            }

            onOpacityChanged: opacity == 0 ? initQuestion() : ""
            Behavior on opacity { PropertyAnimation { duration: 500 } }
        }

        DropShadow {
            anchors.fill: questionItem
            cached: false
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8.0
            samples: 16
            color: "#80000000"
            source: questionItem
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
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
