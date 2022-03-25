/* GCompris - CandyWidget.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

WidgetOption {
    id: widget

    src: "resource/images/candy.svg"
    name: "candy"
    availableItems: (background.easyMode) ? widget.total - widget.current : ""

    property int placedInChild

    releaseElement: function() {
        var newCoordinate = widget.mapToItem(background, element.x, element.y)
        // Easy mode
        if (background.easyMode) {
            if (background.currentCandies < items.totalCandies) {
                items.acceptCandy = true

                for (var i = 0; i < listModel.count; i++) {
                    var currentChild = repeaterDropAreas.itemAt(i)
                    var childCoordinate = dropAreas.mapToItem(background, currentChild.x, currentChild.y)
                    //coordinates of "boy/girl rectangle" in background coordinates

                    var currentElement = element.parent.mapToItem(background, element.x, element.y)

                    if (currentElement.x > childCoordinate.x && currentElement.x < childCoordinate.x + currentChild.area.width &&
                    currentElement.y > childCoordinate.y + currentChild.childImage.height &&
                    currentElement.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {
                        if ((listModel.get(i).countS + 1) > items.maxNumberOfCandiesPerWidget) {
                            background.wrongMove.visible = true
                            continue
                        }
                        repeaterDropAreas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                        background.currentCandies ++
                    }

                    if (background.currentCandies == items.totalCandies) {
                        widget.canDrag = false
                        background.resetCandy()
                        candyWidget.element.opacity = 0.6
                    }
                }
            }
            else {
                widget.canDrag = false
                background.resetCandy()
                element.opacity = 0.6
            }
        }
        else {
            // Hard mode
            if (background.currentCandies < widget.total) {
                items.acceptCandy = true

                for (i = 0; i < listModel.count; i++) {
                    currentChild = repeaterDropAreas.itemAt(i)
                    childCoordinate = dropAreas.mapToItem(background, currentChild.x, currentChild.y)
                    //coordinates of "boy/girl rectangle" in background coordinates
                    currentElement = element.parent.mapToItem(background, element.x, element.y)

                    if (currentElement.x > childCoordinate.x && currentElement.x < childCoordinate.x + currentChild.area.width &&
                    currentElement.y > childCoordinate.y + currentChild.childImage.height &&
                    currentElement.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {

                        if ((listModel.get(i).countS + 1) > items.maxNumberOfCandiesPerWidget) {
                            background.wrongMove.visible = true
                            continue
                        }

                        repeaterDropAreas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                        background.currentCandies ++
                    }

                    if (background.currentCandies === items.totalCandies) {
                        widget.canDrag = false
                        background.resetCandy()
                        candyWidget.element.opacity = 0.6
                    }
                }
            }
            else {
                widget.canDrag = false
                background.resetCandy()
                candyWidget.element.opacity = 0.6
            }
        }
    }

    //swing animation for candies
    SequentialAnimation {
        id: anim
        running: items.acceptCandy ? true : false
        loops: Animation.Infinite
        NumberAnimation {
            target: candyWidget.element
            property: "rotation"
            from: -10; to: 10
            duration: 700
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: candyWidget.element
            property: "rotation"
            from: 10; to: -10
            duration: 700
            easing.type: Easing.InOutQuad
        }
    }

}
