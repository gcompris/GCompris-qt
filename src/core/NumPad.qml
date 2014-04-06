/* GCompris - NumPad.qml
 *
 * Copyright (C) 2014 Aruna Sankaranarayanan
 *
 * Authors:
 *   Aruna Sankaranarayanan <arunasank@src.gnome.org>
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
import QtQuick 2.2
import QtQuick.Controls 1.0
import GCompris 1.0

Item {

    id: containerPanel
    anchors.fill: parent

    property variant colours: ["#ea7025", "#67c111", "#00bde3", "#bde300","#e3004c"]
    property variant numbers: [0,1,2,3,4]
    property string answer: ""
    property bool answerFlag: false
    property var leftPanelComponent: leftPanel
    property var rightPanelComponent: rightPanel
    property var backspaceButtonComponent:backspaceButton

    signal answer

    Column {
        id: leftPanel
        width: 120 * ApplicationInfo.ratio
        height: parent.height - 90 * ApplicationInfo.ratio
        opacity: 0.8

        Repeater {
            model:5

            Rectangle{
                width: parent.width
                height: parent.height/5
                color: colours[index]
                border.color: Qt.darker(color)
                border.width:2

                Text{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: numbers[index]
                    font.pointSize: 28
                    font.bold: true

                }

                MouseArea{
                    anchors.fill:parent
                    enabled: (ApplicationInfo.isMobile) ? true : false

                    onClicked :{
                        if(answer.length < 2)
                            answer += numbers[index]
                    }
                    onPressed: {
                        leftPanel.children[index].color = Qt.lighter(colours[index])
                        leftPanel.children[index].border.width = 5
                    }
                    onReleased: {
                        leftPanel.children[index].color = colours[index]
                        leftPanel.children[index].border.width = 2
                    }
                }

            }
        }
    }

    Column {
        id: rightPanel
        width: 120 * ApplicationInfo.ratio
        height: parent.height - 90 * ApplicationInfo.ratio
        x: parent.width - 120 * ApplicationInfo.ratio
        opacity: 0.8

        Repeater {
            model: 5

            Rectangle {
                width: parent.width
                height: parent.height/5
                color: colours[index]
                border.color: Qt.darker(color)
                border.width:2

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: numbers[index] + 5
                    font.pointSize: 28
                    font.bold: true

                }
                MouseArea {
                    anchors.fill: parent
                    enabled: (ApplicationInfo.isMobile) ? true : false

                    onClicked: {
                        if(answer.length < 2)
                            answer += numbers[index] + 5
                    }
                    onPressed: {
                        rightPanel.children[index].color = Qt.lighter(colours[index])
                        rightPanel.children[index].border.width = 5
                    }
                    onReleased: {
                        rightPanel.children[index].color = colours[index]
                        rightPanel.children[index].border.width = 2
                    }
                }
            }
        }
        Rectangle {
            id: backspaceButton
            width: parent.width
            height: containerPanel.height - rightPanel.height
            color: "white"
            border.color: "black"
            border.width:2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: "←"
                font.pointSize: 28
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                enabled: (ApplicationInfo.isMobile) ? true : false

                onClicked: {
                    answer = answer.substring(0,answer.length - 1)
                }
                onPressed: {
                    backspaceButton.color = Qt.lighter("white")
                    backspaceButton.border.width = 5
                }

                onReleased: {
                    backspaceButton.color = "white"
                    backspaceButton.border.width = 2
                }
            }

        }
    }

    function resetText()
    {
        answer = ""
    }
}
