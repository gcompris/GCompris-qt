/* GCompris - BalanceContact.qml
 *
 * SPDX-FileCopyrightText: 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
