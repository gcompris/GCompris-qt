/* GCompris - ChildWidget.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

WidgetOption {
    id: widget

    src: "resource/images/" + name + ".svg"
    availableItems: (background.easyMode) ? widget.total - widget.current : ""

    property int placedInChild

    releaseElement: function() {
        var newCoordinate = widget.mapToItem(background, element.x, element.y)
        if (background.contains(newCoordinate.x, newCoordinate.y, grid)) {
            if (widget.current < widget.total) {
                if (widget.canDrag) {
                    widget.current ++
                    listModel.append({countS: 0, nameS: widget.name});

                    // set the candies already "present"
                    repeaterDropAreas.itemAt(listModel.count-1).candyCount.text = placedInChild
                    listModel.setProperty(listModel.count-1, "countS", placedInChild)

                    if (widget.current === widget.total) {
                        widget.canDrag = false
                        element.opacity = 0.6
                    }
                }
            }
            else {
                widget.canDrag = false
            }
        }
    }
}
