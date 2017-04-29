/* GCompris - BalanceContact.qml
 *
 * Copyright (C) 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
import Box2D 2.0

import "../../core"
import "balancebox.js" as Activity

BalanceItem {
    id: item

    property var pressed: false
    property int orderNum
    property alias text: itemText.text
    
    imageSource: pressed ? Activity.baseUrl + "/button-pressed.svg"
                           : Activity.baseUrl + "/button-normal.svg"

    GCText {
        id: itemText
        
        anchors.fill: item
        anchors.centerIn: item
        
        width: item.width
        height: item.height
        
        font.pointSize: NaN
        font.pixelSize: width / 2
        
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

}
