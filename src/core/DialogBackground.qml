/* GCompris - dialogBackground.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtQuick.Controls 1.5
import GCompris 1.0

/**
 * Base QML component for all full screen dialog screens.
 * @ingroup components
 *
 * Defines the general screen layout used by the following full screen
 * dialog elements:
 *
 * DialogAbout, DialogHelp.
 *
 * For a general purpose dialog cf. GCDialog.
 *
 * @inherit QtQuick.Rectangle
 */
Rectangle {
    id: dialogBackground
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title
    property alias titleIcon: titleIcon.source
    property string content
    property string contentIcon
    property alias button0Text: button0.text
    signal close
    signal start
    signal pause
    signal play
    signal stop
    signal button0Hit

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                Row {
                    spacing: 2
                    padding: 8
                    Image {
                        id: titleIcon
                    }

                    GCText {
                        id: title
                        text: dialogBackground.title
                        width: dialogBackground.width - (70 + cancel.width)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        fontSize: 20
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                    }
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: dialogBackground.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.fill: parent
                    contentWidth: textContent.contentWidth
                    contentHeight: iconImage.height + textContent.contentHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    Button {
                        id: button0
                        visible: text != ""
                        onClicked: { dialogBackground.button0Hit() }
                        width: 150 * ApplicationInfo.ratio
                        height: visible ? 40 * ApplicationInfo.ratio : 0
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 8
                        }
                        style: GCButtonStyle {
                            theme: "highContrast"
                        }
                    }
                    
                    Image {
                        id: iconImage
                        source: contentIcon
                        visible: contentIcon != ""
                        width: 100 * ApplicationInfo.ratio
                        height: visible ? iconImage.width : 0
                        sourceSize.width: iconImage.width
                        sourceSize.height: iconImage.width
                        anchors.top: button0.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    GCText {
                        id: textContent
                        text: style + "<body>" + content + "</body>"
                        width: flick.width
                        height: flick.height - button0.height
                        anchors.top: iconImage.bottom
                        fontSize: regularSize
                        wrapMode: TextEdit.Wrap
                        textFormat: TextEdit.RichText
                        property string style: "<HEAD><STYLE type='text/css'>A {color: black;}</STYLE></HEAD>"
                    }
                }
                // The scroll buttons
                GCButtonScroll {
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * ApplicationInfo.ratio
                    anchors.bottom: flick.bottom
                    anchors.bottomMargin: 5 * ApplicationInfo.ratio
                    onUp: flick.flick(0, 1400)
                    onDown: flick.flick(0, -1400)
                    upVisible: flick.visibleArea.yPosition <= 0 ? false : true
                    downVisible: flick.visibleArea.yPosition + flick.visibleArea.heightRatio >= 1 ? false : true
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    GCButtonCancel {
        id: cancel
        onClose: parent.close()
    }

}
