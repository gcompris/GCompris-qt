/* GCompris - Loco.qml
 *
 * SPDX-FileCopyrightText: 2017 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@kde.org> (Qt Quick port)
 *   Amit Sagtani <asagtani06@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

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


