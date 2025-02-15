/* GCompris - BasketWidget.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0


WidgetOption {
    id: widget

    src: "resource/images/basket.svg"
    name: "basket"
    availableItems: ""

    releaseElement: function() {
        var newCoordinate = widget.mapToItem(activityBackground, element.x, element.y)
        if (activityBackground.contains(newCoordinate.x, newCoordinate.y, grid)) {
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
