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
            text: "Test Text"
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
            width: background.horizontalLayout
                   ? background.width * 0.40
                   : background.width - gridId.anchors.margins * 2
            height: background.horizontalLayout
                    ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
                    : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.4

            Image {
                id: planetImageMain
                width: Math.min(parent.width, parent.height) * 0.9
                height: width
                anchors.centerIn: parent
                source: mainQuizScreen.planetRealImage
                visible: items.bar.level != 3
            }
        }

        ListView {
            id: optionListView
            width: background.horizontalLayout
                   ? background.width * 0.55
                   : background.width - gridId.anchors.margins * 2
            height: background.horizontalLayout
                    ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
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

            delegate: Item {
                id: optionListViewDelegate
                width: optionListView.width
                height: optionListView.buttonHeight
                anchors.right: parent.right
                anchors.left: parent.left

                property string closenessValue: closeness[index]

                Image {
                    id: planetImageOption
                    width: height
                    height: wordListView.buttonHeight
                    source: planetOptionImage[index]                                                   //source image to be set
                    z: 7
                    fillMode: Image.PreserveAspectFit
                    anchors.leftMargin: 5 * ApplicationInfo.ratio
                    visible:  (items.bar.level == 1) ? true : false  // hide images after first mini game
                }

                AnswerButton {
                    id: wordRectangle
                    width: parent.width * 0.6
                    height: wordListView.buttonHeight
                    textLabel: options[index]                                        //source text to be set

                    anchors.left: planetImageOption.left
                    anchors.right: parent.right

                    isCorrectAnswer: optionListViewDelegate.closenessValue === "100%"  //set the condition
                    onIncorrectlyPressed: {

                    }
                    onCorrectlyPressed: {

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
}
