/* Krita - TabContainer.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: tabContainer

    property int currentIndex: -1

    onCurrentIndexChanged: {
        var currentItem
        for(var i = 0; i < tabContainer.children.length; i++) {
            tabContainer.children[i].visible = false;
            if(i === currentIndex) {
                currentItem = tabContainer.children[i];
            }
        }
        if(currentItem) {
            currentItem.visible = true;
            currentItem.forceActiveFocus();
        }
    }
}
