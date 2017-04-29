/* GCompris - BasketWidget.qml
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0

import "../../core"

WidgetOption {
    id: widget

    src: "resource/images/basket.svg"
    name: "basket"
    availableItems: ""

    releaseElement: function() {
        var newCoordinate = widget.mapToItem(background, element.x, element.y)
        if (background.contains(newCoordinate.x, newCoordinate.y, grid)) {
            if (widget.canDrag) {
                widget.canDrag = false
                widget.element.opacity = 0
                listModel.append({countS: 0, nameS: "basket"});
            }
        }
    }

    element {
        opacity: 0
        Behavior on opacity { PropertyAnimation { duration: 500 } }
    }
}
