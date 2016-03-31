/* GCompris - photo_hunter.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick port)
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
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "photo_hunter.js" as Activity

Image {
    id: card

    sourceSize.width: background.vert ? undefined : (background.width - 30) / 2
    sourceSize.height: background.vert ? (background.height - background.barHeight - 40) /2 :
                                         background.height - background.barHeight - 30

    property alias repeater: repeater
    property int good: 0
    property var name

    Repeater {
        id: repeater

        model: items.model
        Image {
            id: photo
            source: Activity.url + "images/circle.svg"
            sourceSize.width: card.width / 10
            sourceSize.height: card.height / 10

            opacity: 1

            x: modelData[0] * card.width / 1200
            y: modelData[1] * card.height / 1700


            NumberAnimation {id: crtImgAnim; target: photo; property: "scale"; from: 0; to: 1; duration: 700}
            NumberAnimation {id: otherImgAnim; property: "scale"; from: 0; to: 1; duration: 700}

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    if (img1.repeater.itemAt(index).opacity === 0 &&
                            img2.repeater.itemAt(index).opacity === 0) {
                        img1.repeater.itemAt(index).opacity = 1
                        img2.repeater.itemAt(index).opacity = 1
                        good++
                        background.checkAnswer()
                        /*The biding does not work for the target, as it will remain bound to the first image*/
                        otherImgAnim.target = card.name===img2 ? img2.repeater.itemAt(index) : img1.repeater.itemAt(index)
                        crtImgAnim.start()
                        otherImgAnim.start()
                    }
                }
            }
        }
    }
}
