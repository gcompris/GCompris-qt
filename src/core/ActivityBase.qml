/* GCompris - ActivityBase.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick 2.1
import QtQuick.Controls 1.0
import GCompris 1.0

Item {
    id: page
    property Item main: parent;
    property Component pageComponent
    property QtObject menu
    property bool isLocked: true
    signal home
    signal start
    signal pause
    signal play
    signal stop
    signal displayDialog(Item dialog)

    onHome: menu ? menu.home() : ""
    onDisplayDialog: menu ? menu.displayDialog(dialog) : ""

    Keys.onEscapePressed: home()
    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_Q) {
            Qt.quit()
        } else if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_B) {
            bar.toggle()
        }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = true
            home()
        }
    }

    Loader {
        id: activity
        sourceComponent: pageComponent
        anchors.fill: parent
    }
}
