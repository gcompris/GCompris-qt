/* GCompris - tutorial5.qml
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0 

import "../../../core"

Rectangle {
    anchors.fill: parent
    color: "#80FFFFFF"

    GCText {
        id: topBlock
        readonly property int bulbWidth: Math.min(70 * ApplicationInfo.ratio, width * 0.125)
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
            margins: GCStyle.halfMargins
        }
        height: (parent.height - 6 * GCStyle.halfMargins) * 0.2
        text: qsTr("0 to 255 with")
        fontSizeMode: Text.Fit
        color: GCStyle.darkerText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
    }

    Row {
        id: tableBlock1
        width: topBlock.bulbWidth * 8
        height: topBlock.height
        anchors.top: topBlock.bottom
        anchors.topMargin: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: ["128", "64", "32", "16", "8", "4", "2", "1"]
            GCText {
                required property string modelData
                width: topBlock.bulbWidth
                height: parent.height
                text: modelData
                fontSizeMode: Text.Fit
                color: GCStyle.darkText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
            }
        }
    }

    Row {
        id: tableBlock2
        width: tableBlock1.width
        height: tableBlock1.height
        anchors.verticalCenter: tableBlock1.top
        anchors.horizontalCenter: tableBlock1.horizontalCenter
        anchors.horizontalCenterOffset: width / 16
        Repeater {
            model: 7
                Item {
                    width: topBlock.bulbWidth
                    height: parent.height
                    Image {
                        source: "multipleTwo.svg"
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent
                        anchors.margins: GCStyle.tinyMargins
                        sourceSize.height: height
                    }
                }
        }
    }

    Row {
        id: bulbBlock
        width: tableBlock1.width
        height: Math.min(width / 8 * 1.33, topBlock.height * 2)
        anchors.top: tableBlock1.bottom
        anchors.topMargin: GCStyle.halfMargins
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: ["off", "off", "off", "off", "off", "off", "off", "off"]
            Image {
                required property string modelData
                source: "bulb_" + modelData + ".svg"
                fillMode: Image.PreserveAspectFit
                width: topBlock.bulbWidth
                height: parent.height
                sourceSize.width: width
            }
        }
    }

    Row {
        id: bitsBlock
        width: tableBlock1.width
        height: topBlock.height
        anchors.top: bulbBlock.bottom
        anchors.topMargin: GCStyle.halfMargins
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: ["0", "0", "0", "0", "0", "0", "0", "0"]
            GCText {
                required property string modelData
                width: topBlock.bulbWidth
                height: parent.height
                text: modelData
                fontSizeMode: Text.Fit
                color: GCStyle.darkerText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
            }
        }
    }
}
