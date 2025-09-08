/* GCompris - ServerConfigPage.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: dialogBackground
    color: GCStyle.configBg
    z: 10000
    anchors.fill: parent
    visible: false
    focus: visible

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Down) {
            scrollItem.down();
        } else if(event.key === Qt.Key_Up) {
            scrollItem.up();
        }
    }

    Keys.onEscapePressed: close()

    signal close

    onClose: {
        parent.forceActiveFocus();
    }

    property bool horizontalLayout: dialogBackground.width >= dialogBackground.height

    property alias teacherId: teacherIdInput.text
    property alias teacherPort: teacherPortInput.text

    Column {
        spacing: GCStyle.halfMargins
        anchors.top: parent.top
        anchors.topMargin: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        width: dialogBackground.width - 2 * GCStyle.baseMargins
        Rectangle {
            id: titleRectangle
            color: GCStyle.lightBg
            radius: GCStyle.baseMargins
            width: parent.width
            height:  Math.max(title.height, cancel.height) + GCStyle.baseMargins

            GCText {
                id: title
                text: qsTr("Teacher's server settings")
                width: titleRectangle.width - (cancel.width + cancel.anchors.margins) * 2
                height: 50 * ApplicationInfo.ratio
                anchors.horizontalCenter: titleRectangle.horizontalCenter
                anchors.verticalCenter: titleRectangle.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: largeSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }
            // The cancel button
            GCButtonCancel {
                id: cancel
                anchors.top: undefined
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: GCStyle.tinyMargins
                apply: true
                onClose: dialogBackground.close()
            }
        }

        Rectangle {
            color: GCStyle.lightTransparentBg
            radius: GCStyle.baseMargins
            width: parent.width
            height: dialogBackground.height - (2 * parent.anchors.topMargin) - titleRectangle.height - parent.spacing
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.midBorder

            Flickable {
                id: flick
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                contentHeight: childrenRect.height
                flickableDirection: Flickable.VerticalFlick
                maximumFlickVelocity: dialogBackground.height
                boundsBehavior: Flickable.StopAtBounds
                pixelAligned: true
                clip: true

                Column {
                    id: contentColumn
                    spacing: GCStyle.baseMargins
                    width: parent.width - scrollItem.width - GCStyle.baseMargins

                    GCText {
                        id: teacherIdLabel
                        text: qsTr("Teacher's identifier")
                        fontSize: mediumSize
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }

                    Rectangle {
                        id: teacherIdBg
                        height: GCStyle.smallButtonHeight
                        width: parent.width
                        radius: GCStyle.halfMargins
                        border.width: GCStyle.thinnestBorder
                        border.color: GCStyle.grayBorder
                        color: GCStyle.lightBg

                        TextInput {
                            id: teacherIdInput
                            height: parent.height
                            width: parent.width - GCStyle.baseMargins
                            anchors.centerIn: parent
                            font.pixelSize: height * 0.5
                            verticalAlignment: TextInput.AlignVCenter

                            onTextEdited: {
                                dialogActivityConfig.configItem.teacherId = teacherIdInput.text;
                            }
                        }
                    }

                    GCText {
                        id: teacherPortLabel
                        text: qsTr("Server port")
                        fontSize: mediumSize
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }

                    Rectangle {
                        id: teacherPortBg
                        height: GCStyle.smallButtonHeight
                        width: parent.width
                        radius: GCStyle.halfMargins
                        border.width: GCStyle.thinnestBorder
                        border.color: GCStyle.grayBorder
                        color: GCStyle.lightBg

                        TextInput {
                            id: teacherPortInput
                            height: parent.height
                            width: teacherIdInput.width
                            anchors.centerIn: parent
                            font.pixelSize: height * 0.5
                            verticalAlignment: TextInput.AlignVCenter
                            validator: IntValidator {bottom: 0; top: 65535}

                            onTextEdited: {
                                if(parseInt(teacherPortInput.text) > 65535) {
                                    teacherPortInput.text = 65535;
                                }
                                dialogActivityConfig.configItem.teacherPort = teacherPortInput.text;
                            }
                        }
                    }

                    GCText {
                        id: portRangeInfo
                        text: qsTr("Server port must be a number between 0 and 65535.")
                        fontSize: smallSize
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                }
            }

            // The scroll buttons
            GCButtonScroll {
                id: scrollItem
                anchors.right: parent.right
                anchors.rightMargin: GCStyle.halfMargins
                anchors.bottom: flick.bottom
                anchors.bottomMargin: GCStyle.halfMargins
                onUp: flick.flick(0, 1000)
                onDown: flick.flick(0, -1000)
                upVisible: flick.atYBeginning ? false : true
                downVisible: flick.atYEnd ? false : true
            }
        }
    }
}

