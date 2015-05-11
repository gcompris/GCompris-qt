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
import QtQuick 2.2
import QtQuick.Controls 1.0
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
    signal close
    signal start
    signal pause
    signal play
    signal stop

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

                Image {
                    id: titleIcon
                    anchors {
                        left: parent.left
                        top: parent.top
                        margins: 4 * ApplicationInfo.ratio
                    }
                }

                GCText {
                    id: title
                    text: dialogBackground.title
                    width: dialogBackground.width - 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    fontSize: 20
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
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
                    contentHeight: textContent.contentHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    GCText {
                        id: textContent
                        text: style + "<body>" + content + "</body>"
                        width: flick.width
                        height: flick.height
                        fontSize: regularSize
                        wrapMode: TextEdit.Wrap
                        textFormat: TextEdit.RichText
                        Component.onCompleted: ApplicationInfo.isDownloadAllowed ?
                                                   linkActivated.connect(Qt.openUrlExternally) : null

                        property string style: ApplicationInfo.isDownloadAllowed ?
                                                   "<HEAD><STYLE type='text/css'>A {color: blue;}</STYLE></HEAD>" :
                                                   "<HEAD><STYLE type='text/css'>A {color: black;}</STYLE></HEAD>"
                    }
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    GCButtonCancel {
        onClose: parent.close()
    }

}
