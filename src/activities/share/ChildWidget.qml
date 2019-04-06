/* GCompris - ChildWidget.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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

WidgetOption {
    id: widget

    src: "resource/images/" + name + ".svg"
    availableItems: (background.showCount && background.easyMode) ?
                           widget.total - widget.current : ""

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
