/* GCompris - VirtualKey.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQuick.Controls.Basic

Item {
    id: virtualKey
    
    property alias text: button.text
    property var modifiers: 0   /* Supposed to hold any active key modifiers
                                 * in a bitmask from the Qt namespace:
                                 * Qt.ShiftModifier/MetaModifier/ControlModifier.
                                 * 0 if none. */

    property var specialKey: 0  /* Supposed to hold special key values from the
                                 * Qt namespace like Qt.Key_Shift/Key_Control/
                                 * Key_Alt if VirtualKey is a special key.
                                 * 0 Otherwise */

    signal pressed(var virtualKey);

    Button {
        id: button
        text: ((modifiers & Qt.ShiftModifier) && (shiftLabel !== undefined)) ? shiftLabel : label

        width: parent.width
        height: virtualKey.height

        scale: pressed ? 0.9 : 1
        
        background: Rectangle {
            border.width: button.pressed ? GCStyle.thinBorder : GCStyle.thinnestBorder
            border.color: GCStyle.darkBorder
            radius: GCStyle.thinBorder
            color: (button.pressed ||
                (virtualKey.specialKey == Qt.Key_Shift && virtualKey.modifiers & Qt.ShiftModifier)) ? "#aaa" : "#eee";
        }
        contentItem: Item {
            GCText {
                anchors.fill: parent
                text: button.text
                fontSize: 20
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                color: GCStyle.darkerText
            }
        }

        onClicked: {
            //console.log("### virtualKey.onClicked text=" + virtualKey.text 
            //        + " specialKey="+ virtualKey.specialKey
            //        + " modifiers= "+ virtualKey.modifiers);
            virtualKey.pressed(virtualKey);
            button.focus = false;
        }
    }
}
