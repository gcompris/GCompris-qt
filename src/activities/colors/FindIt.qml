/* GCompris - FindIt.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges (pascal.georges1@free.fr)
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
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "findit.js" as Activity

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
        sourceSize.width: Math.max(parent.width, parent.height)
        source: backgroundImg

        property bool keyboardMode: false

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
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
        onStart: Activity.start(items, dataset, mode)
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

        ListModel {
              id: containerModel
        }

        GridView {
            id: container
            model: containerModel
            x: background.width * 0.2
            y: background.height * 0.2
            width: background.width * 0.7
            height: background.height * 0.6
            interactive: false
            cellWidth: itemHeight + 10
            cellHeight: itemWidth + 10
            keyNavigationWraps: true

            property int itemWidth: Math.min((parent.width * 0.6) / (count / 2),
                                             (parent.height * 0.5) / (count / 3))
            property int itemHeight: itemWidth

            delegate: ColorItem {
                audioVoices: activity.audioVoices
                source: model.image
                audioSrc: model.audio ? model.audio : ""
                question: model.text
                sourceSize.height: container.itemHeight
                sourceSize.width: container.itemWidth
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
            onClicked: if (ApplicationSettings.isAudioVoicesEnabled)
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
    }

}
