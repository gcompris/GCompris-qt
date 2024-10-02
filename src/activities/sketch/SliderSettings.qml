/* GCompris - SliderSettings.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "../../core"

Item {
    id: sliderSettings
    // NOTE: don't forget to set width and height when using it...

    property real controlsHeight: 10
    property alias labelText: sliderLabel.text
    property alias from: slider.from
    property alias to: slider.to
    property alias stepSize: slider.stepSize
    property alias value: slider.value

    property alias source: infoImage.source
    property alias sourceRotation: infoImage.rotation
    property alias sourceMirror: infoImage.mirror
    property bool useImageInfo: false

    signal sliderMoved()

    Column {
        GCText {
            id: sliderLabel
            text: ""
            color: items.contentColor
            width: sliderSettings.width - sliderInfo.width - items.baseMargins * 2
            height: sliderSettings.controlsHeight
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignBottom
        }
        Item {
            width: sliderSettings.width
            height: sliderSettings.controlsHeight
            GCSlider {
                id: slider
                width: sliderLabel.width
                from: 0.1
                to: 1
                stepSize: 0.1
                value: 0.5
                onMoved: {
                    sliderSettings.sliderMoved();
                }
            }
            Rectangle {
                id: sliderInfo
                anchors.left: slider.right
                anchors.leftMargin: items.baseMargins
                anchors.bottom: slider.bottom
                width: sliderSettings.controlsHeight * 1.5
                height: width
                color: "transparent"
                border.color: items.contentColor

                Image {
                    id: infoImage
                    visible: sliderSettings.useImageInfo
                    anchors.centerIn: parent
                    width: parent.width - items.baseMargins
                    height: width
                    sourceSize.width: width
                    sourceSize.height: width
                    fillMode: Image.PreserveAspectFit
                    source: ""
                    opacity: slider.value
                }

                GCText {
                    visible: !sliderSettings.useImageInfo
                    text: slider.value
                    color: items.contentColor
                    anchors.centerIn: parent
                    width: parent.width - items.baseMargins
                    height: width
                    fontSize: regularSize
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
