/* GCompris - Clients.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
import GCompris 1.0

import "../../core"

ActivityBase {
    id: activity

    activityInfo: QtObject {
        property bool demo: false
    }

    function loadActivity() {
        activityLoader.item.loading = loading
        activityLoader.item.menu = activity
        pageView.push(activityLoader.item)
    }

    Loader {
        id: activityLoader
        asynchronous: true
        onStatusChanged: {
            if (status == Loader.Loading) {
                loading.start();
            } else if (status == Loader.Ready) {
                loading.stop();
                loadActivity();
            } else if (status == Loader.Error)
                loading.stop();
        }
    }

    Loading {
        id: loading
    }


    pageComponent: Item {
        anchors.fill: parent
        GridView {
            id: clients
            width: parent.width
            height: parent.height - (bar.height * 2)
            cellWidth: parent.width/10
            cellHeight: cellWidth
            property string currentClient: ""
            model: MessageHandler.clients
            delegate: Rectangle {
                id: delegate
                width: clients.cellWidth/1.25
                height: width
                color: "red"
                GCText {
                    text: modelData.user ? modelData.user.name : "unnamed"
                }

            }

        }

        Bar {
            id: bar
            content: BarEnumContent { value: home }
            onHomeClicked: activity.home()
        }
    }
}
