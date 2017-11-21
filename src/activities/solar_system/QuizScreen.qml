/* GCompris - QuizScreen.qml
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "solar_system.js" as Activity

Item {
    id: mainQuizScreen
    width: parent.width
    height: parent.height
    focus: true

    property alias score: score
    property alias optionListModel: optionListModel
    property string planetRealImage
    property string question
    property string closenessValueInMeter

    Rectangle {
        id: questionArea
        anchors.right: score.left
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10 * ApplicationInfo.ratio
        height: questionText.height + 10 * ApplicationInfo.ratio
        color: 'white'
        radius: 10
        border.width: 3
        opacity: 0.8
        border.color: "black"
        GCText {
            id: questionText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent.Center
            color: "black"
            width: parent.width
            wrapMode: Text.Wrap
            text: mainQuizScreen.question
        }
    }

    ListModel {
        id: optionListModel
    }

    Grid {
        id: imageAndOptionGrid
        columns: (background.horizontalLayout && !background.assessmentMode && items.bar.level != 2) ? 2 : 1
        spacing: 10 * ApplicationInfo.ratio
        anchors.top: questionArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10 * ApplicationInfo.ratio

        Item {
            width: background.horizontalLayout ? background.width * 0.40
                   : background.width - imageAndOptionGrid.anchors.margins * 2
            height: background.horizontalLayout ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
                    : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.4
            visible: !background.assessmentMode && items.bar.level != 2

            Image {
                id: planetImageMain
                sourceSize.width: Math.min(parent.width, parent.height) * 0.9
                anchors.centerIn: parent
                source: mainQuizScreen.planetRealImage
                fillMode: Image.PreserveAspectCrop
            }
        }

        Item {
            width: ( background.assessmentMode || items.bar.level == 2 ) ? mainQuizScreen.width
                   : background.horizontalLayout ? background.width * 0.55
                   : background.width - imageAndOptionGrid.anchors.margins * 2
            height: background.horizontalLayout ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
                    : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.60

            ListView {
                id: optionListView
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: background.horizontalLayout ? background.width * 0.40
                       : background.width - imageAndOptionGrid.anchors.margins * 2
                height: background.horizontalLayout ? background.height - bar.height - questionArea.height - 50 * ApplicationInfo.ratio
                        : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.60
                spacing: 10 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: optionListModel

                property int buttonHeight: height / 4 * 0.9

                add: Transition {
                    NumberAnimation { properties: "y"; from: parent.y; duration: 500 }
                }

                delegate: Item {
                    id: optionListViewDelegate
                    width: optionListView.width
                    height: optionListView.buttonHeight
                    anchors.right: parent.right
                    anchors.left: parent.left

                    property string closenessValue: closeness

                    AnswerButton {
                        id: optionRectangle
                        width: parent.width
                        height: optionListView.buttonHeight
                        textLabel: optionValue
                        anchors.right: parent.right

                        isCorrectAnswer: closenessValue === "100%"
                        onIncorrectlyPressed: {
                            if(!background.assessmentMode) {
                                if(correctAnswerAnim.running)
                                    correctAnswerAnim.stop()
                                if(incorrectAnswerAnim.running)
                                    incorrectAnswerAnim.stop()
                                incorrectAnswerAnim.start()
                                mainQuizScreen.closenessValueInMeter = closenessValue
                            }
                        }
                        onCorrectlyPressed: {
                            if(!background.assessmentMode) {
                                if(correctAnswerAnim.running)
                                    correctAnswerAnim.stop()
                                if(incorrectAnswerAnim.running)
                                    incorrectAnswerAnim.stop()
                                correctAnswerAnim.start()
                                mainQuizScreen.closenessValueInMeter = closenessValue
                            }
                            else
                                Activity.nextSubLevel()
                        }
                    }
                }
            }
        }
    }

    Score {
        id: score
        anchors.bottom: undefined
        anchors.right: parent.right
        anchors.rightMargin: 10 * ApplicationInfo.ratio
        anchors.top: parent.top
    }

    Rectangle {
        id: closenessMeter
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10 * ApplicationInfo.ratio
        height: closenessText.height * 1.23
        width: closenessText.width * 1.23
        radius: width * 0.06
        border.width: 2
        border.color: "black"
        opacity: 0.78
        visible: !background.assessmentMode
        GCText {
            id: closenessText
            anchors.centerIn: parent
            color: "black"
            fontSize: background.horizontalLayout ? mediumSize : smallSize
            text: qsTr("Closeness: ") + closenessValueInMeter
        }

        SequentialAnimation {
            id: incorrectAnswerAnim
            NumberAnimation { target: closenessText; property: "scale"; to: 1.2; duration: 300 }
            NumberAnimation { target: closenessText; property: "scale"; to: 1.0; duration: 300 }
        }

        SequentialAnimation {
            id: correctAnswerAnim
            NumberAnimation { target: closenessText; property: "scale"; to: 1.2; duration: 300 }
            NumberAnimation { target: closenessText; property: "scale"; to: 1.0; duration: 300 }
            NumberAnimation { target: closenessText; property: "scale"; to: 1.2; duration: 300 }
            NumberAnimation { target: closenessText; property: "scale"; to: 1.0; duration: 300 }
            ScriptAction { script: Activity.nextSubLevel() }
        }
    }
}
