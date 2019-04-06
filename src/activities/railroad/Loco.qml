/* GCompris - Loco.qml
 *
 * Copyright (C) 2017 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@kde.org> (Qt Quick port)
 *   Amit Sagtani <asagtani06@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "railroad.js" as Activity

Item {
    id: draggedItem
    property string imageURL
    Image {
        id: img
        source: imageURL
        height: background.height / 8.0
        width: ((background.width >= background.height) ? background.width : background.height) / 5.66
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2
    }
    function destroy() {
        // Destroy this copy object on drop
        draggedItem.destroy();
    }
}


