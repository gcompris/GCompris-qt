/* GCompris - VirtualKey.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
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
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4

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
        
        style: ButtonStyle {
            background: Rectangle {
                border.width: control.activeFocus ? 2 : 1
                border.color: "black"
                radius: 4
                gradient: Gradient {
                    GradientStop {
                        position: 0;
                        color: (control.pressed
                                || ( virtualKey.specialKey == Qt.Key_Shift 
                                     && virtualKey.modifiers & Qt.ShiftModifier))
                               ? "#ccc" : "#eee";
                    }
                    GradientStop {
                        position: 1;
                        color: (control.pressed
                                || ( virtualKey.specialKey == Qt.Key_Shift 
                                        && virtualKey.modifiers & Qt.ShiftModifier))
                               ? "#aaa" : "#ccc";
                    }
                }
            }
            label: Item {
                GCText {
                    //renderType: Text.NativeRendering
                    anchors.centerIn: parent
                    text: control.text
                    fontSize: 20
                    font.bold: false
                    color: "black"
                    //antialiasing: true
                }
            }
        }
    
        SequentialAnimation {
            id: anim
            PropertyAction { target: virtualKey; property: 'z'; value: 1 }
            NumberAnimation { target: button; properties: "scale"; to: 1.3; duration: 100; easing.type: Easing.OutCubic }
            NumberAnimation { target: button; properties: "scale"; to: 1.0; duration: 100; easing.type: Easing.OutCubic }
            PropertyAction { target: virtualKey; property: 'z'; value: 0 }
        }

        onClicked: {
            //console.log("### virtualKey.onClicked text=" + virtualKey.text 
            //        + " specialKey="+ virtualKey.specialKey
            //        + " modifiers= "+ virtualKey.modifiers);
            anim.start()
            virtualKey.pressed(virtualKey);
            button.focus = false;
        }
    }
    
    DropShadow {
        anchors.fill: button
        cached: false
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 16
        color: "#80000000"
        source: button
        scale: button.scale
    }
}
