/* GCompris - LightBulb.qml
 *
 * SPDX-FileCopyrightText: 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import core 1.0
import "binary_bulb.js" as Activity

Item {
    id: bulb
    state: "off"
    focus: true

    property int position
    property alias valueVisible: valueText.visible

    GCText {
        id: valueText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - GCStyle.halfMargins
        height: parent.height * 0.2 - GCStyle.halfMargins
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: bulb.value
        color: GCStyle.whiteText
    }

    Image {
        id: bulbImage
        width: valueText.width
        height: parent.height * 0.4 - GCStyle.halfMargins
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: "resource/bulb_off.svg"
        anchors.top: valueText.bottom
        anchors.topMargin: GCStyle.halfMargins
        anchors.horizontalCenter: parent.horizontalCenter
    }
    property string bit: ""
    readonly property int value: Math.pow(2, items.numberOfBulbs - position - 1)

    MouseArea {
        anchors.fill: parent
        enabled: !items.buttonsBlocked
        onClicked: Activity.changeState(bulb.position)
    }

    Rectangle {
        anchors.top: bitText.top
        anchors.bottom: bitText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: GCStyle.whiteBg
        opacity: 0.5
    }

    GCText {
        id: bitText
        width: valueText.width
        anchors.top: bulbImage.bottom
        anchors.topMargin: GCStyle.halfMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GCStyle.baseMargins
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        text: bulb.bit
        color: GCStyle.darkText
    }

    Rectangle {
        color: "transparent"
        anchors.fill: parent
        border.color: GCStyle.highlightColor
        border.width: GCStyle.thinBorder
        radius: GCStyle.tinyMargins
        visible: bulb.position == items.currentSelectedBulb
    }

    states: [
        State {
            name: "off"
            PropertyChanges {
                bulb {
                    bit: "0"
                }
            }
            PropertyChanges {
                bulbImage {
                    source: "resource/bulb_off.svg"
                }
            }
        },
        State {
            name: "on"
            PropertyChanges {
                bulb {
                    bit: "1"
                }
            }
            PropertyChanges {
                bulbImage {
                    source: "resource/bulb_on.svg"
                }
            }
        }
    ]
}
