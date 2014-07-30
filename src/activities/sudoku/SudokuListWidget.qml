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

Item {

    property alias model: mymodel;
    property alias view: view;

    ListModel {
        id: mymodel
    }

    ListView {
        id: view
        width: background.width/5
        height: background.height- 2*bar.height

        Component {
            id: contactsDelegate
            Image {
                id: icon
                sourceSize.height: 100 * ApplicationInfo.ratio
                source: {
                    imgName == undefined ? "" :
                    ListView.isCurrentItem ? "qrc:/gcompris/src/activities/sudoku/resource/"+imgName+".png"
                                           : "qrc:/gcompris/src/activities/sudoku/resource/"+imgName+"_grey.png"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: view.currentIndex = index
                }
            }
        }

        clip: true
        spacing: 20
        model: mymodel
        delegate: contactsDelegate
    }
}
