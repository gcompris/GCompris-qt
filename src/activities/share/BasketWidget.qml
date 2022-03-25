/* GCompris - BasketWidget.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
                widget.element.opacity = 0.6
                listModel.append({countS: 0, nameS: "basket"});
            }
        }
    }

    element {
        opacity: 0
    }
}
