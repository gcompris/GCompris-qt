/* gcompris - SudokuListWidget.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.1
import GCompris 1.0
import "sudoku.js" as Activity

Item {

    property alias model: mymodel;
    property alias view: view;

    width: view.width
    height: view.height

    ListModel {
        id: mymodel
    }

    ListView {
        id: view
        width: background.width/5
        height: background.height- 2*bar.height

        Component {
            id: contactsDelegate
            Rectangle {
                color: ListView.isCurrentItem ? "#AA666666" : "transparent"
                border.color: ListView.isCurrentItem ? "black" : "transparent"
                border.width: 3
                radius: icon.width / 10
                width: 1.2*icon.width
                height: 1.2*icon.height

                Image {
                    id: icon
                    anchors.centerIn: parent
                    sourceSize.height: 100 * ApplicationInfo.ratio
                    source: {
                        imgName == undefined ? "" :
                                               Activity.url+imgName+extension
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: view.currentIndex = index
                    }
                }
            }
        }

        clip: true
        spacing: 10
        model: mymodel
        delegate: contactsDelegate
    }
}
