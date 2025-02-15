/* GCompris - CandyWidget.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

WidgetOption {
    id: widget

    src: "resource/images/candy.svg"
    name: "candy"
    availableItems: (activityBackground.easyMode) ? widget.total - widget.current : ""

    property int placedInChild

    releaseElement: function() {
        var newCoordinate = widget.mapToItem(activityBackground, element.x, element.y)
        // Easy mode
        if (activityBackground.easyMode) {
            if (activityBackground.currentCandies < items.totalCandies) {
                items.acceptCandy = true

                for (var i = 0; i < listModel.count; i++) {
                    var currentChild = repeaterDropAreas.itemAt(i)
                    var childCoordinate = dropAreas.mapToItem(activityBackground, currentChild.x, currentChild.y)
                    //coordinates of "boy/girl rectangle" in background coordinates

                    var currentElement = element.parent.mapToItem(activityBackground, element.x, element.y)

                    if (currentElement.x > childCoordinate.x && currentElement.x < childCoordinate.x + currentChild.area.width &&
                    currentElement.y > childCoordinate.y + currentChild.childImage.height &&
                    currentElement.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {
                        if ((listModel.get(i).countS + 1) > items.maxNumberOfCandiesPerWidget) {
                            activityBackground.wrongMove.visible = true
                            continue
                        }
                        repeaterDropAreas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                        activityBackground.currentCandies ++
                    }

                    if (activityBackground.currentCandies == items.totalCandies) {
                        widget.canDrag = false
                        activityBackground.resetCandy()
                        candyWidget.element.opacity = 0.6
                    }
                }
            }
            else {
                widget.canDrag = false
                activityBackground.resetCandy()
                element.opacity = 0.6
            }
        }
        else {
            // Hard mode
            if (activityBackground.currentCandies < widget.total) {
                items.acceptCandy = true

                for (i = 0; i < listModel.count; i++) {
                    currentChild = repeaterDropAreas.itemAt(i)
                    childCoordinate = dropAreas.mapToItem(activityBackground, currentChild.x, currentChild.y)
                    //coordinates of "boy/girl rectangle" in background coordinates
                    currentElement = element.parent.mapToItem(activityBackground, element.x, element.y)

                    if (currentElement.x > childCoordinate.x && currentElement.x < childCoordinate.x + currentChild.area.width &&
                    currentElement.y > childCoordinate.y + currentChild.childImage.height &&
                    currentElement.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {

                        if ((listModel.get(i).countS + 1) > items.maxNumberOfCandiesPerWidget) {
                            activityBackground.wrongMove.visible = true
                            continue
                        }

                        repeaterDropAreas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                        activityBackground.currentCandies ++
                    }

                    if (activityBackground.currentCandies === items.totalCandies) {
                        widget.canDrag = false
                        activityBackground.resetCandy()
                        candyWidget.element.opacity = 0.6
                    }
                }
            }
            else {
                widget.canDrag = false
                activityBackground.resetCandy()
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
