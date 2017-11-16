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
import "../../core"
import "solar_system.js" as Activity

Item {
    id: mainQuizScreen
    width: parent.width
    height: parent.height

    property alias score: score
    property alias optionListModel: optionListModel
    property string planetRealImage
    property string question
    property string closenessValueInMeter
    property bool hintVisible
    property string hint

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
        id: gridId
        columns: (background.horizontalLayout && items.bar.level!=3) ? 2 : 1
        spacing: 10 * ApplicationInfo.ratio
        anchors.top: questionArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10 * ApplicationInfo.ratio

        Item {
            width: (items.bar.level === 3)
                   ? 0
                   : background.horizontalLayout
                   ? background.width * 0.40
                   : background.width - gridId.anchors.margins * 2
            height: (items.bar.level === 3)
                    ? 0
                    : background.horizontalLayout
                    ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
                    : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.4

            Image {
                id: planetImageMain
                sourceSize.width: Math.min(parent.width, parent.height) * 0.9
                anchors.centerIn: parent
                source: mainQuizScreen.planetRealImage
                visible: items.bar.level != 3
                fillMode: Image.PreserveAspectCrop
            }
        }

        Item {
            width: (items.bar.level === 3)
                   ? mainQuizScreen.width
                   : background.horizontalLayout
                   ? background.width * 0.55
                   : background.width - gridId.anchors.margins * 2
            height: background.horizontalLayout
                    ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
                    : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.60

            ListView {
                id: optionListView
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: background.horizontalLayout
                       ? background.width * 0.40
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height - questionArea.height - 50 * ApplicationInfo.ratio
                        : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.60
                spacing: 10 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: optionListModel

                highlightFollowsCurrentItem: false
                focus: true
                keyNavigationWraps: true

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
                        id: wordRectangle
                        width: parent.width
                        height: optionListView.buttonHeight
                        textLabel: optionValue                                       //source text to be set
                        anchors.right: parent.right

                        isCorrectAnswer: closenessValue === "100%"  //set the condition
                        onIncorrectlyPressed: {
                            if(items.bar.level === 1) {
                                if(correctAnswerAnim.running)
                                    correctAnswerAnim.stop()
                                if(incorrectAnswerAnim.running)
                                    incorrectAnswerAnim.stop()
                                incorrectAnswerAnim.start()
                                mainQuizScreen.closenessValueInMeter = closenessValue
                            }
                        }
                        onCorrectlyPressed: {
                            if(items.bar.level === 1) {
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
        visible: items.bar.level === 1
        GCText {
            id: closenessText
            anchors.centerIn: parent
            color: "black"
            fontSize: background.horizontalLayout ? mediumSize : smallSize
            text: "Closeness: " + closenessValueInMeter
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

    Rectangle {
        id: hintBar
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10 * ApplicationInfo.ratio
        height: hintText.height * 1.23
        width: hintText.width * 1.23
        radius: width * 0.06
        border.width: 2
        border.color: "black"
        opacity: 0.78
        visible: hintVisible
        GCText {
            id: hintText
            anchors.centerIn: parent
            color: "black"
            fontSize: background.horizontalLayout ? mediumSize : smallSize
            text: "Hint: " + hint
        }
    }
}
