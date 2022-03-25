/* GCompris - PlanetInSolarModel.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "solar_system.js" as Activity

Item {
    id: planetItem
    width: background.itemWidth
    height: width

    property string planetImageSource
    property string planetName
    property double planetSize
    property bool planetHovered
    property bool hintMode

    // Name of the planet which hovers over the top of each planet
    GCText {
        id: planetNameText
        width: parent.width
        fontSizeMode: Text.Fit
        font.pointSize: NaN // need to clear font.pointSize explicitly
        font.pixelSize: parent.width * 0.18
        color: "white"
        text: planetName

        states: [
                State {
                    name: "hScreen"
                    when: background.horizontalLayout
                    AnchorChanges {
                        target: planetNameText
                        anchors.bottom: planetItem.top
                        anchors.horizontalCenter: planetItem.horizontalCenter
                        anchors.left: undefined
                        anchors.verticalCenter: undefined
                    }
                    PropertyChanges {
                        target: planetNameText
                        anchors.bottomMargin: 20 * ApplicationInfo.ratio
                        anchors.leftMargin: 0
                        horizontalAlignment: Text.AlignHCenter
                    }
                },
                State {
                    name: "vScreen"
                    when: !background.horizontalLayout
                    AnchorChanges {
                        target: planetNameText
                        anchors.bottom: undefined
                        anchors.horizontalCenter: undefined
                        anchors.left: planetItem.right
                        anchors.verticalCenter: planetItem.verticalCenter
                    }
                    PropertyChanges {
                        target: planetNameText
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 20 * ApplicationInfo.ratio
                        horizontalAlignment: Text.AlignLeft
                    }
                }

        ]

        MouseArea {
            id: mouseAreaText
            anchors.fill: planetNameText
            enabled: !message.visible && !hintMode
            hoverEnabled: ApplicationInfo.isMobile ? false : true
            onEntered: planetHovered = true
            onExited: planetHovered = false
            onClicked: {
                Activity.showQuizScreen(index)
            }
        }
    }

    Image {
        id: planetImage
        z: -10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * planetSize
        height: planetImage.width
        fillMode: Image.PreserveAspectFit
        source: planetImageSource
    }

    states: [
            State {
                name: "hover"
                when: planetHovered
                PropertyChanges {
                    target: planetNameText
                    scale: 1.2
                }
                PropertyChanges {
                    target: planetImage
                    scale: 1.2
                }
            }
        ]

        Behavior on scale { NumberAnimation { duration: 70 } }

        MouseArea {
            id: mouseArea
            anchors.fill: planetItem
            enabled: !message.visible && !hintMode
            hoverEnabled: ApplicationInfo.isMobile ? false : true
            onEntered: planetHovered = true
            onExited: planetHovered = false
            onClicked: {
                Activity.showQuizScreen(index)
            }
        }
}
